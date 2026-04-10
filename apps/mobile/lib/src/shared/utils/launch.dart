import 'package:url_launcher/url_launcher_string.dart';

abstract class Launch {
  static Future<void> open(String scheme) async {
    if (await canLaunchUrlString(scheme)) {
      await launchUrlString(scheme);
    } else {
      throw 'Could not launch';
    }
  }

  static Future<void> openLink(String url) => open(url);
}
