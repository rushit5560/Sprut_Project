import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../resources/app_constants/app_constants.dart';
import '../../../../../resources/app_themes/app_themes.dart';
import '../../../../../resources/assets_path/assets_path.dart';
import '../../../../widgets/primary_elevated_btn/primary_elevated_btn.dart';
import '../../controllers/search_controller.dart';

class RatingView extends GetView<SearchController> {
  const RatingView({Key? key}) : super(key: key);

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
              mainAxisAlignment: MainAxisAlignment.center,
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
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              language.how_was_trip,
                              textAlign: TextAlign.center,
                              style: textTheme.bodyText1!.copyWith(
                                fontSize: 14.sp,
                                color: AppThemes.darkGrey,
                              ),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Divider(),
                            const SizedBox(
                              height: 4.0,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${controller.orderModel.car?.driverName}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: textTheme.bodyText1!.copyWith(
                                            fontSize: 13.sp,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 2.0,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 2.0),
                                        padding: EdgeInsets.only(
                                            left: 4.0, right: 4.0),
                                        color: AppThemes.primary,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${controller.orderModel.car?.rating}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: textTheme.bodyText1!
                                                  .copyWith(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          language.your_trip_was,
                                          style: textTheme.bodyText1!.copyWith(
                                              fontSize: 10.sp,
                                              color: AppThemes.lightGrey),
                                        ),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        Text(
                                          '${((controller.orderModel.summary?.tripCost)! / 100).toStringAsFixed(2)}\₴',
                                          style: textTheme.bodyText1!.copyWith(
                                              fontSize: 13.sp,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Divider(),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Obx(
                              () {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {
                                          controller.addOrderRating(1);
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              controller.orderRating > 0
                                                  ? AssetsPath.starSelect
                                                  : AssetsPath.starUnselect,
                                              height: 3.0.h,
                                            ),
                                            Text(
                                              language.too_bad,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: textTheme.bodyText1!
                                                  .copyWith(
                                                      fontSize: 8.sp,
                                                      color: controller
                                                                  .orderRating >
                                                              0
                                                          ? Colors.black
                                                          : AppThemes
                                                              .lightGrey),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {
                                          controller.addOrderRating(2);
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              controller.orderRating > 1
                                                  ? AssetsPath.starSelect
                                                  : AssetsPath.starUnselect,
                                              height: 3.0.h,
                                            ),
                                            Text(
                                              language.bad,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: textTheme.bodyText1!
                                                  .copyWith(
                                                      fontSize: 8.sp,
                                                      color: controller
                                                                  .orderRating >
                                                              1
                                                          ? Colors.black
                                                          : AppThemes
                                                              .lightGrey),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {
                                          controller.addOrderRating(3);
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              controller.orderRating > 2
                                                  ? AssetsPath.starSelect
                                                  : AssetsPath.starUnselect,
                                              height: 3.0.h,
                                            ),
                                            Text(
                                              language.medium,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: textTheme.bodyText1!
                                                  .copyWith(
                                                      fontSize: 8.sp,
                                                      color: controller
                                                                  .orderRating >
                                                              2
                                                          ? Colors.black
                                                          : AppThemes
                                                              .lightGrey),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {
                                          controller.addOrderRating(4);
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              controller.orderRating > 3
                                                  ? AssetsPath.starSelect
                                                  : AssetsPath.starUnselect,
                                              height: 3.0.h,
                                            ),
                                            Text(
                                              language.good,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: textTheme.bodyText1!
                                                  .copyWith(
                                                      fontSize: 8.sp,
                                                      color: controller
                                                                  .orderRating >
                                                              3
                                                          ? Colors.black
                                                          : AppThemes
                                                              .lightGrey),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {
                                          controller.addOrderRating(5);
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              controller.orderRating > 4
                                                  ? AssetsPath.starSelect
                                                  : AssetsPath.starUnselect,
                                              height: 3.0.h,
                                            ),
                                            Text(
                                              language.excellent,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: textTheme.bodyText1!
                                                  .copyWith(
                                                      fontSize: 8.sp,
                                                      color: controller
                                                                  .orderRating >
                                                              4
                                                          ? Colors.black
                                                          : AppThemes
                                                              .lightGrey),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      if (controller.orderRating > 0 &&
                          controller.orderRating <= 3 &&
                          controller.isBottomSheetExpanded)
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.only(
                            top: 8.0,
                            bottom: 8.0,
                            left: 16.0,
                            right: 16.0,
                          ),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(7),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                language.what_didnt_like,
                                textAlign: TextAlign.left,
                                style: textTheme.bodyText1!.copyWith(
                                  fontSize: 12.sp,
                                  color: AppThemes.dark,
                                ),
                              ),
                              const SizedBox(
                                height: 2.0,
                              ),
                              Text(
                                language.select_problem,
                                textAlign: TextAlign.left,
                                style: textTheme.bodyText1!.copyWith(
                                    fontSize: 10.sp,
                                    color: AppThemes.lightGrey),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (controller.getProblemExist(0)) {
                                    controller.problemRemove = 0;
                                  } else {
                                    controller.problem = 0;
                                  }
                                  controller.update();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 44,
                                  padding: EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(7),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          language.traffic_offence,
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.bodyText1!.copyWith(
                                              fontSize: 11.sp,
                                              color: AppThemes.dark),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Container(
                                        height: 2.5.h,
                                        width: 8.w,
                                        child: SvgPicture.asset(
                                          controller.getProblemExist(0)
                                              ? "assets/services/checkbox_selected.svg"
                                              : "assets/services/checkbox_unselected.svg",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 1.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (controller.getProblemExist(1)) {
                                    controller.problemRemove = 1;
                                  } else {
                                    controller.problem = 1;
                                  }
                                  controller.update();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 44,
                                  padding: EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(7),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          language.dirty_salon,
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.bodyText1!.copyWith(
                                              fontSize: 11.sp,
                                              color: AppThemes.dark),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Container(
                                        height: 2.5.h,
                                        width: 8.w,
                                        child: SvgPicture.asset(
                                          controller.getProblemExist(1)
                                              ? "assets/services/checkbox_selected.svg"
                                              : "assets/services/checkbox_unselected.svg",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 1.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (controller.getProblemExist(2)) {
                                    controller.problemRemove = 2;
                                  } else {
                                    controller.problem = 2;
                                  }
                                  controller.update();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 44,
                                  padding: EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(7),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          language.ruffled_driver,
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.bodyText1!.copyWith(
                                              fontSize: 11.sp,
                                              color: AppThemes.dark),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Container(
                                        height: 2.5.h,
                                        width: 8.w,
                                        child: SvgPicture.asset(
                                          controller.getProblemExist(2)
                                              ? "assets/services/checkbox_selected.svg"
                                              : "assets/services/checkbox_unselected.svg",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 4.0,
                              ),
                            ],
                          ),
                        ),
                      if (controller.orderRating > 0 &&
                          controller.orderRating <= 3 &&
                          controller.isBottomSheetExpanded)
                        Container(
                          margin: const EdgeInsets.only(
                              left: 24.0, top: 8.0, bottom: 8.0, right: 8.0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            language.write_personal_comment,
                            textAlign: TextAlign.left,
                            style: textTheme.bodyText1!.copyWith(
                              fontSize: 12.sp,
                              color: AppThemes.dark,
                            ),
                          ),
                        ),
                      if (controller.orderRating > 0 &&
                          controller.orderRating <= 3 &&
                          controller.isBottomSheetExpanded)
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.only(
                            top: 8.0,
                            bottom: 16.0,
                            left: 16.0,
                            right: 16.0,
                          ),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(7),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 3.h,
                                width: 7.w,
                                child: SvgPicture.asset(AssetsPath.comments),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: controller.commentController,
                                  focusNode: controller.commentFocusNode,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "SF-Pro Display",
                                  ),
                                  textInputAction: TextInputAction.done,
                                  maxLength: 100,
                                  onChanged: (value) {
                                    controller.personalComment = value;
                                    controller.update();
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        left: 4.0,
                                        right: 4.0,
                                        bottom: 4.0,
                                        top: 8.0),
                                    border: InputBorder.none,
                                    labelText: language.personal_comment_hint,
                                    labelStyle: TextStyle(
                                      color: colorScheme.secondaryContainer,
                                      fontSize: 12,
                                      fontFamily: "SF-Pro Display",
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppThemes.lightGrey),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppThemes.lightGrey),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (controller.orderRating > 3 &&
                          controller.isBottomSheetExpanded)
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                language.tip_for_the_driver,
                                textAlign: TextAlign.left,
                                style: textTheme.bodyText1!.copyWith(
                                  fontSize: 11.sp,
                                  color: AppThemes.dark,
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        controller.paymentTip = "";
                                        controller.update();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(4.0),
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: controller.paymentTip == ""
                                              ? colorScheme.primary
                                              : Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            bottomLeft: Radius.circular(4.0),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          language.no,
                                          textAlign: TextAlign.center,
                                          style: textTheme.bodyText1!.copyWith(
                                            fontSize: 10.sp,
                                            color: controller.paymentTip == ""
                                                ? Colors.white
                                                : AppThemes.dark,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        controller.paymentTip = "10";
                                        controller.update();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(4.0),
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: controller.paymentTip == "10"
                                              ? colorScheme.primary
                                              : Colors.white,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "10\₴",
                                          textAlign: TextAlign.center,
                                          style: textTheme.bodyText1!.copyWith(
                                            fontSize: 10.sp,
                                            color: controller.paymentTip == "10"
                                                ? Colors.white
                                                : AppThemes.dark,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        controller.paymentTip = "20";
                                        controller.update();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(4.0),
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: controller.paymentTip == "20"
                                              ? colorScheme.primary
                                              : Colors.white,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "20\₴",
                                          textAlign: TextAlign.center,
                                          style: textTheme.bodyText1!.copyWith(
                                            fontSize: 10.sp,
                                            color: controller.paymentTip == "20"
                                                ? Colors.white
                                                : AppThemes.dark,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        controller.paymentTip = "other";
                                        controller.update();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(4.0),
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color:
                                              controller.paymentTip == "other"
                                                  ? colorScheme.primary
                                                  : Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(4.0),
                                            bottomRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          language.other_amount,
                                          textAlign: TextAlign.center,
                                          style: textTheme.bodyText1!.copyWith(
                                            fontSize: 10.sp,
                                            color:
                                                controller.paymentTip == "other"
                                                    ? Colors.white
                                                    : AppThemes.dark,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              // if (controller.paymentTip != "other")
                              //   const SizedBox(
                              //     height: 60.0,
                              //   ),
                              if (controller.paymentTip == "other")
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 0.0,
                                    right: 0.0,
                                    top: 8.0,
                                    bottom: 8.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            left: 0.0,
                                            right: 8.0,
                                          ),
                                          padding: const EdgeInsets.only(
                                            left: 6.0,
                                            right: 6.0,
                                          ),
                                          height: 60,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: colorScheme.primary),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(4.0),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/payments/currency.svg",
                                              ),
                                              const SizedBox(
                                                width: 12.0,
                                              ),
                                              Expanded(
                                                child: TextField(
                                                  controller: controller
                                                      .amountController,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily:
                                                          "SF-Pro Display"),
                                                  focusNode: controller
                                                      .amountFocusNode,
                                                  onChanged: (text) {
                                                    if (text.isEmpty) {
                                                      controller
                                                          .amountController
                                                          .text = "0.0";
                                                      controller
                                                              .amountController
                                                              .selection =
                                                          TextSelection.fromPosition(
                                                              TextPosition(
                                                                  offset: controller
                                                                      .amountController
                                                                      .text
                                                                      .length));
                                                    } else {
                                                      if (double.parse(text) >
                                                          double.parse(
                                                              controller
                                                                  .balance)) {
                                                        String newAmount =
                                                            "${controller.balance}";
                                                        controller
                                                            .amountController
                                                            .text = newAmount;

                                                        controller
                                                                .amountController
                                                                .selection =
                                                            TextSelection.fromPosition(
                                                                TextPosition(
                                                                    offset: newAmount
                                                                        .length));
                                                      } else {
                                                        if (text.startsWith(
                                                                "0") &&
                                                            text.length > 1) {
                                                          String newAmount =
                                                              text.substring(1);
                                                          controller
                                                              .amountController
                                                              .text = newAmount;

                                                          controller
                                                                  .amountController
                                                                  .selection =
                                                              TextSelection.fromPosition(
                                                                  TextPosition(
                                                                      offset: newAmount
                                                                          .length));
                                                        }
                                                      }
                                                    }
                                                  },
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  maxLines: 1,
                                                  maxLength: 4,
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  decoration: InputDecoration(
                                                    suffixIconConstraints:
                                                        BoxConstraints(
                                                      maxWidth: 30,
                                                      maxHeight: 30,
                                                    ),
                                                    counterText: "",
                                                    suffixIcon:
                                                        // controller
                                                        //         .amountFocusNode
                                                        //         .hasFocus
                                                        //     ?
                                                        GestureDetector(
                                                      onTap: () {
                                                        String newAmount = "0";
                                                        controller
                                                            .amountController
                                                            .text = newAmount;

                                                        controller
                                                                .amountController
                                                                .selection =
                                                            TextSelection.fromPosition(
                                                                TextPosition(
                                                                    offset: newAmount
                                                                        .length));
                                                        controller.update();
                                                      },
                                                      child: Container(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        width: 30,
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.grey,
                                                          size: 3.h,
                                                        ),
                                                      ),
                                                    ),
                                                    // : null,
                                                    labelStyle: TextStyle(
                                                        color: colorScheme
                                                            .secondaryContainer,
                                                        fontSize: 18,
                                                        fontFamily:
                                                            "SF-Pro Display"),
                                                    isDense: true,
                                                    border: InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8.0,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            controller.updateAmountController(
                                                "subtract");
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(4.0),
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: colorScheme.primary,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                bottomLeft:
                                                    Radius.circular(4.0),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.remove,
                                              color: Colors.white,
                                              size: 7.w,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 1.0,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            controller
                                                .updateAmountController("add");
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(4.0),
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: colorScheme.primary,
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(4.0),
                                                bottomRight:
                                                    Radius.circular(4.0),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 7.w,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 2.5.h,
                                      width: 7.w,
                                      child: SvgPicture.asset(
                                        "assets/payments/balance.svg",
                                        alignment: Alignment.centerLeft,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      language.balance,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: AppConstants.fontFamily,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 10.sp),
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "(${controller.balance} \₴)",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: colorScheme.primary,
                                            fontFamily: AppConstants.fontFamily,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 10.sp),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                  ],
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
                        Container(
                          margin: EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                            top: 0.0,
                            bottom: 0.0,
                          ),
                          child: PrimaryElevatedBtn(
                            buttonText: language.done,
                            onPressed: () {
                              controller.rateOrder(context);
                            },
                          ),
                        ),
                      SizedBox(
                        height: 36,
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
  }
}
