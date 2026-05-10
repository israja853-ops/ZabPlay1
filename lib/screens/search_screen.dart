import 'package:flutter/material.dart';

import '../widgets/video_thumbnail_widget.dart';
import 'player_screen.dart';

class SearchScreen extends StatefulWidget {

  final List videos;

  const SearchScreen({
    super.key,
    required this.videos,
  });

  @override
  State<SearchScreen> createState() =>
      _SearchScreenState();
}

class _SearchScreenState
    extends State<SearchScreen> {

  List filtered = [];

  @override
  void initState() {
    super.initState();

    filtered = widget.videos;
  }

  search(String value) {

    setState(() {

      filtered = widget.videos.where((video) {

        return video.title
            .toString()
            .toLowerCase()
            .contains(
              value.toLowerCase(),
            );

      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xff050518),

      appBar: AppBar(

        backgroundColor:
            Colors.transparent,

        title: TextField(

          onChanged: search,

          style: const TextStyle(
            color: Colors.white,
          ),

          decoration: InputDecoration(

            hintText: "Search videos...",

            hintStyle: const TextStyle(
              color: Colors.white54,
            ),

            filled: true,

            fillColor: Colors.black26,

            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(20),

              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),

      body: ListView.builder(

        itemCount: filtered.length,

        itemBuilder: (context, index) {

          final video = filtered[index];

          return FutureBuilder(

            future: video.file,

            builder: (context, snapshot) {

              if (!snapshot.hasData) {
                return const SizedBox();
              }

              final file = snapshot.data!;

              return GestureDetector(

                onTap: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (_) => PlayerScreen(
                        file: file,
                        videos: filtered,
                        currentIndex: index,
                      ),
                    ),
                  );
                },

                child: Container(

                  height: 120,

                  margin:
                      const EdgeInsets.all(12),

                  decoration: BoxDecoration(

                    borderRadius:
                        BorderRadius.circular(20),

                    color: Colors.black12,
                  ),

                  child: Row(

                    children: [

                      SizedBox(

                        width: 170,

                        child:
                            VideoThumbnailWidget(
                          path: file.path,
                        ),
                      ),

                      Expanded(

                        child: Padding(

                          padding:
                              const EdgeInsets.all(
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
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
