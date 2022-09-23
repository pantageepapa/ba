import 'package:ba_depression/pages/main/all/home_page.dart';
import 'package:ba_depression/pages/main/insight/insight_page.dart';
import 'package:ba_depression/pages/main/measurement/measurement_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class CategoryTab extends StatefulWidget {
  final pageController;
  const CategoryTab({Key? key, required this.pageController}) : super(key: key);

  @override
  State<CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<CategoryTab> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            widget.pageController.animateToPage(
              1,
              curve: Curves.easeOutQuint,
              duration: Duration(milliseconds: 200),
            );
            Provider.of<SelectedIndexProvider>(context, listen: false)
                .setSelectedIndex(1);
          },
          child: Container(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width * 0.42,
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
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "🔎 Measurements",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              )),
        ),
        InkWell(
          onTap: () {
            widget.pageController.animateToPage(
              2,
              curve: Curves.easeOutQuint,
              duration: Duration(milliseconds: 200),
            );
            Provider.of<SelectedIndexProvider>(context, listen: false)
                .setSelectedIndex(2);
          },
          child: Container(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width * 0.42,
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
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "✨ Insights",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              )),
        )
      ],
    );
  }
}
