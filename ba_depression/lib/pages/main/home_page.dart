import 'package:ba_depression/pages/main/insight_page.dart';
import 'package:ba_depression/pages/main/measurement_page.dart';
import 'package:ba_depression/widgets/bottom_tab_bar.dart';
import 'package:ba_depression/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  late PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    _controller = CustomTabController(length: 2, vsync: this);
    _pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          TopBar(selectedIndex: _selectedIndex),
          PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            // ignore: prefer_const_literals_to_create_immutables
            children: [MeasurementPage(), InsightPage()],
          )
        ],
      ),
      bottomNavigationBar: BottomTabBar(
        selectedIndex: _selectedIndex,
        onTap: (tabIndex) {
          _pageController.animateToPage(
            tabIndex,
            curve: Curves.easeOutQuint,
            duration: Duration(milliseconds: 200),
          );
          setState(() {
            _selectedIndex = tabIndex;
          });
        },
        iconSize: 24, //26.0
        controller: _controller,
      ),
    );
  }
}

class CustomTabController extends TabController {
  CustomTabController(
      {int initialIndex = 0,
      required int length,
      required TickerProvider vsync})
      : super(initialIndex: initialIndex, length: length, vsync: vsync);

  @override
  void animateTo(int value, {Duration? duration, Curve curve = Curves.ease}) {
    super.animateTo(value,
        duration: const Duration(milliseconds: 150), curve: curve);
  }
}
