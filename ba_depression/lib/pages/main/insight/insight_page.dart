import 'package:ba_depression/pages/main/insight/average_mood.dart';
import 'package:ba_depression/pages/main/insight/mood_diagram.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class InsightPage extends StatefulWidget {
  const InsightPage({Key? key}) : super(key: key);

  @override
  State<InsightPage> createState() => _InsightPageState();
}

class _InsightPageState extends State<InsightPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.06),
        child: SingleChildScrollView(
          child: Column(
            children: [
              MoodDiagram(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              AverageMood()
            ],
          ),
        ));
  }
}
