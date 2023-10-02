import 'package:get/get.dart';

import '../../util/lib/launch_url.dart';
import '../../util/lib/toast.dart';

class UpdatePageController extends GetxController {
  void launchUpdateUrl(String url) {
    try {
      LaunchUrlUtil.launchURL(url);
    } catch (_) {
      ToastUtil.show("Could not update the application");
    }
  }
}
