import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprut/business_logic/blocs/connection_bloc/connection_bloc.dart';
import 'package:sprut/business_logic/blocs/connection_bloc/connection_bloc.dart';
import 'package:sprut/business_logic/blocs/connection_bloc/connection_state/connection_state.dart';
import 'package:sprut/presentation/pages/settings/views/choose_cities.dart';
import 'package:sprut/presentation/pages/settings/views/reminder_view.dart';
import 'package:sprut/resources/assets_path/assets_path.dart';

import '../../../../../../resources/app_constants/app_constants.dart';
import '../../../../../../resources/app_themes/app_themes.dart';
import '../../../../../resources/configs/helpers/helpers.dart';
import '../../../../business_logic/blocs/authentication_bloc/auth_bloc/auth_bloc.dart';
import '../../../../business_logic/blocs/authentication_bloc/auth_event/auth_event.dart';
import '../../choose_on_map/controller/choose_on_map_controller.dart';
import '../../home_screen/select_cities/select_cities.dart';
import '../../home_screen/views/add_addresses_views/add_home_address_view.dart';
import '../../home_screen/views/add_addresses_views/add_work_address_view.dart';
import '../../no_internet/no_internet.dart';
import '../controllers/settings_controller.dart';
import 'fare_view.dart';

class SettingsView extends GetView<SettingsController> {
  SettingsView({Key? key}) : super(key: key);

  ChooseOnMapController chooseOnMapController =
      Get.put(ChooseOnMapController());

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

    return GetBuilder<SettingsController>(
      init: SettingsController(),
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
                    language.setting,
                    style: textTheme.bodyText1!.copyWith(
                        fontSize: 14.sp,
                        color: AppThemes.dark,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(0.0),
                    children: [
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
                              language.favourite_addresses,
                              style: textTheme.bodyText1!.copyWith(
                                fontSize: 10.sp,
                                color: AppThemes.lightGrey,
                              ),
                            ),
                            buildItem(context, language, AssetsPath.homeSvg,
                                language.home, 0),
                            buildItem(context, language, AssetsPath.workSvg,
                                language.work, 1),
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
                              language.main_settings,
                              style: textTheme.bodyText1!.copyWith(
                                fontSize: 10.sp,
                                color: AppThemes.lightGrey,
                              ),
                            ),
                            // buildItem(context, language, AssetsPath.reminder,
                            //     language.remind_about_preorder, 2),
                            buildItem(context, language, AssetsPath.city,
                                language.your_city, 3),
                            buildItem(context, language, AssetsPath.fare,
                                language.default_fare, 4),
                            // buildItem(context, language, AssetsPath.improveMap,
                            //     language.improve_maps, 5),
                            buildItem(context, language, AssetsPath.gotoSprut,
                                language.improve_sprut, 6),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          language.setting_desc,
                          style: textTheme.bodyText1!.copyWith(
                            fontSize: 9.sp,
                            color: AppThemes.lightGrey,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
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
                chooseOnMapController.isHomeAddressScreen = true;
                chooseOnMapController.isWorkAddressScreen = false;

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddHomeAddress()),
                );
              } else if (index == 1) {
                chooseOnMapController.isHomeAddressScreen = false;
                chooseOnMapController.isWorkAddressScreen = true;

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddWorkAddress()),
                );
              } else if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReminderView()),
                );
              } else if (index == 3) {
                context.read<AuthBloc>().add(AuthAvailableCitiesEvent());

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChooseCities(
                            isSettingScreen: true,
                          )),
                );
              } else if (index == 4) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FareView()),
                );
              } else if (index == 5) {
                controller.improveMaps = !controller.improveMaps;
                controller.update();
              } else if (index == 6) {
                controller.improveSprut = !controller.improveSprut;
                controller.update();
                controller.updateFirebaseCrashlytics();
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
                    width: 8.w,
                    child: index == 6
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
                  if (index < 5)
                    Container(
                      height: 1.5.h,
                      width: 5.w,
                      child: SvgPicture.asset(AssetsPath.arrowForward),
                    ),
                  if (index == 5)
                    Container(
                      height: 2.2.h,
                      width: 8.w,
                      child: SvgPicture.asset(
                        controller.improveMaps
                            ? "assets/services/checkbox_selected.svg"
                            : "assets/services/checkbox_unselected.svg",
                      ),
                    ),
                  if (index == 6)
                    Container(
                      height: 2.2.h,
                      width: 8.w,
                      child: SvgPicture.asset(
                        controller.improveSprut
                            ? "assets/services/checkbox_selected.svg"
                            : "assets/services/checkbox_unselected.svg",
                      ),
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
