import 'package:flutter/foundation.dart';

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

    // final name = json['display_name'];
    // final avatarImageUrl =
    //     json['images'].length != 0 ? json['images'][0]['url'] : null;
    // final id = json['id'];
    return Track(
        id: id,
        artistName: artistName,
        trackName: trackName,
        trackImageUrl: trackImageUrl,
        isPlaying: isPlaying);
  }

  // Map<String, dynamic> toJson() => {
  //       'display_name': name,
  //       'images': [
  //         {'url': avatarImageUrl}
  //       ],
  //       'id': id
  //     };

}
