

import '../../../constants.dart';
import '../model/video_category/video_category.dart';
import 'base_response.dart';

class VideoResourceListResponse extends BaseResponse {
  List<VideoCategory> list = [];

  VideoResourceListResponse.fromJson(Map<String, dynamic> json) : super(json) {
    if (json.containsKey(keyData) &&
        json[keyData] is List<dynamic> &&
        (json[keyData] as List<dynamic>).isNotEmpty) {
      (json[keyData] as List<dynamic>).forEach(
        (element) {
          list.add(VideoCategory.fromJson(json));
        },
      );
    }
  }
}
