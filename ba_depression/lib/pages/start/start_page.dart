import 'package:ba_depression/models/auth_tokens.dart';
import 'package:ba_depression/services/spotify_auth.dart';
import 'package:ba_depression/pages/tutorial_page1.dart';
import 'package:ba_depression/pages/tutorial_page3.dart';
import 'package:ba_depression/pages/tutorial_page4.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _initialSignIn();
  }

  Future<void> _initialSignIn() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString(AuthTokens.accessTokenKey) == null) {
        setState(() => _isLoading = false);
        return;
      }
      await _signInFromSavedTokens();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInFromSavedTokens() async {
    final auth = context.read<SpotifyAuth>();
    setState(() => _isLoading = true);
    try {
      await auth.signInFromSavedTokens();
      if (!mounted) return;
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => TutorialPage3()));
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2 -
                        MediaQuery.of(context).size.height / 5,
                  ),
                  Text(
                    'mHealth.',
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.43,
                    child: Text(
                      'An innovative way to take care of your mental health',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFFC4C4C4)),
                    ),
                  ),
                ],
              ),
              _isLoading
                  ? SafeArea(
                      child: Center(
                          child: SpinKitCircle(
                        color: Colors.white,
                        size: 30,
                      )),
                    )
                  : InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TutorialPage1()));
                      },
                      child: SafeArea(
                        child: Container(
                          margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).padding.bottom == 0
                                  ? MediaQuery.of(context).size.height * 0.02
                                  : MediaQuery.of(context).size.height * 0.01),
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              color: Color(0xFF1DB954)),
                          child: Center(
                            child: Text(
                              'Get Started',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
