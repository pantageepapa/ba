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

  /*It reads the user data (display name, profile picture and Spotify id) and 
  returns a User object*/

  static Future<User?> getCurrentUser() async {
    final response = await client.get(
      Uri.parse(APIPath.getCurrentUser),
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      print('Failed to get user with status code ${response.statusCode}');
      return null;
    }
  }

  /*It reads the currently played track data (artist name, track name, track ima
  ge URL, and current time) and returns a Track object. If there is no currently 
  playing track, the error code 204 is returned, the method returns a Track object 
  with dummy values, and playing now is set to false.*/

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
      print(
          'Failed to get current track with status code ${response.statusCode}');
      return null;
    }
  }

  /*This method reads the recently played songs of the user. The number of songs 
  can be defined in the request. However, the maximum amount of recently played 
  songs is limited to 50 by Spotify API. The method returns a list of Track objects.*/

  static Future<List<Track>?> getRecentlyPlayed(int limit) async {
    final response = await client
        .get(Uri.parse('${APIPath.getRecentlyPlayed}?limit=$limit'));
    if (response.statusCode == 200) {
      print("recently Played called");
      List<Track>? tracks =
          Track.fromJsonRecentlyPlayed(json.decode(response.body));

      return tracks;
    } else {
      print(
          'Failed to get recently played tracks with status code ${response.statusCode}');
      return null;
    }
  }

  /*It gets the top 5 favorite artists of the user, thereby collecting the artist 
  name and artist image URL. */
  static Future<List<Artist>?> getTopArtists() async {
    final response = await client.get(Uri.parse(APIPath.getTopArtists));
    if (response.statusCode == 200) {
      print("top Artists called");
      List<Artist>? artists = Artist.fromJson(json.decode(response.body));
      return artists;
    } else {
      print(
          'Failed to get top artists with status code ${response.statusCode}');

      return null;
    }
  }

  /*It reads the audio features of the song with the specified id. It returns the 
  object AudioFeatures, which contains information about tempo, valence, id, and 
  duration of the track with the specified id.*/
  static Future<AudioFeatures?> getAudioFeatures(String id) async {
    final response = await client.get(Uri.parse(APIPath.audioFeatures + id));

    if (response.statusCode == 200) {
      if (response.body == '') {
        return null;
      }
      AudioFeatures? audioFeatures =
          AudioFeatures.fromJson(json.decode(response.body));
      return audioFeatures;
    } else {
      print(
          'Failed to get top artists with status code ${response.statusCode}');
      return null;
    }
  }

  /*The method pauses the playback on the user’s account if a song is playing. */
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

  /*The method skips the currently playing song. */
  static skip() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(Track.deviceId);

    if (deviceId != null) {
      final response = await client
          .post(Uri.parse('${APIPath.nextTrack}?device_id=$deviceId'));
      if (response.statusCode == 204) {
        return;
      } else {
        print(response.body);
        throw Exception(
            'Failed to skip current track with status code ${response.statusCode}');
      }
    } else {
      throw Exception('Failed to skip current track as no device is connected');
    }
  }

  /*The method skips to the previous song in the user’s queue.*/
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
}
