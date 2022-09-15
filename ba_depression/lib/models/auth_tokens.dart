import 'package:ba_depression/services/spotify_auth_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthTokens {
  AuthTokens(this.accessToken, this.refreshToken);
  String accessToken;
  String refreshToken;

  static String accessTokenKey = 'ba-access-token';
  static String refreshTokenKey = 'ba-refresh-token';

  AuthTokens.fromJson(Map<String, dynamic> json)
      : accessToken = json['access_token'],
        refreshToken = json['refresh_token'];

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'refresh_token': refreshToken,
      };

  Future<void> saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(accessTokenKey, accessToken);
      await prefs.setString(refreshTokenKey, refreshToken);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  static Future<AuthTokens?> readFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final accessKey = prefs.get(accessTokenKey);
    final refreshKey = prefs.get(refreshTokenKey);
    if (accessKey == null || refreshKey == null) return null;
    return AuthTokens(accessKey.toString(), refreshKey.toString());
  }

  static Future<void> updateTokenToLatest() async {
    final savedTokens = await readFromStorage();
    if (savedTokens == null) throw Exception("No saved token found");

    final tokens =
        await SpotifyAuthApi.getNewTokens(originalTokens: savedTokens);
    await tokens.saveToStorage();
  }
}
