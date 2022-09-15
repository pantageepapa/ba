import 'dart:convert';
import 'dart:io';

import 'package:ba_depression/models/auth_tokens.dart';
import 'package:ba_depression/services/api_path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SpotifyAuthApi {
  static final clientId = dotenv.env['CLIENT_ID']!;
  static final clientSecret = dotenv.env['CLIENT_SECRET'];
  static final base64Credential =
      base64.encode(utf8.encode('$clientId:$clientSecret'));

  static Future<AuthTokens> getAuthTokens(
      String code, String redirectUri) async {
    final response = await http.post(
      Uri.parse(APIPath.requestToken),
      body: {
        'code': code,
        'redirect_uri': redirectUri,
        'grant_type': 'authorization_code',
      },
      headers: {HttpHeaders.authorizationHeader: 'Basic $base64Credential'},
    );
    print(response.body);

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
      print("getNewTokens prints: " + response.body);
      return AuthTokens.fromJson(responseBody);
    } else {
      throw Exception(
          'Failed to refresh token with status code ${response.statusCode}');
    }
  }
}
