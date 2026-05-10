import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../services/video_scanner.dart';
import '../services/history_service.dart';

import '../widgets/video_thumbnail_widget.dart';

import 'player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List videos = [];
  List shorts = [];

  List<String> history = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

    loadVideos();
  }

  loadVideos() async {

    final result =
        await VideoScanner.loadVideos();

    history =
        await HistoryService.loadHistory();

    for (var video in result) {

      if (video.duration <= 60) {
        shorts.add(video);
      } else {
        videos.add(video);
      }
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xff050518),

      appBar: AppBar(

        elevation: 0,
        backgroundColor: Colors.transparent,

        title: const Text(
          "ZebPlay",

          style: TextStyle(
            color: Colors.purpleAccent,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [

          IconButton(

            onPressed: () {},

            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),

          IconButton(

            onPressed: () {},

            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ),
        ],
      ),

      body: loading

          ? const Center(
              child: CircularProgressIndicator(),
            )

          : ListView(

              children: [

                if (history.isNotEmpty)

                const Padding(

                  padding: EdgeInsets.all(12),

                  child: Text(
                    "Recently Watched",

                    style: TextStyle(
                      fontSize: 28,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

                if (history.isNotEmpty)

                SizedBox(

                  height: 220,

                  child: ListView.builder(

                    scrollDirection:
                        Axis.horizontal,

                    itemCount: history.length,

                    itemBuilder:
                        (context, index) {

                      final path =
                          history[index];

                      return Container(

                        width: 170,

                        margin:
                            const EdgeInsets.all(
                                10),

                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius
                                  .circular(20),

                          color: Colors.black12,
                        ),

                        child: Stack(

                          children: [

                            Positioned.fill(

                              child:
                                  VideoThumbnailWidget(
                                path: path,
                              ),
                            ),

                            Positioned(

                              bottom: 10,
                              left: 10,

                              child: Container(

                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),

                                decoration:
                                    BoxDecoration(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                              10),

                                  color:
                                      Colors.black54,
                                ),

                                child:
                                    const Text(
                                  "Recent",
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const Padding(

                  padding: EdgeInsets.all(12),

                  child: Text(
                    "Shorts",

                    style: TextStyle(
                      fontSize: 28,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(

                  height: 240,

                  child: ListView.builder(

                    scrollDirection:
                        Axis.horizontal,

                    itemCount: shorts.length,

                    itemBuilder:
                        (context, index) {

                      final video =
                          shorts[index];

                      return FutureBuilder(

                        future: video.file,

                        builder:
                            (context, snapshot) {

                          if (!snapshot.hasData) {
                            return const SizedBox();
                          }

                          final file =
                              snapshot.data!;

                          return GestureDetector(

                            onTap: () {

                              Navigator.push(

                                context,

                                MaterialPageRoute(

                                  builder: (_) =>
                                      PlayerScreen(
                                    file: file,
                                    videos: shorts,
                                    currentIndex:
                                        index,
                                  ),
                                ),
                              );
                            },

                            child: Container(

                              width: 150,

                              margin:
                                  const EdgeInsets
                                      .all(10),

                              decoration:
                                  BoxDecoration(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            20),

                                color:
                                    Colors.black12,
                              ),

                              child: Stack(

                                children: [

                                  Positioned.fill(

                                    child:
                                        VideoThumbnailWidget(
                                      path:
                                          file.path,
                                    ),
                                  ),

                                  Positioned(

                                    bottom: 10,
                                    left: 10,

                                    child: Row(

                                      children: [

                                        const Icon(
                                          Icons
                                              .play_circle_fill,

                                          color: Colors
                                              .white,
                                        ),

                                        const SizedBox(
                                            width:
                                                5),

                                        Text(
                                          "${video.duration}s",

                                          style:
                                              const TextStyle(
                                            color:
                                                Colors
                                                    .white,

                                            fontSize:
                                                16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                const Padding(

                  padding: EdgeInsets.all(12),

                  child: Text(
                    "All Videos",

                    style: TextStyle(
                      fontSize: 28,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

                ListView.builder(

                  physics:
                      const NeverScrollableScrollPhysics(),

                  shrinkWrap: true,

                  itemCount: videos.length,

                  itemBuilder:
                      (context, index) {

                    final video =
                        videos[index];

                    return FutureBuilder(

                      future: video.file,

                      builder:
                          (context, snapshot) {

                        if (!snapshot.hasData) {
                          return const SizedBox();
                        }

                        final file =
                            snapshot.data!;

                        return GestureDetector(

                          onTap: () {

                            Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder: (_) =>
                                    PlayerScreen(
                                  file: file,
                                  videos: videos,
                                  currentIndex:
                                      index,
                                ),
                              ),
                            );
                          },

                          child: Container(

                            height: 120,

                            margin:
                                const EdgeInsets
                                    .all(12),

                            decoration:
                                BoxDecoration(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          20),

                              color:
                                  Colors.black12,
                            ),

                            child: Row(

                              children: [

                                SizedBox(

                                  width: 170,

                                  child:
                                      VideoThumbnailWidget(
                                    path:
                                        file.path,
                                  ),
                                ),

                                Expanded(

                                  child: Padding(

                                    padding:
                                        const EdgeInsets
                                            .all(
                                                12),

                                    child: Column(

                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,

                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,

                                      children: [

                                        Text(
                                          video.title ??
                                              "Video",

                                          maxLines:
                                              1,

                                          style:
                                              const TextStyle(
                                            fontSize:
                                                18,

                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(
                                            height:
                                                8),

                                        Text(
                                          "${video.duration ~/ 60} min",

                                          style:
                                              const TextStyle(
                                            color:
                                                Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const Padding(

                                  padding:
                                      EdgeInsets
                                          .all(
                                              12),

                                  child: Icon(
                                    Icons
                                        .more_vert,

                                    color: Colors
                                        .white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),

      bottomNavigationBar:
          BottomNavigationBar(

        backgroundColor:
            const Color(0xff0b061f),

        selectedItemColor:
            Colors.purpleAccent,

        unselectedItemColor:
            Colors.white70,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(
                Icons.video_library),
            label: "Videos",
          ),

          BottomNavigationBarItem(
            icon: Icon(
                Icons.music_note),
            label: "Music",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: "Files",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            label: "Photos",
          ),
        ],
      ),
    );
  }
}
