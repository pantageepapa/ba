import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Track {
  const Track(
      {required this.artistName,
      required this.trackName,
      required this.id,
      required this.trackImageUrl,
      required this.isPlaying});

  final String trackName;
  final String? trackImageUrl;
  final String artistName;
  final bool isPlaying;
  final String id;

  static String context = 'context';
  static String position = 'position';
  static String deviceId = 'device_id';

  static Track? fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    final id = json['item']['id'];
    final isPlaying = json['is_playing'];
    final trackName = json['item']['name'];
    final artistName = json['item']['artists'].length != 0
        ? json['item']['artists'][0]['name']
        : "Unknown Artist";

    final trackImageUrl = json['item']['album']['images'].length != 0
        ? json['item']['album']['images'][0]['url']
        : null;
    return Track(
        id: id,
        artistName: artistName,
        trackName: trackName,
        trackImageUrl: trackImageUrl,
        isPlaying: isPlaying);
  }

  static List<Track>? fromJsonRecentlyPlayed(Map<String, dynamic>? json) {
    if (json == null) return null;

    List<Track> tracks = [];

    for (int i = 0; i < json['items'].length; i++) {
      final id = json['items'][i]['track']['id'];
      final trackName = json['items'][i]['track']['name'];
      final artistName = json['items'][i]['track']['artists'].length != 0
          ? json['items'][i]['track']['artists'][0]['name']
          : "Unknown Artist";
      final trackImageUrl =
          json['items'][i]['track']['album']['images'].length != 0
              ? json['items'][i]['track']['album']['images'][0]['url']
              : null;
      Track track = Track(
          id: id,
          artistName: artistName,
          trackName: trackName,
          trackImageUrl: trackImageUrl,
          isPlaying: true);
      tracks.add(track);
    }
    return tracks;
  }

  static Future<void> saveCurrentSong(Map<String, dynamic> json) async {
    String songContext = json['item']['album']['uri'];
    String deviceId = json['device']['id'];

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(context, songContext);
      await prefs.setString(Track.deviceId, deviceId);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  static Future<List<String?>?> readCurrentSong() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? songContext = prefs.getString(context);
      String? deviceId = prefs.getString(Track.deviceId);
      if (songContext == null) {
        return null;
      }
      return [songContext, deviceId];
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  // Map<String, dynamic> toJson() => {
  //       'display_name': name,
  //       'images': [
  //         {'url': avatarImageUrl}
  //       ],
  //       'id': id
  //     };

}
