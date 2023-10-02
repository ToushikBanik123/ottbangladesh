import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPageController extends GetxController {
  WebViewController? webViewController;
  late int stackIndex;

  void handleLoad(String value) {
    stackIndex = 0;
    update(["body"]);
  }

  @override
  void onInit() {
    stackIndex = 1;
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
