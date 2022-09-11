import 'dart:convert';

import 'package:ba_depression/models/user.dart';
import 'package:ba_depression/services/api_path.dart';
import 'package:ba_depression/services/spotify_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

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
}
