import 'package:url_launcher/url_launcher.dart';

class LaunchUrlUtil {
  static Future<void> launchURL(String url) async {
    await launch(url);
  }
}
