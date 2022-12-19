import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprut/business_logic/blocs/connection_bloc/connection_bloc.dart';
import 'package:sprut/business_logic/blocs/connection_bloc/connection_bloc.dart';
import 'package:sprut/business_logic/blocs/connection_bloc/connection_state/connection_state.dart';
import 'package:sprut/resources/assets_path/assets_path.dart';

import '../../../../../../resources/app_constants/app_constants.dart';
import '../../../../../../resources/app_themes/app_themes.dart';
import '../../../../../resources/configs/helpers/helpers.dart';
import '../../no_internet/no_internet.dart';
import '../controllers/about_us_controller.dart';

class AboutUsView extends GetView<AboutUsController> {
  const AboutUsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Helpers.systemStatusBar();

    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;
    return BlocConsumer<ConnectedBloc, ConnectedState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, connectionState) {
    if (connectionState is ConnectedFailureState) {

      return NoInternetScreen(onPressed: () async {});
    }

    if (connectionState is ConnectedSucessState) {}
    return GetBuilder<AboutUsController>(
      init: AboutUsController(),
      initState: (_) {},
      builder: (_) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    language.about_us,
                    style: textTheme.bodyText1!.copyWith(
                        fontSize: 14.sp,
                        color: AppThemes.dark,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(7),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        language.basic_info,
                        style: textTheme.bodyText1!.copyWith(
                          fontSize: 10.sp,
                          color: AppThemes.lightGrey,
                        ),
                      ),
                      buildItem(context, language, AssetsPath.gotoSprut,
                          language.go_to_sprut, 0),
                      buildItem(context, language, AssetsPath.privacyPolicy,
                          language.privacy_policy, 1),
                      buildItem(context, language, AssetsPath.emailContact,
                          language.email_contact, 2),
                      buildItem(context, language, AssetsPath.callUs,
                          language.call_us, 3),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(7),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        language.social_network,
                        style: textTheme.bodyText1!.copyWith(
                          fontSize: 10.sp,
                          color: AppThemes.lightGrey,
                        ),
                      ),
                      buildItem(context, language, AssetsPath.facebook,
                          language.facebook, 4),
                      buildItem(context, language, AssetsPath.instagram,
                          language.instagram, 5),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    language.sprut_version,
                    style: textTheme.bodyText1!.copyWith(
                      fontSize: 11.sp,
                      color: AppThemes.dark,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
              ],
            ),
          ),
        );
      },
    );
  },
);
  }

  Widget buildItem(BuildContext context, AppLocalizations language, String icon,
      String title, int index) {
    return Container(
      margin: EdgeInsets.all(
        4.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(7),
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (index == 0) {
                controller.openUrl(language.goto_sprut_url);
              } else if (index == 1) {
                controller.openUrl(language.privacy_policy_url);
              } else if (index == 2) {
                String emailTo =
                    "mailto:${AppConstants.DEFAULT_EMAIL}?subject=${language.email_subject} ${Platform.isAndroid ? "Android" : "iOS"} v1.0";
                controller.openUrl(emailTo);
              } else if (index == 3) {
                controller.openUrl("tel:" + AppConstants.DEFAULT_PHONE);
              } else if (index == 4) {
                controller.openUrl(language.facebook_url);
              } else if (index == 5) {
                controller.openUrl(language.instagram_url);
              }
            },
            child: Container(
              alignment: Alignment.center,
              height: 60,
              padding: EdgeInsets.all(4),
              child: Row(
                children: [
                  Container(
                    height: 3.0.h,
                    width: index == 2 ? 5.5.w : 6.w,
                    child: index == 0
                        ? Image.asset(
                            icon,
                            alignment: Alignment.centerLeft,
                          )
                        : SvgPicture.asset(
                            icon,
                            alignment: Alignment.centerLeft,
                          ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: AppConstants.fontFamily,
                          fontWeight: FontWeight.w400,
                          fontSize: 11.sp),
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Container(
                    height: 1.5.h,
                    width: 5.w,
                    child: SvgPicture.asset(AssetsPath.arrowForward),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 44.0),
            child: const Divider(
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
