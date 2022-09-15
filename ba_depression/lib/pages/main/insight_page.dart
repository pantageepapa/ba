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
    return Center(
      child: Container(
        child: Text("insight"),
      ),
    );
  }
}
