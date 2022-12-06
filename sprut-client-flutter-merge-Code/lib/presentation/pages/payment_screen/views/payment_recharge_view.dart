import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../resources/configs/helpers/helpers.dart';
import '../../../../resources/app_constants/app_constants.dart';
import '../../payment_screen/controllers/payment_controller.dart';

class PaymentRechargeView extends GetView<PaymentController> {
  PaymentRechargeView({Key? key}) : super(key: key);

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    //Food delivery
    if(Helpers.isLoginTypeIn() == AppConstants.TAXI_APP){
      Helpers.systemStatusBar();
    }else {
      Helpers.systemStatusBar1();
    }

    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;
    return GetBuilder<PaymentController>(
      init: PaymentController(),
      initState: (_) {},
      builder: (_) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: Helpers.primaryBackgroundColor(colorScheme),//food delivery
            body: SafeArea(
              top: false,
              bottom: false,
              child: Column(
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 7.w,
                                ),
                                height: 5.h,
                                width: 5.h,
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        top: 16.0,
                        bottom: 16.0,
                      ),
                      height: double.infinity,
                      child: WebView(
                        initialUrl: controller.webUrl,
                        javascriptMode: JavascriptMode.unrestricted,
                        onWebViewCreated: (WebViewController webViewController) {
                          _controller.complete(webViewController);
                        },
                        onProgress: (int progress) {
                          print('WebView is loading (progress : $progress%)');
                        },
                        javascriptChannels: <JavascriptChannel>{},
                        onPageStarted: (String url) {
                          print('Page started loading: $url');
                          if (url == "http://localhost/") {
                            Navigator.of(context).pop({"status": true});
                          }
                        },
                        onPageFinished: (String url) {
                          print('Page finished loading: $url');
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
