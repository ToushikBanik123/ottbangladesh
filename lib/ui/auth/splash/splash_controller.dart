import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';

import '../../../base/exception/app_exception.dart';
import '../../home/container/home_container.dart';

class SplashController extends GetxController {
  late Future<bool> isInternetAvailable;

  void goToNextPage() {
    Get.offAll(
      () => HomeContainerPage(),
    );
  }

  @override
  void onInit() {
    isInternetAvailable = isConnected();
    super.onInit();
  }

  Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Timer(
          Duration(seconds: 2),
          goToNextPage,
        );
        return true;
      } else {
        throw AppException("Connection failure");
      }
    } on SocketException catch (_) {
      throw AppException(
        "No Internet Connection. Please check your connection and try again.",
      );
    }
  }

  void retryToConnect() {
    isInternetAvailable = isConnected();
    update(["body"]);
  }
}
