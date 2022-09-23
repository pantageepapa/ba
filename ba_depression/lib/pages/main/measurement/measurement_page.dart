import 'package:ba_depression/pages/main/overview/music_player.dart';
import 'package:ba_depression/pages/main/all/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class MeasurementPage extends StatefulWidget {
  const MeasurementPage({Key? key}) : super(key: key);

  @override
  State<MeasurementPage> createState() => _MeasurementPageState();
}

class _MeasurementPageState extends State<MeasurementPage> {
  var topBarHeight;

  @override
  Widget build(BuildContext context) {
    var aspectratio =
        MediaQuery.of(context).size.height / MediaQuery.of(context).size.width;
    if (aspectratio >= 2) {
      topBarHeight = MediaQuery.of(context).size.width * 2.16 * 0.043;
    } else {
      topBarHeight = MediaQuery.of(context).size.width * 1.78 * 0.050;
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.06,
      ),
      child: Column(
        children: [
          MusicPlayer(),
        ],
      ),
    );
  }
}
