import 'package:ba_depression/pages/main/measurement/duration_day.dart';
import 'package:ba_depression/pages/main/measurement/duration_month.dart';
import 'package:ba_depression/pages/main/measurement/tempo_day.dart';
import 'package:ba_depression/pages/main/measurement/tempo_month.dart';
import 'package:ba_depression/pages/main/measurement/valence_day.dart';
import 'package:ba_depression/pages/main/measurement/valence_month.dart';
import 'package:ba_depression/pages/main/overview/music_player.dart';
import 'package:ba_depression/pages/main/all/top_bar.dart';
import 'package:ba_depression/services/firebase_db.dart';
import 'package:ba_depression/services/graph_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../../services/spotify_auth.dart';

class MeasurementPage extends StatefulWidget {
  const MeasurementPage({Key? key}) : super(key: key);

  @override
  State<MeasurementPage> createState() => _MeasurementPageState();
}

class _MeasurementPageState extends State<MeasurementPage>
    with TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.06,
      ),
      child: DefaultTabController(
        length: 2,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height * 0.045,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0x10000000),
                          offset: Offset(0, 0),
                          blurRadius: 6.0),
                    ],
                  ),
                  child: tabBar()),
              Container(
                height: MediaQuery.of(context).size.height,
                child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: tabController,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          DurationDay(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          TempoDay(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          ValenceDay()
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          DurationMonth(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          TempoMonth(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          ValenceMonth()
                        ],
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tabBar() {
    return TabBar(
        splashBorderRadius: BorderRadius.circular(50),
        controller: tabController,
        labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        labelColor: Color(0xFF1DB954),
        unselectedLabelColor: Colors.black,
        indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(50), // Creates border
            color: Color(0xFF1DB954).withOpacity(0.15)),
        tabs: const [
          Tab(
            text: 'D',
          ),
          // Tab(
          //   text: 'W',
          // ),
          // Tab(
          //   text: 'M',
          // ),
          Tab(
            text: 'M',
          )
        ]);
  }
}
