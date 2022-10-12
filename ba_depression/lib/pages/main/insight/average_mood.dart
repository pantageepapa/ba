import 'package:ba_depression/services/graph_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../../services/spotify_auth.dart';

class AverageMood extends StatefulWidget {
  const AverageMood({Key? key}) : super(key: key);

  @override
  State<AverageMood> createState() => _AverageMoodState();
}

class _AverageMoodState extends State<AverageMood> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double?>(
        future: GraphService().getAvgMood(
            Provider.of<SpotifyAuth>(context, listen: false).user!.id),
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                  height: MediaQuery.of(context).size.height * 0.16,
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
                height: MediaQuery.of(context).size.height * 0.16,
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
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 15, right: 20, bottom: 8),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Your average mood',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 12)),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.003,
                        ),
                        Text('Your average mood assessment in a week',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                                color: Color(0xFF707070))),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        LinearPercentIndicator(
                          animation: false,
                          barRadius: Radius.circular(19),
                          percent: snapshot.data! / 10,
                          padding: EdgeInsets.all(0),
                          leading: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.035,
                              width: MediaQuery.of(context).size.width * 0.18,
                              decoration: BoxDecoration(
                                  color: Color(0xFF1DB954).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                child: Text(
                                  '${(snapshot.data! * 10).toStringAsFixed(0)} %',
                                  style: TextStyle(
                                      color: Color(0xFF1DB954),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: SvgPicture.asset(
                              'assets/Vector5.svg',
                              color: Color(0xFF1DB954),
                              height: 25,
                            ),
                          ),
                          // center: Text(
                          //   '${snapshot.data!.toInt() * 10} %',
                          //   style: TextStyle(color: Colors.black),
                          // ),
                          lineHeight:
                              MediaQuery.of(context).size.height * 0.035,
                          backgroundColor: Color(0xFF1DB954).withOpacity(0.15),
                          linearGradient: LinearGradient(
                            colors: [
                              Color(0xFF1DB954).withOpacity(0.15),
                              Color(0xFF1DB954)
                            ],
                            begin: Alignment(-1.0, -2.0),
                            end: Alignment(1.0, 1.0),
                          ),
                        )
                      ]),
                ),
              );
          }
        }));
  }
}
