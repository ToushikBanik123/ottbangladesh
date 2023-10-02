import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../file_server/file_server.dart';
import '../../more_menu/more_option_view.dart';
import '../../tv/live_tv.dart';
import '../../update/update.dart';
import '../../videos/container/videos_container_page.dart';

class HomeContainerController extends GetxController {
  late Widget body;
  late int selectedBottomBarIndex;

  @override
  void onInit() {
    body = LiveTvPage();
    selectedBottomBarIndex = 2;

    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void changeBottomBarIndex(int index) {
    selectedBottomBarIndex = index;

    switch (index) {
      case 0:
        body = FileServerPage(url: "http://fs.nbox.live");
        break;

      case 1:
        body = VideosContainerPage();
        break;

      case 2:
        body = LiveTvPage();
        break;

      case 3:
        body = UpdatePage();
        break;

      case 4:
        //body = RequestPage(url: "http://play.nbox.live/request/");
        showModalBottomSheet(
          backgroundColor: Colors.blueAccent,
          context: Get.context!,
          builder: (BuildContext context) {
            return MoreOptionView();
          },
        );
        showBottomSheet(
          backgroundColor: Colors.blueAccent,
          context: Get.context!,
          builder: (BuildContext context) {
            return MoreOptionView();
          },
        );
        break;

      default:
        body = LiveTvPage();
        break;
    }

    update(['bottom_bar', 'body', 'fab']);
  }
}
