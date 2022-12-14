import 'package:ba_depression/firebase_options.dart';
import 'package:ba_depression/pages/main/all/home_page.dart';
import 'package:ba_depression/services/firebase_db.dart';
import 'package:ba_depression/services/spotify_auth.dart';
import 'package:ba_depression/pages/start/start_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SpotifyAuth>(
          create: (_) => SpotifyAuth(),
        ),
        ChangeNotifierProvider<SelectedIndexProvider>(
            create: ((context) => SelectedIndexProvider()))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ba_depression',
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
