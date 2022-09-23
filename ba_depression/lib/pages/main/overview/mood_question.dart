import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';

class MoodQuestion extends StatefulWidget {
  const MoodQuestion({Key? key}) : super(key: key);

  @override
  State<MoodQuestion> createState() => _MoodQuestionState();
}

class _MoodQuestionState extends State<MoodQuestion> {
  Widget _showMoodWidget(String path) {
    return InkWell(
      child: SvgPicture.asset(
        path,
        height: 35,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              "How are you feeling today?",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _showMoodWidget('assets/Vector1.svg'),
                  _showMoodWidget('assets/Vector2.svg'),
                  _showMoodWidget('assets/Vector3.svg'),
                  _showMoodWidget('assets/Vector4.svg'),
                  _showMoodWidget('assets/Vector5.svg'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
