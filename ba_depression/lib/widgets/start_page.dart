import 'package:ba_depression/services/spotify_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      _signInFromSavedTokens();
    } catch (e) {
      print(mounted);
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInFromSavedTokens() async {
    final auth = context.read<SpotifyAuth>();
    setState(() => _isLoading = true);
    try {
      await auth.signInFromSavedTokens();
      //Navigator.popAndPushNamed(context, HomePage.routeName);
    } catch (_) {
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSignIn(SpotifyAuth auth, BuildContext context) async {
    try {
      setState(() => _isLoading = true);
      await auth.authenticate();
    } catch (e) {
      // ignore: avoid_print
      print("handleSignIn prints" + e.toString());
    } finally {
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
                        MediaQuery.of(context).size.height / 6,
                  ),
                  Text(
                    'mHealth.',
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Consumer<SpotifyAuth>(
                  builder: (_, auth, __) => InkWell(
                    onTap: () => _handleSignIn(auth, context),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(27.0)),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
