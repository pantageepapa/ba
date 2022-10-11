import 'dart:io';
import 'dart:math';

import 'package:ba_depression/models/auth_tokens.dart';
import 'package:ba_depression/models/user.dart';
import 'package:ba_depression/services/api_path.dart';
import 'package:ba_depression/services/spotify_api.dart';
import 'package:ba_depression/services/spotify_auth_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpotifyAuth extends ChangeNotifier {
  User? user;

  /// Implemented using 'Authorization Code' flow from Spotify auth guide:
  /// https://developer.spotify.com/documentation/general/guides/authorization-guide/
  Future<void> authenticate() async {
    final clientId = dotenv.env['CLIENT_ID']!;
    final redirectUri = dotenv.env['REDIRECT_URI']!;
    final state = _getRandomString(6);

    try {
      //request authorization and let users log in
      APIPath.requestAuthorization(clientId, redirectUri, state);
      final result = await FlutterWebAuth.authenticate(
        url: APIPath.requestAuthorization(clientId, redirectUri, state),
        callbackUrlScheme: "baDepression",
      );

      // Validate state from response
      final returnedState = Uri.parse(result).queryParameters['state'];
      if (state != returnedState) throw HttpException('Invalid access');

      //Using the code from the last request, send Post request to access token
      final String? code = Uri.parse(result).queryParameters['code'];
      final tokens = await SpotifyAuthApi.getAuthTokens(code!, redirectUri);

      //save the token
      await tokens.saveToStorage();
      user = await SpotifyApi.getCurrentUser(); // Uses token in storage

      //save uid for later usage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('uid', user!.id);

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
      user = await SpotifyApi.getCurrentUser(); // Uses token in storage
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
