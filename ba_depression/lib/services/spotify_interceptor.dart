import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:ba_depression/models/auth_tokens.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpotifyInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.get(AuthTokens.accessTokenKey);
    data.headers
        .addAll({HttpHeaders.authorizationHeader: 'Bearer $accessToken'});
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }
}

class ExpiredTokenRetryPolicy extends RetryPolicy {
  @override
  Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
    if (response.statusCode == 401) {
      print("Token expired, updating token...");
      await AuthTokens.updateTokenToLatest();
      print("Updated");
      return true;
    }

    return false;
  }
}
