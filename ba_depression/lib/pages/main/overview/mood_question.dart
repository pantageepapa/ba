import 'dart:async';

import 'package:ba_depression/services/firebase_db.dart';
import 'package:ba_depression/services/spotify_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoodQuestion extends StatefulWidget {
  const MoodQuestion({Key? key}) : super(key: key);

  @override
  State<MoodQuestion> createState() => _MoodQuestionState();
}

class _MoodQuestionState extends State<MoodQuestion> {
  late Timer _timer;

  Widget _showMoodWidget(String path) {
    return InkWell(
      child: SvgPicture.asset(
        path,
        height: 35,
      ),
    );
  }

  Future<bool> visibility() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('visibility') == null) {
      await prefs.setBool('visibility', true);
      return true;
    } else {
      return prefs.getBool('visibility')!;
    }
  }

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
      await prefs.setBool('visibility', true);
      setState(() {});
    });

    _timer = Timer.periodic(Duration(minutes: 30), (timer) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('visibility', true);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: visibility(),
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.16,
              decoration: BoxDecoration(
                color: Color(0xFF1DB954).withOpacity(0.15),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "How are you feeling now?",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.03),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                              onTap: (() async {
                                await DatabaseService().addMood(
                                    Provider.of<SpotifyAuth>(context,
                                            listen: false)
                                        .user!
                                        .id,
                                    0);
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setBool('visibility', false);
                                setState(() {});
                              }),
                              child: _showMoodWidget('assets/Vector1.svg')),
                          InkWell(
                              onTap: (() async {
                                await DatabaseService().addMood(
                                    Provider.of<SpotifyAuth>(context,
                                            listen: false)
                                        .user!
                                        .id,
                                    2.5);
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setBool('visibility', false);
                                setState(() {});
                              }),
                              child: _showMoodWidget('assets/Vector2.svg')),
                          InkWell(
                              onTap: (() async {
                                await DatabaseService().addMood(
                                    Provider.of<SpotifyAuth>(context,
                                            listen: false)
                                        .user!
                                        .id,
                                    5);
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setBool('visibility', false);
                                setState(() {});
                              }),
                              child: _showMoodWidget('assets/Vector3.svg')),
                          InkWell(
                              onTap: (() async {
                                await DatabaseService().addMood(
                                    Provider.of<SpotifyAuth>(context,
                                            listen: false)
                                        .user!
                                        .id,
                                    7.5);
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setBool('visibility', false);
                                setState(() {});
                              }),
                              child: _showMoodWidget('assets/Vector4.svg')),
                          InkWell(
                              onTap: (() async {
                                await DatabaseService().addMood(
                                    Provider.of<SpotifyAuth>(context,
                                            listen: false)
                                        .user!
                                        .id,
                                    10);
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setBool('visibility', false);
                                setState(() {});
                              }),
                              child: _showMoodWidget('assets/Vector5.svg')),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          } else if (snapshot.data == false) {
            return SizedBox(
              height: 0,
            );
          } else {
            return SizedBox(
              height: 0,
            );
          }
        });
  }
}

// class VisibilityProvider extends ChangeNotifier {
//   bool _visible = true;

//   bool get visible => _visible;

//   void setVisibility(bool visible) {
//     _visible = visible;
//     notifyListeners();
//   }
// }
