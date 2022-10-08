import 'dart:async';

import 'package:ba_depression/models/custom_image_provider.dart';
import 'package:ba_depression/models/track.dart';
import 'package:ba_depression/services/api_path.dart';
import 'package:ba_depression/services/spotify_api.dart';
import 'package:ba_depression/old/track_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({Key? key}) : super(key: key);

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  late StreamController<Track?> _streamController;

  late Timer _timer;
  bool isPlaying = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
    _streamController.close();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _streamController = StreamController<Track?>();
    Timer.run(() async {
      await getTrack();
    });

    _timer = Timer.periodic(Duration(seconds: 20), (timer) async {
      await getTrack();
    });
  }

  Future<void> getTrack() async {
    try {
      Track? track = await SpotifyApi.getCurrentTrack();
      _streamController.sink.add(track);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Track?>(
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
              if (snapshot.hasError) {
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
              } else if (snapshot.data == null) {
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
              } else {
                return displayPlayer(snapshot.data!);
              }
          }
        });
  }

  Widget displayPlayer(Track track) {
    isPlaying = track.isPlaying;

    return Container(
      height: MediaQuery.of(context).size.height * 0.17,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x10000000), offset: Offset(0, 0), blurRadius: 6.0),
        ],
      ),
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: track.isPlaying
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.14,
                        width: MediaQuery.of(context).size.width * 0.3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CustomImageProvider.cachedImage(
                                    track.trackImageUrl)!))),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.43,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(track.trackName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15)),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Text(
                            track.artistName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                color: Color(0xFF707070)),
                          ),
                          //Player
                          Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.02),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () async {
                                    await SpotifyApi.previous();
                                    await getTrack();
                                  },
                                  child: SvgPicture.asset(
                                    'assets/rewind.svg',
                                    height: 16,
                                  ),
                                ),
                                GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () async {
                                      await SpotifyApi.pause();
                                      await getTrack();
                                    },
                                    child: SvgPicture.asset(
                                      'assets/pause.svg',
                                      height: 19,
                                    )),
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () async {
                                    await SpotifyApi.skip();
                                    await getTrack();
                                  },
                                  child: SvgPicture.asset(
                                    'assets/forward.svg',
                                    height: 16,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )
              : Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03,
                      vertical: MediaQuery.of(context).size.height * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Play some songs to alleviate your mood 🎶 ",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 13)),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () async {
                                await SpotifyApi.previous();
                                await getTrack();
                              },
                              child: SvgPicture.asset(
                                'assets/rewind.svg',
                                height: 16,
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () async {
                                await SpotifyApi.skip();
                                await getTrack();
                              },
                              child: SvgPicture.asset(
                                'assets/play-button-4213.svg',
                                height: 20,
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () async {
                                await SpotifyApi.skip();
                                await getTrack();
                              },
                              child: SvgPicture.asset(
                                'assets/forward.svg',
                                height: 16,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )),
    );
  }
}

class Player extends StatefulWidget {
  bool isPlaying;
  Player({Key? key, required this.isPlaying}) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () async {
              await SpotifyApi.previous();
              setState(() {
                widget.isPlaying = true;
              });
            },
            child: SvgPicture.asset(
              'assets/rewind.svg',
              height: 16,
            ),
          ),
          widget.isPlaying
              ? InkWell(
                  onTap: () async {
                    await SpotifyApi.pause();
                    setState(() {
                      widget.isPlaying = false;
                    });
                  },
                  child: SvgPicture.asset(
                    'assets/pause.svg',
                    height: 19,
                  ))
              : InkWell(
                  onTap: () async {
                    await SpotifyApi.play();
                    setState(() {
                      widget.isPlaying = true;
                    });
                  },
                  child: SvgPicture.asset(
                    'assets/play-button-4213.svg',
                    height: 20,
                  ),
                ),
          InkWell(
            onTap: () async {
              await SpotifyApi.skip();
            },
            child: SvgPicture.asset(
              'assets/forward.svg',
              height: 16,
            ),
          )
        ],
      ),
    );
  }
}


