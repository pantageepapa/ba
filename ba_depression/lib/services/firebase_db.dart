import 'package:ba_depression/models/audio_features.dart';
import 'package:ba_depression/services/spotify_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/track.dart';
import '../models/user.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('songs').doc(uid).set({'songs': []});

    await _firestore.collection('moods').doc(uid).set({'moods': []}).then(
        (value) => print("User added successfully"),
        onError: (e) => print("Error adding user"));
  }

  Future<void> addMood(String uid, int mood) async {
    DateTime now = DateTime.now();
    // int mood_enc = now.year * 100000 + now.month * 1000 + now.day * 10 + mood;
    await _firestore.collection('moods').doc(uid).update({
      "moods": FieldValue.arrayUnion([
        {"addedOn": DateTime.now(), "mood": mood}
      ])
    }).then((value) => print("Mood added successfully"),
        onError: (e) => print("Error adding user"));
  }

  Future<void> addSongs(String uid) async {
    List<Track>? songs = await SpotifyApi.getRecentlyPlayed(10);
    if (songs == null) {
      return;
    }
    //check if duplicates exist

    for (Track song in songs) {
      AudioFeatures? audioFeatures = await SpotifyApi.getAudioFeatures(song.id);
      if (audioFeatures == null) {
        continue;
      }

      await _firestore.collection('songs').doc(uid).update({
        "songs": FieldValue.arrayUnion([
          {
            "id": song.id,
            "valence": audioFeatures.valence,
            "duration": audioFeatures.duration,
            "tempo": audioFeatures.tempo,
            'played_at': song.playedAt
          }
        ])
      });
    }
  }
}
