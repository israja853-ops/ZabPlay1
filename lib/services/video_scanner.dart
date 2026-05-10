import 'package:photo_manager/photo_manager.dart';

class VideoScanner {

  static Future<List<AssetEntity>> loadVideos() async {

    final permission =
        await PhotoManager.requestPermissionExtend();

    if (!permission.isAuth) {
      return [];
    }

    List<AssetPathEntity> albums =
        await PhotoManager.getAssetPathList(
      type: RequestType.video,
    );

    List<AssetEntity> videos = [];

    for (var album in albums) {

      final media =
          await album.getAssetListPaged(
        page: 0,
        size: 1000,
      );

      videos.addAll(media);
    }

    return videos;
  }
}
