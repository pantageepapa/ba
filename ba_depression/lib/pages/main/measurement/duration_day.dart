import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../services/graph_service.dart';
import '../../../services/spotify_auth.dart';

class DurationDay extends StatefulWidget {
  const DurationDay({
    Key? key,
  }) : super(key: key);

  @override
  State<DurationDay> createState() => _DurationDayState();
}

class _DurationDayState extends State<DurationDay> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FlSpot>?>(
        future: GraphService().getDurationsDay(
            Provider.of<SpotifyAuth>(context, listen: false).user!.id),
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                  height: MediaQuery.of(context).size.height * 0.3,
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
                  child: SpinKitCircle(
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  ));
            default:
              return Container(
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
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
                        padding: const EdgeInsets.only(
                            left: 20, top: 15, right: 10, bottom: 8),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Playing Hours',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12)),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.003,
                              ),
                              Text('Total playing minutes per hour in a day',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                      color: Color(0xFF707070))),
                            ]),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 20, top: 10, bottom: 10),
                          child: LineChart(LineChartData(
                              gridData: FlGridData(
                                  show: true,
                                  horizontalInterval: 20,
                                  drawVerticalLine: false,
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: Color(0xFF707070).withOpacity(0.2),
                                      strokeWidth: 1,
                                    );
                                  }),
                              lineTouchData: LineTouchData(
                                  getTouchedSpotIndicator:
                                      (barData, spotIndexes) {
                                    return spotIndexes.map((spotIndex) {
                                      return TouchedSpotIndicatorData(
                                        FlLine(
                                            color:
                                                Theme.of(context).primaryColor,
                                            strokeWidth: 2),
                                        FlDotData(
                                          show: true,
                                          getDotPainter:
                                              (spot, percent, barData, index) =>
                                                  FlDotCirclePainter(
                                                      radius: 4,
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                        ),
                                      );
                                    }).toList();
                                  },
                                  touchTooltipData: LineTouchTooltipData(
                                      getTooltipItems: (touchedSpots) {
                                        return touchedSpots
                                            .map((touchedSpot) => LineTooltipItem(
                                                '${touchedSpot.y.toInt()} min',
                                                TextStyle(
                                                    color: Color(0xFF707070),
                                                    fontSize: 10)))
                                            .toList();
                                      },
                                      tooltipBorder: BorderSide(
                                        color:
                                            Color(0xFF707070).withOpacity(0.2),
                                        width: 1,
                                      ),
                                      tooltipBgColor: Colors.white)),
                              titlesData: FlTitlesData(
                                show: true,
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: bottomTitleWidgets,
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: leftTitleWidgets,
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(
                                  show: true,
                                  border: Border.all(
                                    color: Color(0xFF707070).withOpacity(0.2),
                                    width: 1,
                                  )),
                              minX: 1,
                              maxX: 24,
                              minY: 0,
                              maxY: 60,
                              lineBarsData: [
                                LineChartBarData(
                                    spots: snapshot.data!,
                                    isCurved: true,
                                    barWidth: 3,
                                    belowBarData: BarAreaData(
                                      show: false,
                                    ),
                                    dotData: FlDotData(
                                      show: false,
                                    ),
                                    isStrokeCapRound: true,
                                    color: Theme.of(context).primaryColor)
                              ])),
                        ),
                      )
                    ]),
              );
          }
        }));
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xFF707070),
      fontWeight: FontWeight.normal,
      fontSize: 9,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('1', style: style);
        break;
      case 5:
        text = const Text('5', style: style);
        break;
      case 10:
        text = const Text('10', style: style);
        break;
      case 15:
        text = const Text('15', style: style);
        break;
      case 20:
        text = const Text('20', style: style);
        break;
      case 24:
        text = const Text('24', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xFF707070),
      fontWeight: FontWeight.normal,
      fontSize: 9,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0';
        break;
      case 20:
        text = '20';
        break;
      case 40:
        text = '40';
        break;
      case 60:
        text = '60';
        break;
      default:
        return Container();
    }

    return Text(
      text,
      style: style,
    );
  }
}
