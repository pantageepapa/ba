import 'package:ba_depression/models/custom_image_provider.dart';
import 'package:ba_depression/pages/main/all/own_profile.dart';
import 'package:ba_depression/services/spotify_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopBar extends StatelessWidget {
  var topBarHeight;
  final int selectedIndex;

  TopBar({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<SpotifyAuth>();
    final profilePic =
        CustomImageProvider.cachedImage(auth.user?.avatarImageUrl);

    var aspectratio =
        MediaQuery.of(context).size.height / MediaQuery.of(context).size.width;
    if (aspectratio >= 2) {
      topBarHeight = MediaQuery.of(context).size.width * 2.16 * 0.043;
    } else {
      topBarHeight = MediaQuery.of(context).size.width * 1.78 * 0.050;
    }

    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: Colors.transparent, //Color(0xFFFBFBFB),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.06,
          vertical: topBarHeight * 0.46,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            selectedIndex == 0
                ? Container(
                    height: topBarHeight,
                    padding: EdgeInsets.symmetric(vertical: 2.5),
                    child: Text(
                      "Overview",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 23),
                    ))
                : selectedIndex == 1
                    ? Container(
                        height: topBarHeight,
                        padding: EdgeInsets.symmetric(vertical: 2.5),
                        child: Text(
                          "Measurements",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 23),
                        ))
                    : Container(
                        height: topBarHeight,
                        padding: EdgeInsets.symmetric(vertical: 2.5),
                        child: Text(
                          "Insights",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 23),
                        )),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => OwnProfile()),
                );
              },
              child: profilePic == null
                  ? Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: Color(0xFFF3F3F3),
                      ),
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Icon(
                          Icons.person,
                          size: 20,
                          color: Color(0xFFBFBFBF),
                        ),
                      ),
                    )
                  : Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 1.5),
                          image: DecorationImage(
                              fit: BoxFit.cover, image: profilePic))),
            )
          ],
        ),
      ),
    );
  }
}
