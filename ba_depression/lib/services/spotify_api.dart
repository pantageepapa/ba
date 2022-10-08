import 'dart:convert';

import 'package:ba_depression/models/artist.dart';
import 'package:ba_depression/models/user.dart';
import 'package:ba_depression/services/api_path.dart';
import 'package:ba_depression/services/spotify_interceptor.dart';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/audio_features.dart';
import '../models/track.dart';

class SpotifyApi {
  static Client client = InterceptedClient.build(interceptors: [
    SpotifyInterceptor(),
  ], retryPolicy: ExpiredTokenRetryPolicy());

  static Future<User?> getCurrentUser() async {
    final response = await client.get(
      Uri.parse(APIPath.getCurrentUser),
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to get user with status code ${response.statusCode}');
    }
  }

  static Future<Track?> getCurrentTrack() async {
    final response = await client.get(Uri.parse(APIPath.getCurrentTrack));

    if (response.statusCode == 200) {
      print("current Track called");
      await Track.saveCurrentSong(json.decode(response.body));
      return Track.fromJson(json.decode(response.body));
    } else if (response.statusCode == 204) {
      return Track(
          artistName: "",
          trackName: "",
          id: "",
          trackImageUrl: "",
          playedAt: DateTime.now(),
          isPlaying: false);
    } else {
      throw Exception(
          'Failed to get current track with status code ${response.statusCode}');
    }
  }

  static Future<List<Track>?> getRecentlyPlayed(int limit) async {
    final response = await client
        .get(Uri.parse('${APIPath.getRecentlyPlayed}?limit=$limit'));
    if (response.statusCode == 200) {
      print("recently Played called");
      List<Track>? tracks =
          Track.fromJsonRecentlyPlayed(json.decode(response.body));

      return tracks;
    } else {
      throw Exception(
          'Failed to get recently played tracks with status code ${response.statusCode}');
    }
  }

  static Future<List<Artist>?> getTopArtists() async {
    final response = await client.get(Uri.parse(APIPath.getTopArtists));
    if (response.statusCode == 200) {
      print("top Artists called");
      List<Artist>? artists = Artist.fromJson(json.decode(response.body));
      return artists;
    } else {
      throw Exception(
          'Failed to get top artists with status code ${response.statusCode}');
    }
  }

  static Future<AudioFeatures?> getAudioFeatures(String id) async {
    final response = await client.get(Uri.parse(APIPath.audioFeatures + id));

    if (response.statusCode == 200) {
      print("audio features called");
      if (response.body == '') {
        return null;
      }
      AudioFeatures? audioFeatures =
          AudioFeatures.fromJson(json.decode(response.body));
      return audioFeatures;
    } else {
      throw Exception(
          'Failed to get top artists with status code ${response.statusCode}');
    }
  }

  static pause() async {
    final response = await client.put(Uri.parse(APIPath.pausePlayback));
    if (response.statusCode == 204) {
      print('Successfully paused');
      return;
    } else {
      throw Exception(
          'Failed to pause current track with status code ${response.statusCode}');
    }
  }

  static skip() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(Track.deviceId);

    if (deviceId != null) {
      final response = await client
          .post(Uri.parse('${APIPath.nextTrack}?device_id=$deviceId'));
      if (response.statusCode == 204) {
        print('Successfully skipped');
        return;
      } else {
        print(response.body);
        throw Exception(
            'Failed to skip current track with status code ${response.statusCode}');
      }
    }
  }

  static previous() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(Track.deviceId);

    if (deviceId != null) {
      final response = await client
          .post(Uri.parse('${APIPath.previousTrack}?device_id=$deviceId'));
      if (response.statusCode == 204) {
        print('Successfully skipped');
        return;
      } else {
        print(response.body);
        throw Exception(
            'Failed to skip current track with status code ${response.statusCode}');
      }
    }
  }

  static play() async {
    final prefs = await SharedPreferences.getInstance();
    String? context = prefs.getString(Track.context);
    String? deviceId = prefs.getString(Track.deviceId);

    if (deviceId != null && context != null) {
      final body = {
        'context_uri': context,
        'position_ms': 0,
        'offset': {'position': 2}
      };
      print(json.encode(body));
      final response = await client.put(Uri.parse('${APIPath.pausePlayback}'),
          body: json.encode(body));
      if (response.statusCode == 204) {
        print('Successfully played');
        return;
      } else {
        print(response.body);
        throw Exception(
            'Failed to play current track with status code ${response.statusCode}');
      }
    } else {
      throw Exception('Error while playing: No saved song found');
    }
  }
}
