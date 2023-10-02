
import '../model/video_category/video_category.dart';

class VideoCategoryListResponse {
  List<VideoCategory> list = [];

  VideoCategoryListResponse.fromJson(List<dynamic> json) {
    if (json.isNotEmpty) {
      json.forEach(
        (element) {
          list.add(VideoCategory.fromJson(element as Map<String, dynamic>));
        },
      );
    }
  }
}
