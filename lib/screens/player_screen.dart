import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

import '../widgets/video_thumbnail_widget.dart';

class PlayerScreen extends StatefulWidget {

  final File file;
  final List videos;
  final int currentIndex;

  const PlayerScreen({
    super.key,
    required this.file,
    required this.videos,
    required this.currentIndex,
  });

  @override
  State<PlayerScreen> createState() =>
      _PlayerScreenState();
}

class _PlayerScreenState
    extends State<PlayerScreen> {

  BetterPlayerController? controller;

  @override
  void initState() {
    super.initState();

    setupPlayer();
  }

  setupPlayer() {

    BetterPlayerDataSource dataSource =
        BetterPlayerDataSource(
      BetterPlayerDataSourceType.file,
      widget.file.path,
    );

    controller = BetterPlayerController(

      BetterPlayerConfiguration(
        autoPlay: true,
        fit: BoxFit.cover,
        aspectRatio: 16 / 9,

        controlsConfiguration:
            const BetterPlayerControlsConfiguration(

          enableFullscreen: true,
          enablePlayPause: true,
          enableMute: true,
          enablePlaybackSpeed: true,
          playerTheme: BetterPlayerTheme.material,
        ),
      ),
    );

    controller!.setupDataSource(dataSource);

    controller!.addEventsListener((event) {

      if (event.betterPlayerEventType ==
          BetterPlayerEventType.finished) {

        playNextVideo();
      }
    });
  }

  playNextVideo() async {

    int next = widget.currentIndex + 1;

    if (next >= widget.videos.length) {
      return;
    }

    final nextVideo = widget.videos[next];

    final nextFile = await nextVideo.file;

    if (nextFile == null) return;

    Navigator.pushReplacement(

      context,

      MaterialPageRoute(

        builder: (_) => PlayerScreen(
          file: nextFile,
          videos: widget.videos,
          currentIndex: next,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xff050518),

      body: SafeArea(

        child: Column(

          children: [

            AspectRatio(
              aspectRatio: 16 / 9,

              child: BetterPlayer(
                controller: controller!,
              ),
            ),

            const Padding(

              padding: EdgeInsets.all(16),

              child: Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  "Next.UP",

                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Expanded(

              child: ListView.builder(

                itemCount: widget.videos.length,

                itemBuilder: (context, index) {

                  final video = widget.videos[index];

                  return FutureBuilder(

                    future: video.file,

                    builder: (context, snapshot) {

                      if (!snapshot.hasData) {
                        return const SizedBox();
                      }

                      final file = snapshot.data!;

                      return GestureDetector(

                        onTap: () {

                          Navigator.pushReplacement(

                            context,

                            MaterialPageRoute(

                              builder: (_) => PlayerScreen(
                                file: file,
                                videos: widget.videos,
                                currentIndex: index,
                              ),
                            ),
                          );
                        },

                        child: Container(

                          height: 100,

                          margin:
                              const EdgeInsets.all(10),

                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(18),

                            color: Colors.black26,
                          ),

                          child: Row(

                            children: [

                              SizedBox(
                                width: 160,

                                child:
                                    VideoThumbnailWidget(
                                  path: file.path,
                                ),
                              ),

                              Expanded(

                                child: Padding(

                                  padding:
                                      const EdgeInsets.all(12),

                                  child: Column(

                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    mainAxisAlignment:
                                        MainAxisAlignment.center,

                                    children: [

                                      Text(
                                        video.title ??
                                            "Video",

                                        maxLines: 1,

                                        style:
                                            const TextStyle(
                                          fontSize: 18,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(
                                          height: 8),

                                      Text(
                                        "${video.duration ~/ 60} min",
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const Padding(
                                padding:
                                    EdgeInsets.all(12),

                                child: Icon(
                                  Icons.more_vert,
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
          ],
        ),
      ),
    );
  }
}
