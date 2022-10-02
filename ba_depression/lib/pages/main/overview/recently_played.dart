import 'dart:async';

import 'package:ba_depression/pages/main/overview/music_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../models/custom_image_provider.dart';
import '../../../models/track.dart';
import '../../../services/spotify_api.dart';

class RecentlyPlayed extends StatefulWidget {
  const RecentlyPlayed({Key? key}) : super(key: key);

  @override
  State<RecentlyPlayed> createState() => _RecentlyPlayedState();
}

class _RecentlyPlayedState extends State<RecentlyPlayed> {
  final StreamController<List<Track>?> _streamController = StreamController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _streamController.close();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.run(() async {
      await getRecentlyPlayed();
    });
    Timer.periodic(Duration(seconds: 30), (timer) async {
      await getRecentlyPlayed();
    });
  }

  Future<void> getRecentlyPlayed() async {
    try {
      List<Track>? tracks = await SpotifyApi.getRecentlyPlayed();
      _streamController.sink.add(tracks);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Track>?>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                  height: MediaQuery.of(context).size.height * 0.17,
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
                    height: MediaQuery.of(context).size.height * 0.17,
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
                    child: Text("Error occured"));
              } else {
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15, top: 15, bottom: 13),
                        child: Text(
                          "Listening History",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Expanded(
                        child: ListView.separated(
                            separatorBuilder: (context, index) {
                              return Divider(
                                indent:
                                    MediaQuery.of(context).size.width * 0.19,
                                endIndent:
                                    MediaQuery.of(context).size.width * 0.07,
                                color: Color(0x20707070),
                              );
                            },
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            // physics: ScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  left: 15,
                                ),
                                child: buildCard(
                                  snapshot.data![index],
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                );
              }
          }
        });
  }

  Widget buildCard(
    Track track,
  ) {
    return Row(
      children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.055,
            width: MediaQuery.of(context).size.width * 0.12,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CustomImageProvider.cachedImage(
                        track.trackImageUrl)!))),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.03,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(track.trackName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(
                track.artistName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 13,
                    color: Color(0xFF707070)),
              ),
            ],
          ),
        ),
      ],
    );
    // return Container(
    //   height: MediaQuery.of(context).size.height * 0.17,
    //   decoration: BoxDecoration(
    //     color: Colors.white,
    //     borderRadius: BorderRadius.all(Radius.circular(10)),
    //     boxShadow: const [
    //       BoxShadow(
    //           color: Color(0x10000000), offset: Offset(0, 0), blurRadius: 6.0),
    //     ],
    //   ),
    //   child: Padding(
    //       padding: EdgeInsets.symmetric(horizontal: 15),
    //       child: track.isPlaying
    //           ? Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 Container(
    //                     height: MediaQuery.of(context).size.height * 0.14,
    //                     width: MediaQuery.of(context).size.width * 0.3,
    //                     decoration: BoxDecoration(
    //                         borderRadius: BorderRadius.circular(10),
    //                         image: DecorationImage(
    //                             fit: BoxFit.cover,
    //                             image: CustomImageProvider.cachedImage(
    //                                 track.trackImageUrl)!))),
    //                 Container(
    //                   width: MediaQuery.of(context).size.width * 0.43,
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       Text(track.trackName,
    //                           maxLines: 2,
    //                           overflow: TextOverflow.ellipsis,
    //                           style: TextStyle(
    //                               fontWeight: FontWeight.w600, fontSize: 15)),
    //                       SizedBox(
    //                         height: MediaQuery.of(context).size.height * 0.01,
    //                       ),
    //                       Text(
    //                         track.artistName,
    //                         maxLines: 1,
    //                         overflow: TextOverflow.ellipsis,
    //                         style: TextStyle(
    //                             fontWeight: FontWeight.normal,
    //                             fontSize: 15,
    //                             color: Color(0xFF707070)),
    //                       ),
    //                       Player(
    //                         isPlaying: track.isPlaying,
    //                       )
    //                     ],
    //                   ),
    //                 )
    //               ],
    //             )
    //           : Padding(
    //               padding: EdgeInsets.symmetric(
    //                   horizontal: MediaQuery.of(context).size.width * 0.03,
    //                   vertical: MediaQuery.of(context).size.height * 0.03),
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: [
    //                   Text("Play some songs to alleviate your mood 🎶 ",
    //                       style: TextStyle(
    //                           fontWeight: FontWeight.w600, fontSize: 13)),
    //                   SizedBox(
    //                     height: MediaQuery.of(context).size.height * 0.03,
    //                   ),
    //                   Player(
    //                     isPlaying: track.isPlaying,
    //                   )
    //                 ],
    //               ),
    //             )),
    // );
  }
}
