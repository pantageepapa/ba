import 'dart:convert';
import 'dart:io';

import 'package:ba_depression/models/auth_tokens.dart';
import 'package:ba_depression/services/api_path.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class SpotifyAuthApi {
  static const clientId = "b125ec602b5146ddb19b0f33330c9d1d";
  static const clientSecret = "22a5cc35e6fe40e1868e7d18e0cc6a38";
  static final base64Credential =
      utf8.fuse(base64).encode('$clientId:$clientSecret');

  static Future<AuthTokens> getAuthTokens(
      String code, String redirectUri) async {
    final response = await http.post(
      Uri.parse(APIPath.requestToken),
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirectUri,
      },
      headers: {HttpHeaders.authorizationHeader: 'Basic $base64Credential'},
    );

    if (response.statusCode == 200) {
      return AuthTokens.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to load token with status code ${response.statusCode}');
    }
  }

  static Future<AuthTokens> getNewTokens(
      {required AuthTokens originalTokens}) async {
    final response = await http.post(
      Uri.parse(APIPath.requestToken),
      body: {
        'grant_type': 'refresh_token',
        'refresh_token': originalTokens.refreshToken,
      },
      headers: {HttpHeaders.authorizationHeader: 'Basic $base64Credential'},
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['refresh_token'] == null) {
        responseBody['refresh_token'] = originalTokens.refreshToken;
      }

      return AuthTokens.fromJson(responseBody);
    } else {
      throw Exception(
          'Failed to refresh token with status code ${response.statusCode}');
    }
  }
}
