import 'package:ba_depression/services/spotify_auth.dart';
import 'package:ba_depression/pages/start/tutorial_page1.dart';
import 'package:ba_depression/pages/start/tutorial_page4.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class TutorialPage3 extends StatefulWidget {
  const TutorialPage3({Key? key}) : super(key: key);

  @override
  State<TutorialPage3> createState() => _TutorialPage3State();
}

class _TutorialPage3State extends State<TutorialPage3> {
  bool _isLoading = false;

  Future<void> _handleSignIn(SpotifyAuth auth, BuildContext context) async {
    // try {
    setState(() => _isLoading = true);
    await auth.authenticate();
    // } catch (e) {
    //   Fluttertoast.showToast(
    //       gravity: ToastGravity.TOP,
    //       fontSize: 13,
    //       msg: "Failed to sign in",
    //       backgroundColor: Color(0xFF1DB954));
    // } finally {
    //   setState(() => _isLoading = false);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: 18, right: 18),
        child: SizedBox(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_ios)),
                      ),
                      //animation balken
                      Align(
                        alignment: Alignment.center,
                        child: TweenAnimationBuilder(
                          tween: Tween(begin: 0.45, end: 0.7),
                          duration: Duration(milliseconds: 1000),
                          builder: (context, value, _) => ClipPath(
                            clipper: MyCustomClipper(),
                            child: SizedBox(
                              width: 180,
                              height: 5,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                child: LinearProgressIndicator(
                                  color: Theme.of(context).primaryColor,
                                  value: value as double,
                                  backgroundColor: Color(0xFFE2E2E2),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.09,
                  ),
                  Text(
                    'Track your mood with Spotify and connect to a therapist.',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Text(
                    'We will monitor your depression based on the music you listen to and suggest a professional if necessary. ',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.14,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                        height: 240,
                        width: 300,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fitHeight,
                                image: AssetImage("assets/g10.png")))),
                  ),
                ],
              ),
              SafeArea(
                child: Consumer<SpotifyAuth>(
                  builder: (_, auth, __) => InkWell(
                    splashColor: Colors.transparent,
                    onTap: () async {
                      try {
                        await _handleSignIn(auth, context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const TutorialPage4()),
                        );
                      } catch (e) {
                        Fluttertoast.showToast(
                            gravity: ToastGravity.TOP,
                            fontSize: 13,
                            msg: "Failed to sign in",
                            backgroundColor: Color(0xFF1DB954));
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom == 0
                              ? MediaQuery.of(context).size.height * 0.02
                              : MediaQuery.of(context).size.height * 0.01),
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          color: Color(0xFF1DB954)),
                      child: Center(
                        child: _isLoading
                            ? SpinKitCircle(
                                color: Colors.white,
                                size: 30,
                              )
                            : Text(
                                'Connect to Spotify',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
