import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TopArtists extends StatefulWidget {
  const TopArtists({Key? key}) : super(key: key);

  @override
  State<TopArtists> createState() => _TopArtistsState();
}

class _TopArtistsState extends State<TopArtists> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: const [
            BoxShadow(
                color: Color(0x10000000),
                offset: Offset(0, 0),
                blurRadius: 6.0),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, top: 15, bottom: 13),
              child: Text(
                "5 Top Artists",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
          ],
        ));
  }
}
