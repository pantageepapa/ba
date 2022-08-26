import 'package:ba_depression/services/spotify_auth.dart';
import 'package:ba_depression/widgets/start_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SpotifyAuth>(
      create: (_) => SpotifyAuth(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            splashFactory: InkRipple.splashFactory,
            pageTransitionsTheme: const PageTransitionsTheme(builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            }),
            primaryColor: const Color(0xFF1DB954),
            backgroundColor: const Color(0xFFFBFBFB),
            scaffoldBackgroundColor: const Color(0xFFFBFBFB)),
        initialRoute: () {
          return '/start';
        }(),
        routes: {
          '/start': (context) => StartPage(),
        },
      ),
    );
  }
}
