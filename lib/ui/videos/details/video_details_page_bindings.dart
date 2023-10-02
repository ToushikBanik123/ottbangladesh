import 'package:get/get.dart';

import 'video_details_page_controller.dart';

class VideoDetailsPageBindings extends Bindings {
  final String videoType;
  final String slug;

  VideoDetailsPageBindings({
    required this.videoType,
    required this.slug,
  });

  @override
  void dependencies() {
    Get.put(
      VideoDetailsPageController(
        videoType: videoType,
        slug: slug,
      ),
    );
  }
}
