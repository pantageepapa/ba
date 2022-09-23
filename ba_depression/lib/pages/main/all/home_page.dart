import 'package:ba_depression/pages/main/insight/insight_page.dart';
import 'package:ba_depression/pages/main/measurement/measurement_page.dart';
import 'package:ba_depression/pages/main/overview/overview_page.dart';
import 'package:ba_depression/pages/main/all/bottom_tab_bar.dart';
import 'package:ba_depression/pages/main/all/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  late PageController _pageController;
  var topBarHeight;

  @override
  void initState() {
    // TODO: implement initState
    _controller = CustomTabController(length: 3, vsync: this);
    _pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    var aspectratio =
        MediaQuery.of(context).size.height / MediaQuery.of(context).size.width;
    if (aspectratio >= 2) {
      topBarHeight = MediaQuery.of(context).size.width * 2.16 * 0.043;
    } else {
      topBarHeight = MediaQuery.of(context).size.width * 1.78 * 0.050;
    }

    int selectedIndex = context.watch<SelectedIndexProvider>()._selectedIndex;

    return Scaffold(
      body: Stack(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          TopBar(selectedIndex: selectedIndex),
          PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: topBarHeight +
                        2 * topBarHeight * 0.56 +
                        MediaQuery.of(context).padding.top),
                child: OverviewPage(pageController: _pageController),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: topBarHeight +
                        2 * topBarHeight * 0.56 +
                        MediaQuery.of(context).padding.top),
                child: MeasurementPage(),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: topBarHeight +
                        2 * topBarHeight * 0.56 +
                        MediaQuery.of(context).padding.top),
                child: InsightPage(),
              )
            ],
          )
        ],
      ),
      bottomNavigationBar: BottomTabBar(
        selectedIndex: selectedIndex,
        onTap: (tabIndex) {
          _pageController.animateToPage(
            tabIndex,
            curve: Curves.easeOutQuint,
            duration: Duration(milliseconds: 200),
          );
          // setState(() {
          Provider.of<SelectedIndexProvider>(context, listen: false)
              .setSelectedIndex(tabIndex);
          // });
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

class SelectedIndexProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int selectedIndex) {
    _selectedIndex = selectedIndex;
    notifyListeners();
  }
}
