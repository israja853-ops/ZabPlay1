import 'package:flutter/material.dart';
import '../services/video_scanner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List videos = [];
  List shorts = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadVideos();
  }

  loadVideos() async {

    final result = await VideoScanner.loadVideos();

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

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "ZebPlay",
          style: TextStyle(
            color: Colors.purpleAccent,
            fontSize: 32,
          ),
        ),
      ),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )

          : ListView(

              children: [

                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    "Shorts",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(
                  height: 240,

                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,

                    itemCount: shorts.length,

                    itemBuilder: (context, index) {

                      final video = shorts[index];

                      return Container(
                        width: 140,
                        margin: const EdgeInsets.all(10),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black26,
                        ),

                        child: Center(
                          child: Text(
                            "${video.duration}s",
                          ),
                        ),
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                ListView.builder(

                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,

                  itemCount: videos.length,

                  itemBuilder: (context, index) {

                    final video = videos[index];

                    return Container(

                      height: 110,

                      margin: const EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black26,
                      ),

                      child: ListTile(

                        title: Text(
                          video.title ?? "Video",
                        ),

                        subtitle: Text(
                          "${video.duration ~/ 60} min",
                        ),

                        trailing: const Icon(
                          Icons.more_vert,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
