import 'package:ba_depression/pages/tutorial_page1.dart';
import 'package:ba_depression/pages/tutorial_page3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class TutorialPage2 extends StatelessWidget {
  const TutorialPage2({Key? key}) : super(key: key);

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
                          tween: Tween(begin: 0.18, end: 0.45),
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
                    'We use Spotify to measure your current mood.',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Text(
                    'No more self-written journals and annoying notifications. We passively collect your Spotify data and predict your mood. ',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.17,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                        height: 210,
                        width: 200,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fitHeight,
                                image: AssetImage(
                                    "assets/listening_to_music.png")))),
                  ),
                ],
              ),
              SafeArea(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TutorialPage3()));
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
                        'Continue',
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
