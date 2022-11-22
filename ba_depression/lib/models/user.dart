// ignore_for_file: unnecessary_null_comparison

import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({required this.id, required this.name, this.avatarImageUrl});
  final String name;
  final String? avatarImageUrl;
  final String id;

  static User? fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    final name = json['display_name'];
    final avatarImageUrl =
        json['images'].length != 0 ? json['images'][0]['url'] : null;
    final id = json['id'];
    return User(name: name, avatarImageUrl: avatarImageUrl, id: id);
  }

  Map<String, dynamic> toJson() => {
        'display_name': name,
        'images': [
          {'url': avatarImageUrl}
        ],
        'id': id
      };
  @override
  List<Object> get props => [name, id];
}
