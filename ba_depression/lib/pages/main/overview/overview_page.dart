import 'dart:async';

import 'package:ba_depression/pages/main/overview/category_tab.dart';
import 'package:ba_depression/pages/main/overview/mood_question.dart';
import 'package:ba_depression/pages/main/overview/music_player.dart';
import 'package:ba_depression/pages/main/overview/recently_played.dart';
import 'package:ba_depression/pages/main/overview/top_artists.dart';
import 'package:ba_depression/services/firebase_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/spotify_auth.dart';

class OverviewPage extends StatefulWidget {
  final pageController;

  const OverviewPage({Key? key, required this.pageController})
      : super(key: key);

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  late Timer _timer;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.run(() async {
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('uid');
      if (uid == null) {
        return;
      }
      DatabaseService().addSongs(uid);
    });
    _timer = Timer.periodic(Duration(seconds: 30), (timer) async {
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('uid');
      if (uid == null) {
        return;
      }
      DatabaseService().addSongs(uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<SpotifyAuth>();
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.06,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
                auth.user?.name == null
                    ? "Hello!"
                    : "Hello ${auth.user?.name}!",
                style: TextStyle(
                    color: Theme.of(context).primaryColor.withOpacity(0.6),
                    fontWeight: FontWeight.w600,
                    fontSize: 15)),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.02),
              child: MoodQuestion(),
            ),
            Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02),
                child: CategoryTab(
                  pageController: widget.pageController,
                )),
            Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02),
                child: MusicPlayer()),
            Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.02,
                ),
                child: TopArtists()),
            Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02),
                child: RecentlyPlayed()),
          ],
        ),
      ),
    );
  }
}
