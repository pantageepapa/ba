import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class BottomTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final bool isBottomIndicator;
  final TabController controller;
  final double iconSize;

  const BottomTabBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
    required this.controller,
    required this.iconSize,
    this.isBottomIndicator = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        height: MediaQuery.of(context).size.height * 0.067 +
            MediaQuery.of(context).padding.bottom,
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.045,
          right: MediaQuery.of(context).size.width * 0.045,
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: TabBar(
          controller: controller,
          labelPadding: EdgeInsets.only(top: 1.5),
          indicatorColor: Colors.transparent,
          tabs: [
            Tab(
              icon: SvgPicture.asset(
                0 == selectedIndex
                    ? 'assets/measurements_green.svg'
                    : 'assets/measurements_grey.svg',
                height: iconSize,
              ),
            ),
            Tab(
              icon: SvgPicture.asset(
                1 == selectedIndex
                    ? 'assets/insights_green.svg'
                    : 'assets/insights_grey.svg',
                height: iconSize,
              ),
            ),
          ],
          onTap: onTap,
        ),
      ),
    );
  }
}
