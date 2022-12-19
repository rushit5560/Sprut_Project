import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../resources/app_themes/app_themes.dart';
import '../../../../../resources/configs/helpers/helpers.dart';
import '../../../../resources/app_constants/app_constants.dart';
import '../../../../resources/assets_path/assets_path.dart';
import '../../../widgets/primary_elevated_btn/primary_elevated_btn.dart';
import '../../tariff_screen/views/tariff_description/tariff_description.dart';
import '../controllers/settings_controller.dart';

class FareView extends GetView<SettingsController> {
  FareView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Helpers.systemStatusBar();

    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Container(
                          height: 5.h,
                          width: 12.h,
                          child: PrimaryElevatedBtn(
                            fontSize: 10.sp,
                            buttonText: language.save,
                            onPressed: () {
                              controller.saveDefaultFare();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...[
                        Text(
                          language.rate_title,
                          style: textTheme.bodyText1!.copyWith(
                            fontSize: 12.sp,
                            color: AppThemes.dark,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          language.rate_desc,
                          style: textTheme.bodyText1!.copyWith(
                            fontSize: 9.sp,
                            color: AppThemes.lightGrey,
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    itemCount: controller.tariffs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          controller.selectedIndex = index;
                          controller.update();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 60,
                          margin: EdgeInsets.only(
                            top: 4,
                            bottom: 4,
                          ),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(7),
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                height: 4.h,
                                width: 15.w,
                                child: Image.asset(
                                  controller.getIconExist(
                                      controller.tariffs[index].code),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                                controller.tariffs[index].name!,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                        AppConstants.fontFamily,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 10.sp)),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              showCupertinoModalBottomSheet(
                                                expand: false,
                                                enableDrag: true,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14)),
                                                context: context,
                                                builder: (context) => SafeArea(
                                                  child: TariffDescription(
                                                    carPath:
                                                        'assets/tariffs/${controller.tariffs[index].code}.svg',
                                                    downTime: (controller
                                                                    .tariffs[
                                                                        index]
                                                                    .prices!
                                                                    .waiting! /
                                                                10)
                                                            .toInt()
                                                            .toString() +
                                                        ' ₴ ' "/ " +
                                                        "10" +
                                                        " " +
                                                        language.min,
                                                    minumumCost: (controller
                                                                    .tariffs[
                                                                        index]
                                                                    .prices!
                                                                    .minimum! /
                                                                100)
                                                            .toInt()
                                                            .toString() +
                                                        ' ₴',
                                                    numberOfSheet: controller
                                                            .tariffs[index]
                                                            .numberOfSeats ??
                                                        "",
                                                    priceForkm: (controller
                                                                    .tariffs[
                                                                        index]
                                                                    .prices!
                                                                    .moving! /
                                                                100)
                                                            .toInt()
                                                            .toString() +
                                                        " " +
                                                        ' ₴',
                                                    carName: controller
                                                        .tariffs[index].name!,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: SvgPicture.asset(
                                              AssetsPath.infoIcon,
                                              height: 4.w,
                                              color: Colors.black,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 2.5.h,
                                width: 8.w,
                                child: SvgPicture.asset(
                                  controller.selectedIndex == index
                                      ? "assets/payments/radio_selected.svg"
                                      : "assets/payments/radio_unselected.svg",
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
