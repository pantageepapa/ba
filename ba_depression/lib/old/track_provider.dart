import 'dart:async';

import 'package:ba_depression/models/track.dart';
import 'package:ba_depression/services/spotify_api.dart';
import 'package:flutter/material.dart';

class TrackProvider extends ChangeNotifier {
  Track _track = Track(
      artistName: "",
      trackName: "",
      id: "",
      trackImageUrl: "",
      playedAt: DateTime.now(),
      isPlaying: false);

  Track? get track => _track;
  Timer? _timer;

  Future<bool> getCurrenTrack() async {
    Track? track_new = await SpotifyApi.getCurrentTrack();
    if (track_new == null) {
      return false;
    } else if (_track == null) {
      _track = track_new;
      notifyListeners();
      return true;
    } else if (track_new.id == _track.id) {
      return false;
    } else {
      _track = track_new;
      notifyListeners();
      return true;
    }
  }

  Future<bool> setTimer() async {
    await getCurrenTrack();

    _timer = Timer.periodic(
        Duration(seconds: 10), (Timer t) async => await getCurrenTrack());

    return true;
  }
}
