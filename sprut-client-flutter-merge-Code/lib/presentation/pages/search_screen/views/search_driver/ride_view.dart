import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../resources/app_themes/app_themes.dart';
import '../../../../../resources/assets_path/assets_path.dart';
import '../../controllers/search_controller.dart';

class RideView extends GetView<SearchController> {
  const RideView({Key? key}) : super(key: key);

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
                        Text(
                          language.in_ride,
                          style: textTheme.bodyText1!.copyWith(
                            fontSize: 14.sp,
                            color: AppThemes.darkGrey,
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(8.0),
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
                                    padding:
                                        EdgeInsets.only(left: 4.0, right: 4.0),
                                    color: AppThemes.primary,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${controller.orderModel.car?.rating}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.bodyText1!.copyWith(
                                              fontSize: 10.sp,
                                              color: Colors.white),
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
                              SizedBox(
                                width: 8.0,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${controller.orderModel.car?.licensePlateNumber}",
                                      style: textTheme.bodyText1!.copyWith(
                                          fontSize: 13.sp,
                                          color: AppThemes.primary),
                                    ),
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    Text(
                                      "${controller.orderModel.car?.colorRaw} ${controller.orderModel.car?.makeRaw} ${controller.orderModel.car?.modelRaw} • ${controller.orderModel.rate?.name!}",
                                      style: textTheme.bodyText1!.copyWith(
                                          fontSize: 10.sp,
                                          color: AppThemes.lightGrey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(language.for_payment,style: textTheme.bodyText1!.copyWith(fontSize: 11.sp,color: AppThemes.darkGrey,),
                            ),
                            Expanded(
                              child: Text(
                                '${((controller.orderModel.summary?.tripCost)! / 100).toStringAsFixed(2)}\₴',
                                textAlign: TextAlign.right,
                                style: textTheme.bodyText1!.copyWith(
                                  fontSize: 11.sp,
                                  color: AppThemes.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        Divider(),
                        const SizedBox(
                          height: 4.0,
                        ),
                        // Obx(
                        //   () {
                        //     return Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //         Text(
                        //           language.ride_time,
                        //           style: textTheme.bodyText1!.copyWith(
                        //             fontSize: 11.sp,
                        //             color: AppThemes.darkGrey,
                        //           ),
                        //         ),
                        //         Expanded(
                        //           child: Text(
                        //             '${controller.orderRideTime}',
                        //             textAlign: TextAlign.right,
                        //             style: textTheme.bodyText1!.copyWith(
                        //               fontSize: 11.sp,
                        //               color: AppThemes.primary,
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     );
                        //   },
                        // ),
                        // const SizedBox(
                        //   height: 4.0,
                        // ),
                        // Divider(),
                        // const SizedBox(
                        //   height: 4.0,
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              language.route_length,
                              style: textTheme.bodyText1!.copyWith(
                                fontSize: 11.sp,
                                color: AppThemes.darkGrey,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${((controller.orderModel.summary?.distanceTravelled)! / 1000).toStringAsFixed(2)} ' +
                                    language.route_unit,
                                textAlign: TextAlign.right,
                                style: textTheme.bodyText1!.copyWith(
                                  fontSize: 11.sp,
                                  color: AppThemes.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12,
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
                                              left: !controller.isBottomSheetExpanded
                                                  ? 0
                                                  : 0),
                                          width: MediaQuery.of(context).size.width,
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
                    height: 36,
                  ),
                ]),
          ),
        );
      },
    );
  }
}
