import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../models/artist.dart';
import '../../../models/custom_image_provider.dart';
import '../../../models/track.dart';
import '../../../services/spotify_api.dart';

class TopArtists extends StatefulWidget {
  const TopArtists({Key? key}) : super(key: key);

  @override
  State<TopArtists> createState() => _TopArtistsState();
}

class _TopArtistsState extends State<TopArtists> {
  late StreamController<List<Artist>?> _streamController;
  final ScrollController _scrollController = ScrollController();
  late Timer _timer;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _streamController.close();
    _timer.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _streamController = StreamController<List<Artist>?>.broadcast();

    Timer.run(() async {
      await getTopArtists();
    });
    _timer = Timer.periodic(Duration(seconds: 30), (timer) async {
      await getTopArtists();
    });
  }

  Future<void> getTopArtists() async {
    try {
      List<Artist>? artists = await SpotifyApi.getTopArtists();
      _streamController.sink.add(artists);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Artist>?>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                  height: MediaQuery.of(context).size.height * 0.2,
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
                  height: MediaQuery.of(context).size.height * 0.2,
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
                  child: Text(
                    "Error occured. Try to reload.",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                );
              } else {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.25,
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
                        padding: EdgeInsets.only(left: 15, top: 20, bottom: 13),
                        child: Text(
                          "Top Artists",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                      ),
                      // SizedBox(
                      //   height: MediaQuery.of(context).size.height * 0.01,
                      // ),
                      snapshot.data!.isEmpty
                          ? Center(
                              child: Text(
                              "Not enough data",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 15),
                            ))
                          : Expanded(
                              child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  controller: _scrollController,
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.05,
                                    );
                                  },
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return index == 0
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: buildCard(
                                                snapshot.data![index], index),
                                          )
                                        : index == snapshot.data!.length - 1
                                            ? Padding(
                                                padding:
                                                    EdgeInsets.only(right: 15),
                                                child: buildCard(
                                                    snapshot.data![index],
                                                    index))
                                            : buildCard(
                                                snapshot.data![index], index);
                                  }),
                            ),
                      SizedBox(
                        height: 25,
                      )
                    ],
                  ),
                );
              }
          }
        });
  }

  Widget buildCard(Artist artist, int index) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.18,
      width: MediaQuery.of(context).size.width * 0.26,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${index + 1}. ${artist.artistName}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Color(0xFF707070)),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.04,
          ),
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CustomImageProvider.cachedImage(
                            artist.artistImageUrl)!))),
          ),
        ],
      ),
    );
  }
}
