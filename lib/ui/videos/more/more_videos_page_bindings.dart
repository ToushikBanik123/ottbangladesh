import 'package:get/get.dart';
import 'more_videos_page_controller.dart';

class MoreVideosPageBindings extends Bindings {

  final String url;

  MoreVideosPageBindings({required this.url});

  @override
  void dependencies() {
    Get.lazyPut(
      () => MoreVideosPageController(url: url),
    );
  }
}
