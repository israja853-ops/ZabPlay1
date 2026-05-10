import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoThumbnailWidget extends StatefulWidget {

  final String path;

  const VideoThumbnailWidget({
    super.key,
    required this.path,
  });

  @override
  State<VideoThumbnailWidget> createState() =>
      _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState
    extends State<VideoThumbnailWidget> {

  String? thumbnail;

  @override
  void initState() {
    super.initState();
    loadThumbnail();
  }

  loadThumbnail() async {

    final thumb = await VideoThumbnail.thumbnailFile(
      video: widget.path,
      imageFormat: ImageFormat.JPEG,
      quality: 100,
    );

    setState(() {
      thumbnail = thumb;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (thumbnail == null) {

      return Container(
        color: Colors.black26,

        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),

      child: Image.file(
        File(thumbnail!),
        fit: BoxFit.cover,
      ),
    );
  }
}
