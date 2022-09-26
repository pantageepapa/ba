import 'dart:convert';

import 'package:ba_depression/models/user.dart';
import 'package:ba_depression/services/api_path.dart';
import 'package:ba_depression/services/spotify_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

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
      print(response.body);
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
      print("current Track called");
      return Track(
          artistName: "",
          trackName: "",
          id: "",
          trackImageUrl: "",
          isPlaying: false);
    } else {
      print(response.body);
      throw Exception(
          'Failed to get current track with status code ${response.statusCode}');
    }
  }

  static pause() async {
    final response = await client.put(Uri.parse(APIPath.pausePlayback));
    if (response.statusCode == 204) {
      print('Successfully paused');
      return;
    } else {
      print(response.body);
      throw Exception(
          'Failed to pause current track with status code ${response.statusCode}');
    }
  }

  static play() async {
    var songContextAndDeviceId = await Track.readCurrentSong();
    if (songContextAndDeviceId == null) {
      return null;
    }
    final body = {
      'context_uri': songContextAndDeviceId[0],
      //'device_id': songContextAndDeviceId[1],
      'position_ms': 0
    };
    print(json.encode(body));
    final response = await client.put(Uri.parse(APIPath.pausePlayback),
        body: json.encode(body));
    if (response.statusCode == 204) {
      print('Successfully played');
      return;
    } else {
      print(response.body);
      throw Exception(
          'Failed to play current track with status code ${response.statusCode}');
    }
  }
}
