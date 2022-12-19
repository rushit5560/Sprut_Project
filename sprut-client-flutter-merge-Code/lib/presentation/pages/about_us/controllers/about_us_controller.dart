import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsController extends GetxController {
  @override
  void onInit() async {
    super.onInit();

    super.onInit();
  }

  Future<void> openUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }
}
