import 'dart:ffi';

class AudioFeatures {
  const AudioFeatures({
    required this.tempo,
    required this.valence,
    required this.id,
    required this.duration,
  });

  final double tempo;
  final double valence;
  final int duration;
  final String id;

  static AudioFeatures? fromJson(Map<String, dynamic> json) {
    final tempo = json['tempo'];
    final valence = json['valence'];
    final duration = json['duration_ms'];
    final id = json['id'];
    return AudioFeatures(
        tempo: tempo, valence: valence, id: id, duration: duration);
  }
}
