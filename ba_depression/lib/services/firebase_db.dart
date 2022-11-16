import 'dart:ffi';
import 'dart:math';

import 'package:ba_depression/models/audio_features.dart';
import 'package:ba_depression/services/spotify_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/track.dart';
import '../models/user.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(String uid) async {
    await _firestore.collection('songs').doc(uid).set({'songs': []});

    await _firestore.collection('moods').doc(uid).set({'moods': []}).then(
        (value) => print("User added successfully"),
        onError: (e) => print("Error adding user"));
  }

  Future<void> addMood(String uid, double mood) async {
    await _firestore
        .collection('moods')
        .doc(uid)
        .collection('moods')
        .add({"addedOn": DateTime.now(), "mood": mood}).then(
            (value) => print("Mood added successfully"),
            onError: (e) => print("Error adding user"));
    // await _firestore.collection('moods').doc(uid).update({
    //   "moods": FieldValue.arrayUnion([
    //     {"addedOn": DateTime.now(), "mood": mood}
    //   ])
    // })
  }

  Future<void> addSongs(String uid) async {
    print('adding songs');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? last_update = prefs.getInt('last_update');
    last_update ??= 0;
    // print(DateTime.fromMillisecondsSinceEpoch(last_update));
    List<Track>? songs = await SpotifyApi.getRecentlyPlayed(50);
    if (songs == null) {
      return;
    }
    //check if duplicates exist
    List<int> song_lastupdates = [];
    for (Track song in songs) {
      song_lastupdates.add(song.playedAt.millisecondsSinceEpoch);
      if (last_update < song.playedAt.millisecondsSinceEpoch) {
        print(DateTime.fromMillisecondsSinceEpoch(
            song.playedAt.millisecondsSinceEpoch));
        print("song added");
        AudioFeatures? audioFeatures =
            await SpotifyApi.getAudioFeatures(song.id);
        if (audioFeatures == null) {
          continue;
        }
        await _firestore.collection('songs').doc(uid).collection('songs').add({
          "id": song.id,
          "name": song.trackName,
          "valence": audioFeatures.valence,
          "duration": audioFeatures.duration,
          "tempo": audioFeatures.tempo,
          'played_at': song.playedAt
        });
      }
    }
    song_lastupdates.sort();
    prefs.setInt('last_update', song_lastupdates[song_lastupdates.length - 1]);
  }

  Future<Map<DateTime, int>?> getSongDurations(
      String uid, Timestamp lastUpdate) async {
    final Map<DateTime, int> ret = {};
    print('song durations called');
    QuerySnapshot<Map<dynamic, dynamic>> dShot = await _firestore
        .collection('songs')
        .doc(uid)
        .collection('songs')
        .where('played_at', isGreaterThan: lastUpdate)
        .orderBy('played_at', descending: true)
        .get();
    if (dShot.docs == []) return null;
    for (var snap in dShot.docs) {
      ret.addAll({snap['played_at'].toDate(): snap['duration']});
    }
    return ret;
  }

  Future<Map<DateTime, double>?> getBPM(
      String uid, Timestamp lastUpdate) async {
    final Map<DateTime, double> ret = {};
    print('bpm called');
    QuerySnapshot<Map<dynamic, dynamic>> dShot = await _firestore
        .collection('songs')
        .doc(uid)
        .collection('songs')
        .where('played_at', isGreaterThan: lastUpdate)
        .orderBy('played_at', descending: true)
        .get();
    if (dShot.docs == []) return null;
    for (var snap in dShot.docs) {
      ret.addAll({snap['played_at'].toDate(): snap['tempo']});
    }
    return ret;
  }

  Future<Map<DateTime, double>?> getValence(
      String uid, Timestamp lastUpdate) async {
    final Map<DateTime, double> ret = {};
    print('valence called');
    QuerySnapshot<Map<dynamic, dynamic>> dShot = await _firestore
        .collection('songs')
        .doc(uid)
        .collection('songs')
        .where('played_at', isGreaterThan: lastUpdate)
        .orderBy('played_at', descending: true)
        .get();
    if (dShot.docs == []) return null;
    for (var snap in dShot.docs) {
      ret.addAll({snap['played_at'].toDate(): snap['valence']});
    }
    return ret;
  }

  Future<Map<DateTime, double>?> getMoods(
      String uid, Timestamp lastUpdate) async {
    final Map<DateTime, double> ret = {};
    QuerySnapshot<Map<dynamic, dynamic>> dShot = await _firestore
        .collection('moods')
        .doc(uid)
        .collection('moods')
        .where('addedOn', isGreaterThan: lastUpdate)
        .orderBy('addedOn', descending: true)
        .get();
    if (dShot.docs == []) return null;

    for (var snap in dShot.docs) {
      ret.addAll({snap['addedOn'].toDate(): snap['mood'].toDouble()});
    }

    return ret;
  }
}
