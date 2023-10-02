import 'dart:collection';

import 'package:get/get.dart';

class LiveTvController extends GetxController {
  late int selectedPageIndex;
  late double bannerHeight;
  late HashMap<String, bool> endOfListMap;

  @override
  void onInit() {
    selectedPageIndex = 0;
    bannerHeight = (9 / 16) * Get.width;
    endOfListMap = HashMap<String, bool>();
    super.onInit();
  }

  void onBannerChanged(int index, int bannerCount) {
    if (index < bannerCount) {
      selectedPageIndex = index;
      update(["dot_indicator"]);
    }
  }

  void updateView(String id) {
    update([id]);
  }
}
