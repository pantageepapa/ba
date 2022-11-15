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

class DurationMonth extends StatefulWidget {
  const DurationMonth({Key? key}) : super(key: key);

  @override
  State<DurationMonth> createState() => _DurationMonthState();
}

class _DurationMonthState extends State<DurationMonth> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FlSpot>?>(
        future: GraphService().getDurationsMonth(
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
              if (snapshot.hasError || snapshot.data == null) {
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
                    child: Center(
                        child: Text(
                      "Error occured. Try to reload.",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    )));
              } else {
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
                                Text('Playing Time',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12)),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.003,
                                ),
                                Text(
                                    'This month\'s total playing time in minutes',
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
                                    horizontalInterval: 50,
                                    drawVerticalLine: false,
                                    getDrawingHorizontalLine: (value) {
                                      return FlLine(
                                        color:
                                            Color(0xFF707070).withOpacity(0.2),
                                        strokeWidth: 1,
                                      );
                                    }),
                                lineTouchData: LineTouchData(
                                    getTouchedSpotIndicator:
                                        (barData, spotIndexes) {
                                      return spotIndexes.map((spotIndex) {
                                        return TouchedSpotIndicatorData(
                                          FlLine(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              strokeWidth: 2),
                                          FlDotData(
                                            show: true,
                                            getDotPainter: (spot, percent,
                                                    barData, index) =>
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
                                          color: Color(0xFF707070)
                                              .withOpacity(0.2),
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
                                      interval: 4,
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
                                    border: Border(
                                      left: BorderSide(
                                        color:
                                            Color(0xFF707070).withOpacity(0.2),
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color:
                                            Color(0xFF707070).withOpacity(0.2),
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color:
                                            Color(0xFF707070).withOpacity(0.2),
                                        width: 1,
                                      ),
                                    )),
                                minX: 1,
                                maxX: 31,
                                minY: 0,
                                maxY: 300,
                                lineBarsData: [
                                  LineChartBarData(
                                      spots: snapshot.data!,
                                      isCurved: true,
                                      barWidth: 3,
                                      belowBarData: BarAreaData(
                                        show: false,
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF1DB954).withOpacity(0.15),
                                            Color(0xFF1DB954)
                                          ],
                                          // .map((color) =>
                                          //     color.withOpacity(0.3))
                                          // .toList(),
                                          begin: Alignment(-1.0, -2.0),
                                          end: Alignment(1.0, 1.0),
                                        ),
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
          }
        }));
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xFF707070),
      fontWeight: FontWeight.normal,
      fontSize: 9,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        value.toInt().toString(),
        style: style,
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xFF707070),
      fontWeight: FontWeight.normal,
      fontSize: 9,
    );

    return Text(
      value.toInt().toString(),
      style: style,
    );
  }
}
