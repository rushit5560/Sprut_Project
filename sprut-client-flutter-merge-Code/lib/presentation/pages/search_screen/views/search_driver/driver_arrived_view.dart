import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../resources/app_themes/app_themes.dart';
import '../../../../../resources/assets_path/assets_path.dart';
import '../../controllers/search_controller.dart';

class DriverArrivedView extends GetView<SearchController> {
  const DriverArrivedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return GetBuilder<SearchController>(
      initState: (_) {},
      builder: (_) {
        return Scaffold(
          body: SafeArea(
            top: false,
            bottom: false,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      width: 14.w,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: controller.isBottomSheetExpanded
                            ? colorScheme.primary
                            : Color(0xffC4C4C4),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(7),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 8.0,
                        ),
                        Obx(
                          () {
                            return Text(
                              '${controller.orderModel.car?.driverName}' +
                                  language.waiting_driver +
                                  '${controller.orderWaitingTime}',
                              style: textTheme.bodyText1!.copyWith(
                                fontSize: 14.sp,
                                color: AppThemes.darkGrey,
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          "${controller.orderModel.car?.licensePlateNumber}",
                          style: textTheme.bodyText1!.copyWith(
                              fontSize: 13.sp, color: AppThemes.primary),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          "${controller.orderModel.car?.colorRaw} ${controller.orderModel.car?.makeRaw} ${controller.orderModel.car?.modelRaw} • ${controller.orderModel.rate?.name!}",
                          style: textTheme.bodyText1!.copyWith(
                              fontSize: 10.sp, color: AppThemes.lightGrey),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: colorScheme.primary,
                              shape: BoxShape.circle),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              AssetsPath.sprut,
                              height: 3.5.h,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${controller.orderModel.car?.driverName}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyText1!.copyWith(
                                  fontSize: 13.sp, color: Colors.black),
                            ),
                            SizedBox(
                              height: 2.0,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 2.0),
                              padding: EdgeInsets.only(left: 4.0, right: 4.0),
                              color: AppThemes.primary,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${controller.orderModel.car?.rating}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.bodyText1!.copyWith(
                                        fontSize: 10.sp, color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 2.0,
                                  ),
                                  SvgPicture.asset(AssetsPath.star),
                                ],
                              ),
                            )
                          ],
                        ),
                        Spacer(),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            controller.callDriver();
                          },
                          child: Container(
                            height: 8.h,
                            width: 17.w,
                            padding: EdgeInsets.only(
                                left: 5, right: 5, top: 2, bottom: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 4.h,
                                    child: SvgPicture.asset(AssetsPath.call),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    language.call,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 8,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            controller.shareDriverInfo(context);
                          },
                          child: Container(
                            height: 8.h,
                            width: 17.w,
                            padding: EdgeInsets.only(
                                left: 5, right: 5, top: 2, bottom: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 4.h,
                                    child: SvgPicture.asset(AssetsPath.share),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    language.share,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 8,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (controller.isBottomSheetExpanded)
                    SizedBox(
                      height: 12,
                    ),
                  if (controller.isBottomSheetExpanded)
                    Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          padding: EdgeInsets.only(left: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Image.asset(
                                        AssetsPath.location,
                                        height: 4.h,
                                        width: 4.w,
                                      ),
                                      Container(
                                          width: 1,
                                          height: 3.h,
                                          color: Color(0xffEADB57)),
                                      SizedBox(height: 3),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: colorScheme.primary,
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 7),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 3, right: 3),
                                          child: TextField(
                                            cursorHeight: 23,
                                            cursorColor: colorScheme.primary,
                                            onTap: () {},
                                            controller: controller
                                                .whereToAriveEdtingController,
                                            readOnly: true,
                                            onSubmitted: (v) {},
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: "SF-Pro Display"),
                                            onChanged: (text) {},
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.only(bottom: 8.0),
                                              suffixIconConstraints:
                                                  BoxConstraints(
                                                maxWidth: 30,
                                                maxHeight: 30,
                                              ),
                                              labelStyle: TextStyle(
                                                  color: colorScheme
                                                      .secondaryContainer,
                                                  fontSize: 12,
                                                  fontFamily: "SF-Pro Display"),
                                              isDense: true,
                                              border: InputBorder.none,
                                              labelText: language.whereToArrive,
                                              focusedBorder: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: !controller
                                                      .isBottomSheetExpanded
                                                  ? 0
                                                  : 0),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 0.5,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 3, right: 3),
                                          child: TextField(
                                            cursorHeight: 23,
                                            onSubmitted: (v) {},
                                            onTap: () {},
                                            onChanged: (text) {},
                                            readOnly: true,
                                            controller:
                                                controller.wheretoGoController,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: "SF-Pro Display"),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.only(bottom: 12.0),
                                              suffixIconConstraints:
                                                  BoxConstraints(
                                                maxWidth: 30,
                                                maxHeight: 30,
                                              ),
                                              border: InputBorder.none,
                                              labelText: language.whereToGo,
                                              labelStyle: TextStyle(
                                                  color: colorScheme
                                                      .secondaryContainer,
                                                  fontSize: 12,
                                                  fontFamily: "SF-Pro Display"),
                                              focusedBorder: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 20,
                  ),
                ]),
          ),
        );
      },
    );
  }

  tariffIconExists(context, index) async {
    try {
      final bundle = DefaultAssetBundle.of(context);
      await bundle.load("assets/tariffs/${controller.tariffs[index].code}.svg");
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
