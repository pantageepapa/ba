import 'dart:io';
import 'dart:math';

import 'package:ba_depression/models/auth_tokens.dart';
import 'package:ba_depression/services/api_path.dart';
import 'package:ba_depression/services/spotify_auth_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

class SpotifyAuth extends ChangeNotifier {
  /// Implemented using 'Authorization Code' flow from Spotify auth guide:
  /// https://developer.spotify.com/documentation/general/guides/authorization-guide/
  Future<void> authenticate() async {
    const clientId = "b125ec602b5146ddb19b0f33330c9d1d";
    const redirectUri = "http://localhost:8888/callback";
    final state = _getRandomString(6);

    try {
      print(APIPath.requestAuthorization(clientId, redirectUri, state));
      final result = await FlutterWebAuth.authenticate(
        url: APIPath.requestAuthorization(clientId, redirectUri, state),
        callbackUrlScheme: "http://localhost:8888/callback",
      );

      // Validate state from response
      final returnedState = Uri.parse(result).queryParameters['state'];
      if (state != returnedState) throw HttpException('Invalid access');

      final String? code = Uri.parse(result).queryParameters['code'];
      final tokens = await SpotifyAuthApi.getAuthTokens(code!, redirectUri);
      await tokens.saveToStorage();

      //user = await SpotifyApi.getCurrentUser(); // Uses token in storage
      notifyListeners();
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e);
      rethrow;
    }
  }

  /// If there is a saved token, update the token and sign in
  Future<void> signInFromSavedTokens() async {
    try {
      await AuthTokens.updateTokenToLatest();
      //user = await SpotifyApi.getCurrentUser(); // Uses token in storage
      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static String _getRandomString(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }
}