//   return FutureBuilder(
  //       future: Provider.of<TrackProvider>(context).setTimer(),
  //       builder: (context, snapshot) {
  //         if (snapshot.hasData) {
  //           return Consumer<TrackProvider>(builder: (_, trackProv, __) {
  //             return Container(
  //               height: MediaQuery.of(context).size.height * 0.17,
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.all(Radius.circular(10)),
  //                 boxShadow: const [
  //                   BoxShadow(
  //                       color: Color(0x10000000),
  //                       offset: Offset(0, 0),
  //                       blurRadius: 6.0),
  //                 ],
  //               ),
  //               child: Padding(
  //                   padding: EdgeInsets.symmetric(horizontal: 15),
  //                   child: trackProv.track!.isPlaying
  //                       ? Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Container(
  //                                 height:
  //                                     MediaQuery.of(context).size.height * 0.14,
  //                                 width:
  //                                     MediaQuery.of(context).size.width * 0.3,
  //                                 decoration: BoxDecoration(
  //                                     borderRadius: BorderRadius.circular(10),
  //                                     image: DecorationImage(
  //                                         fit: BoxFit.cover,
  //                                         image:
  //                                             CustomImageProvider.cachedImage(
  //                                                 trackProv.track!
  //                                                     .trackImageUrl)!))),
  //                             Container(
  //                               width: MediaQuery.of(context).size.width * 0.43,
  //                               child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 children: [
  //                                   Text(trackProv.track!.trackName,
  //                                       maxLines: 2,
  //                                       overflow: TextOverflow.ellipsis,
  //                                       style: TextStyle(
  //                                           fontWeight: FontWeight.w600,
  //                                           fontSize: 15)),
  //                                   SizedBox(
  //                                     height:
  //                                         MediaQuery.of(context).size.height *
  //                                             0.01,
  //                                   ),
  //                                   Text(
  //                                     trackProv.track!.artistName,
  //                                     maxLines: 1,
  //                                     overflow: TextOverflow.ellipsis,
  //                                     style: TextStyle(
  //                                         fontWeight: FontWeight.normal,
  //                                         fontSize: 15,
  //                                         color: Color(0xFF707070)),
  //                                   ),
  //                                   Player(
  //                                     isPlaying: trackProv.track!.isPlaying,
  //                                   )
  //                                 ],
  //                               ),
  //                             )
  //                           ],
  //                         )
  //                       : Padding(
  //                           padding: EdgeInsets.symmetric(
  //                               horizontal:
  //                                   MediaQuery.of(context).size.width * 0.03,
  //                               vertical:
  //                                   MediaQuery.of(context).size.height * 0.03),
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.center,
  //                             children: [
  //                               Text(
  //                                   "Play some songs to alleviate your mood 🎶 ",
  //                                   style: TextStyle(
  //                                       fontWeight: FontWeight.w600,
  //                                       fontSize: 13)),
  //                               SizedBox(
  //                                 height:
  //                                     MediaQuery.of(context).size.height * 0.03,
  //                               ),
  //                               Player(
  //                                 isPlaying: trackProv.track!.isPlaying,
  //                               )
  //                             ],
  //                           ),
  //                         )),
  //             );
  //           });
  //         } else if (snapshot.hasError) {
  //           return Container(
  //               height: MediaQuery.of(context).size.height * 0.17,
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.all(Radius.circular(10)),
  //                 boxShadow: const [
  //                   BoxShadow(
  //                       color: Color(0x10000000),
  //                       offset: Offset(0, 0),
  //                       blurRadius: 6.0),
  //                 ],
  //               ),
  //               child: Text("error"));
  //         } else {
  //           return Container(
  //               height: MediaQuery.of(context).size.height * 0.17,
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.all(Radius.circular(10)),
  //                 boxShadow: const [
  //                   BoxShadow(
  //                       color: Color(0x10000000),
  //                       offset: Offset(0, 0),
  //                       blurRadius: 6.0),
  //                 ],
  //               ),
  //               child: SpinKitCircle(
  //                 color: Colors.white,
  //                 size: 30,
  //               ));
  //         }
  //       });
  // }

  // return Consumer<TrackProvider>(
  //   builder: (_, track, __) {
  //     if (track.track == null) {
  //       return Container(
  //           height: MediaQuery.of(context).size.height * 0.17,
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.all(Radius.circular(10)),
  //             boxShadow: const [
  //               BoxShadow(
  //                   color: Color(0x10000000),
  //                   offset: Offset(0, 0),
  //                   blurRadius: 6.0),
  //             ],
  //           ),
  //           child: SpinKitCircle(
  //             color: Colors.white,
  //             size: 30,
  //           ));
  //     } else {
  //       return Container(
  //         height: MediaQuery.of(context).size.height * 0.17,
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.all(Radius.circular(10)),
  //           boxShadow: const [
  //             BoxShadow(
  //                 color: Color(0x10000000),
  //                 offset: Offset(0, 0),
  //                 blurRadius: 6.0),
  //           ],
  //         ),
  //         child: Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 15),
  //             child: track.track!.isPlaying
  //                 ? Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Container(
  //                           height: MediaQuery.of(context).size.height * 0.14,
  //                           width: MediaQuery.of(context).size.width * 0.3,
  //                           decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(10),
  //                               image: DecorationImage(
  //                                   fit: BoxFit.cover,
  //                                   image: CustomImageProvider.cachedImage(
  //                                       track.track!.trackImageUrl)!))),
  //                       Container(
  //                         width: MediaQuery.of(context).size.width * 0.43,
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             Text(track.track!.trackName,
  //                                 maxLines: 2,
  //                                 overflow: TextOverflow.ellipsis,
  //                                 style: TextStyle(
  //                                     fontWeight: FontWeight.w600,
  //                                     fontSize: 15)),
  //                             SizedBox(
  //                               height:
  //                                   MediaQuery.of(context).size.height * 0.01,
  //                             ),
  //                             Text(
  //                               track.track!.artistName,
  //                               maxLines: 1,
  //                               overflow: TextOverflow.ellipsis,
  //                               style: TextStyle(
  //                                   fontWeight: FontWeight.normal,
  //                                   fontSize: 15,
  //                                   color: Color(0xFF707070)),
  //                             ),
  //                             Player(
  //                               isPlaying: track.track!.isPlaying,
  //                             )
  //                           ],
  //                         ),
  //                       )
  //                     ],
  //                   )
  //                 : Padding(
  //                     padding: EdgeInsets.symmetric(
  //                         horizontal:
  //                             MediaQuery.of(context).size.width * 0.03,
  //                         vertical:
  //                             MediaQuery.of(context).size.height * 0.03),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Text("Play some songs to alleviate your mood 🎶 ",
  //                             style: TextStyle(
  //                                 fontWeight: FontWeight.w600, fontSize: 13)),
  //                         SizedBox(
  //                           height: MediaQuery.of(context).size.height * 0.03,
  //                         ),
  //                         Player(
  //                           isPlaying: track.track!.isPlaying,
  //                         )
  //                       ],
  //                     ),
  //                   )),
  //       );
  //     }
  //   },
  // child: Container(
  //   height: MediaQuery.of(context).size.height * 0.17,
  //   decoration: BoxDecoration(
  //     color: Colors.white,
  //     borderRadius: BorderRadius.all(Radius.circular(10)),
  //     boxShadow: const [
  //       BoxShadow(
  //           color: Color(0x10000000),
  //           offset: Offset(0, 0),
  //           blurRadius: 6.0),
  //     ],
  //   ),
  //   child: Padding(
  //       padding: EdgeInsets.symmetric(horizontal: 15),
  //       child: track.track!.isPlaying
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
  //                                 track.track!.trackImageUrl)!))),
  //                 Container(
  //                   width: MediaQuery.of(context).size.width * 0.43,
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Text(track.track!.trackName,
  //                           maxLines: 2,
  //                           overflow: TextOverflow.ellipsis,
  //                           style: TextStyle(
  //                               fontWeight: FontWeight.w600, fontSize: 15)),
  //                       SizedBox(
  //                         height: MediaQuery.of(context).size.height * 0.01,
  //                       ),
  //                       Text(
  //                         track.track!.artistName,
  //                         maxLines: 1,
  //                         overflow: TextOverflow.ellipsis,
  //                         style: TextStyle(
  //                             fontWeight: FontWeight.normal,
  //                             fontSize: 15,
  //                             color: Color(0xFF707070)),
  //                       ),
  //                       Player(
  //                         isPlaying: track.track!.isPlaying,
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
  //                     isPlaying: track.track!.isPlaying,
  //                   )
  //                 ],
  //               ),
  //             )),
  // ),

  // return FutureBuilder<Track?>(
  //     future: SpotifyApi.getCurrentTrack(),
  //     builder: (context, snapshot) {
  //       late Widget child;
  //       if (snapshot.hasData) {
  //         Track track = snapshot.data!;
  //         if (track.isPlaying) {
  //           child = Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Container(
  //                   height: MediaQuery.of(context).size.height * 0.14,
  //                   width: MediaQuery.of(context).size.width * 0.3,
  //                   decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(10),
  //                       image: DecorationImage(
  //                           fit: BoxFit.cover,
  //                           image: CustomImageProvider.cachedImage(
  //                               track.trackImageUrl)!))),
  //               Container(
  //                 width: MediaQuery.of(context).size.width * 0.43,
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Text(track.trackName,
  //                         maxLines: 2,
  //                         overflow: TextOverflow.ellipsis,
  //                         style: TextStyle(
  //                             fontWeight: FontWeight.w600, fontSize: 15)),
  //                     SizedBox(
  //                       height: MediaQuery.of(context).size.height * 0.01,
  //                     ),
  //                     Text(
  //                       track.artistName,
  //                       maxLines: 1,
  //                       overflow: TextOverflow.ellipsis,
  //                       style: TextStyle(
  //                           fontWeight: FontWeight.normal,
  //                           fontSize: 15,
  //                           color: Color(0xFF707070)),
  //                     ),
  //                     Player(
  //                       isPlaying: track.isPlaying,
  //                     )
  //                   ],
  //                 ),
  //               )
  //             ],
  //           );
  //         } else {
  //           child = Padding(
  //             padding: EdgeInsets.symmetric(
  //                 horizontal: MediaQuery.of(context).size.width * 0.03,
  //                 vertical: MediaQuery.of(context).size.height * 0.03),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 Text("Play some songs to alleviate your mood 🎶 ",
  //                     style: TextStyle(
  //                         fontWeight: FontWeight.w600, fontSize: 13)),
  //                 SizedBox(
  //                   height: MediaQuery.of(context).size.height * 0.03,
  //                 ),
  //                 Player(
  //                   isPlaying: track.isPlaying,
  //                 )
  //               ],
  //             ),
  //           );
  //         }
  //       } else if (snapshot.hasError) {
  //         child = Text("error");
  //       } else {
  //         child = SpinKitCircle(
  //           color: Colors.white,
  //           size: 30,
  //         );
  //       }

  //       return Container(
  //         height: MediaQuery.of(context).size.height * 0.17,
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.all(Radius.circular(10)),
  //           boxShadow: const [
  //             BoxShadow(
  //                 color: Color(0x10000000),
  //                 offset: Offset(0, 0),
  //                 blurRadius: 6.0),
  //           ],
  //         ),
  //         child: Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 15), child: child),
  //       );
  //     });

  // return FutureBuilder<Track?>(
  //     future: SpotifyApi.getCurrentTrack(),
  //     builder: (context, snapshot) {
  //       late Widget child;
  //       if (snapshot.hasData) {
  //         Track track = snapshot.data!;
  //         if (track.isPlaying) {
  //           child = Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Container(
  //                   height: MediaQuery.of(context).size.height * 0.14,
  //                   width: MediaQuery.of(context).size.width * 0.3,
  //                   decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(10),
  //                       image: DecorationImage(
  //                           fit: BoxFit.cover,
  //                           image: CustomImageProvider.cachedImage(
  //                               track.trackImageUrl)!))),
  //               Container(
  //                 width: MediaQuery.of(context).size.width * 0.43,
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Text(track.trackName,
  //                         maxLines: 2,
  //                         overflow: TextOverflow.ellipsis,
  //                         style: TextStyle(
  //                             fontWeight: FontWeight.w600, fontSize: 15)),
  //                     SizedBox(
  //                       height: MediaQuery.of(context).size.height * 0.01,
  //                     ),
  //                     Text(
  //                       track.artistName,
  //                       maxLines: 1,
  //                       overflow: TextOverflow.ellipsis,
  //                       style: TextStyle(
  //                           fontWeight: FontWeight.normal,
  //                           fontSize: 15,
  //                           color: Color(0xFF707070)),
  //                     ),
  //                     Player(
  //                       isPlaying: track.isPlaying,
  //                     )
  //                   ],
  //                 ),
  //               )
  //             ],
  //           );
  //         } else {
  //           child = Padding(
  //             padding: EdgeInsets.symmetric(
  //                 horizontal: MediaQuery.of(context).size.width * 0.03,
  //                 vertical: MediaQuery.of(context).size.height * 0.03),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 Text("Play some songs to alleviate your mood 🎶 ",
  //                     style: TextStyle(
  //                         fontWeight: FontWeight.w600, fontSize: 13)),
  //                 SizedBox(
  //                   height: MediaQuery.of(context).size.height * 0.03,
  //                 ),
  //                 Player(
  //                   isPlaying: track.isPlaying,
  //                 )
  //               ],
  //             ),
  //           );
  //         }
  //       } else if (snapshot.hasError) {
  //         child = Text("error");
  //       } else {
  //         child = SpinKitCircle(
  //           color: Colors.white,
  //           size: 30,
  //         );
  //       }

  //       return Container(
  //         height: MediaQuery.of(context).size.height * 0.17,
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.all(Radius.circular(10)),
  //           boxShadow: const [
  //             BoxShadow(
  //                 color: Color(0x10000000),
  //                 offset: Offset(0, 0),
  //                 blurRadius: 6.0),
  //           ],
  //         ),
  //         child: Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 15), child: child),
  //       );
  //     });