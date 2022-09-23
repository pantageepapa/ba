import 'package:ba_depression/models/custom_image_provider.dart';
import 'package:ba_depression/services/spotify_auth.dart';
import 'package:ba_depression/pages/main/all/home_page.dart';
import 'package:ba_depression/pages/start/tutorial_page1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class TutorialPage4 extends StatefulWidget {
  const TutorialPage4({Key? key}) : super(key: key);

  @override
  State<TutorialPage4> createState() => _TutorialPage4State();
}

class _TutorialPage4State extends State<TutorialPage4> {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<SpotifyAuth>();

    final profilePic =
        CustomImageProvider.cachedImage(auth.user?.avatarImageUrl);

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
                          tween: Tween(begin: 0.7, end: 1.0),
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
                    'Your Spotify is now connected and you are ready to go!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: profilePic == null
                        ? Container(
                            height: 180,
                            width: 180,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 3),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              color: Color(0xFFF3F3F3),
                            ),
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: Color(0xFFBFBFBF),
                              ),
                            ),
                          )
                        : Container(
                            height: 180,
                            width: 180,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 3.0),
                                image: DecorationImage(
                                    fit: BoxFit.cover, image: profilePic))),
                  ),
                ],
              ),
              SafeArea(
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
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
                      child: Text(
                        'Let\'s start',
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
    ));
  }
}
