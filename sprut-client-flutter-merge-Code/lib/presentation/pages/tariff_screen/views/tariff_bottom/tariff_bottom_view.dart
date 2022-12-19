import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../resources/app_constants/app_constants.dart';
import '../../../../../resources/app_themes/app_themes.dart';
import '../../../../../resources/assets_path/assets_path.dart';
import '../../../../widgets/primary_elevated_btn/primary_elevated_btn.dart';
import '../../controllers/tariff_controller.dart';
import '../comment/comment_view.dart';
import '../payment/tariff_payment_view.dart';
import '../preorder/preorder_view.dart';
import '../service/service_view.dart';
import '../tariff_description/tariff_description.dart';

class TariffBottomView extends GetView<TariffController> {
  const TariffBottomView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;
    return GetBuilder<TariffController>(
      initState: (_) {},
      builder: (_) {
        return Scaffold(
          body: SafeArea(
            top: false,
            bottom: false,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  controller.isBottomSheetExpanded == false
                      ? Center(
                          child: Container(
                              width: 14.w,
                              height: 5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: controller.isBottomSheetExpanded
                                    ? colorScheme.primary
                                    : Color(0xffC4C4C4),
                              )),
                        )
                      : Center(
                          child: Container(
                              width: 14.w,
                              height: 5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: controller.isBottomSheetExpanded
                                    ? colorScheme.primary
                                    : Color(0xffC4C4C4),
                              )),
                        ),
                  if (controller.isBottomSheetExpanded == false)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          language.startSearchCar,
                          textAlign: TextAlign.center,
                          style: textTheme.bodyText1!
                              .copyWith(fontSize: 9.sp, color: AppThemes.dark),
                        ),
                      ),
                    ),
                  if (controller.isBottomSheetExpanded)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ...[
                            Text(
                              language.popular,
                              style: textTheme.bodyText1!.copyWith(
                                  fontSize: 13.sp, color: AppThemes.dark),
                            ),
                            if (controller.isBottomSheetExpanded)
                              SizedBox(height: 5),
                            if (controller.isBottomSheetExpanded)
                              Text(
                                language.withRate,
                                style: textTheme.bodyText1!.copyWith(
                                    fontSize: 9.sp,
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold),
                              ),
                          ]
                        ],
                      ),
                    ),
                  GestureDetector(
                    onVerticalDragUpdate: (v) {},
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // AnimatedContainer(
                          //   curve: Curves.bounceIn,
                          //   duration: Duration(milliseconds: 0),
                          Container(
                            alignment: Alignment.topCenter,
                            // color: Colors.blue,
                            padding: EdgeInsets.all(8),
                            height: controller.isBottomSheetExpanded
                                ? size.height * 0.570
                                : size.height * 0.18,
                            child: ListView.builder(
                              physics: controller.isBottomSheetExpanded
                                  ? ScrollPhysics()
                                  : NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.all(0.0),
                              itemCount: controller.isBottomSheetExpanded
                                  ? controller.tariffs.length
                                  : controller.tariffs.isNotEmpty
                                      ? 2
                                      : 0,
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
                                      border: controller.selectedIndex == index
                                          ? Border.all(
                                              color: colorScheme.primary,
                                              width: 1.5)
                                          : Border.all(
                                              color: Colors.transparent,
                                              width: 0),
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
                                          child: FadeInImage(
                                            placeholder: AssetImage(
                                                'assets/tariffs/standart.png'),
                                            image: AssetImage(
                                                'assets/tariffs/${controller.tariffs[index].code}.png'),
                                            imageErrorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                  'assets/tariffs/standart.png');
                                            },
                                          ),

                                          // Image.asset(
                                          //   controller.getIconExist(
                                          //       controller.tariffs[index].code),
                                          // ),
                                          // child: SvgPicture.asset(
                                          //   controller.getIconExist(
                                          //       controller.tariffs[index].code),
                                          // ),
                                          // FutureBuilder(
                                          //   future: tariffIconExists(context, index),
                                          //   builder: (BuildContext context,
                                          //       AsyncSnapshot snapshot) {
                                          //     if (snapshot.hasData) {
                                          //       print(controller.tariffs[index].code);
                                          //       if (snapshot.data == true) {
                                          //         return SvgPicture.asset(
                                          //           'assets/tariffs/${controller.tariffs[index].code}.svg',
                                          //         );
                                          //         // return Image.asset(
                                          //         //   "assets/icons/options_${tariffs[index].code}.png",
                                          //         //   fit: BoxFit.contain,
                                          //         // );
                                          //       } else {
                                          //         return SvgPicture.asset(
                                          //           'assets/tariffs/standart.svg',
                                          //         );
                                          //         // return Image.asset(
                                          //         //   "assets/icons/options_standart.png",
                                          //         //   fit: BoxFit.contain,
                                          //         // );
                                          //       }
                                          //     } else {
                                          //       return SvgPicture.asset(
                                          //         'assets/tariffs/standart.svg',
                                          //       );
                                          //     }
                                          //   },
                                          // ),
                                        ),
                                        SizedBox(width: 10),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.465,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        child: Text(
                                                            controller
                                                                .tariffs[index]
                                                                .name!,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    AppConstants
                                                                        .fontFamily,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    10.sp)),
                                                      ),
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
                                                                  BorderRadius
                                                                      .circular(
                                                                          14)),
                                                          context: context,
                                                          builder: (context) =>
                                                              SafeArea(
                                                            child:
                                                                TariffDescription(
                                                              carPath:
                                                                  'assets/tariffs/${controller.tariffs[index].code}.svg',
                                                              downTime: (controller
                                                                              .tariffs[index]
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
                                                                              .tariffs[index]
                                                                              .prices!
                                                                              .minimum! /
                                                                          100)
                                                                      .toInt()
                                                                      .toString() +
                                                                  ' ₴',
                                                              numberOfSheet: controller
                                                                      .tariffs[
                                                                          index]
                                                                      .numberOfSeats ??
                                                                  "",
                                                              priceForkm: (controller
                                                                              .tariffs[index]
                                                                              .prices!
                                                                              .moving! /
                                                                          100)
                                                                      .toInt()
                                                                      .toString() +
                                                                  " " +
                                                                  ' ₴',
                                                              carName:
                                                                  controller
                                                                      .tariffs[
                                                                          index]
                                                                      .name!,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: SvgPicture.asset(
                                                        AssetsPath.infoIcon,
                                                        height: 3.w,
                                                        color: Colors.black,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Expanded(
                                                child: Container(
                                                  // width: size.width * 0.42,
                                                  child: Text(
                                                      language.minOrderAmount,
                                                      style: textTheme
                                                          .bodyText1!
                                                          .copyWith(
                                                              fontSize: 8.sp,
                                                              color: colorScheme
                                                                  .primary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: size.width * 0.20,
                                          alignment: Alignment.centerRight,
                                          // color: Colors.blue,
                                          child: Text(
                                            (controller.tariffs[index].prices!
                                                            .minimum! /
                                                        100)
                                                    .toInt()
                                                    .toString() +
                                                '₴',
                                            style: textTheme.bodyText1!
                                                .copyWith(
                                                    fontSize: 14.sp,
                                                    color: AppThemes.dark),
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.all(20.0),
                                        //   child: Align(
                                        //     alignment: Alignment.center,
                                        //     child: ElevatedButton(
                                        //       onPressed: () {
                                        //         Navigator.of(context).pop();
                                        //       },
                                        //       child: Text(
                                        //         "OK",
                                        //         style: TextStyle(
                                        //             color: AppThemes.colorWhite,
                                        //             fontSize: 12.sp,
                                        //             fontFamily: AppConstants.fontFamily,
                                        //             fontWeight: FontWeight.w400),
                                        //       ),
                                        //       style: ButtonStyle(
                                        //         minimumSize: MaterialStateProperty.all(Size(107.0, 6.h)),
                                        //         elevation: MaterialStateProperty.all(0),
                                        //         backgroundColor:
                                        //         MaterialStateProperty.all(colorScheme.primary),
                                        //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        //           RoundedRectangleBorder(
                                        //             borderRadius: BorderRadius.circular(8.0),
                                        //             side: BorderSide(
                                        //                 color: AppThemes.darkGrey.withOpacity(0.3)),
                                        //           ),
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          if (controller.isBottomSheetExpanded)
                            SizedBox(
                              height: 20,
                            ),
                          Container(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    showCupertinoModalBottomSheet(
                                      expand: false,
                                      enableDrag: true,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14)),
                                      context: context,
                                      builder: (context) => SafeArea(
                                        child: TariffPaymentView(),
                                      ),
                                    );
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
                                            child: SvgPicture.asset(
                                                AssetsPath.payments),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Text(
                                            controller.paymentType.isNotEmpty
                                                ? (controller.paymentType ==
                                                        controller.balanceTitle
                                                    ? language.balance
                                                    : (controller.paymentType ==
                                                            controller.cashTitle
                                                        ? language.cash
                                                        : (controller
                                                                    .paymentType ==
                                                                controller
                                                                    .cardTitle
                                                            ? language.card
                                                            : language
                                                                .payment)))
                                                : language.payment,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    showCupertinoModalBottomSheet(
                                      expand: false,
                                      enableDrag: true,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14)),
                                      context: context,
                                      builder: (context) => SafeArea(
                                        child: ServiceView(),
                                      ),
                                    );
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
                                        if (controller.service.isNotEmpty)
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Icon(
                                              Icons.check_circle,
                                              color: Colors.green[800],
                                            ),
                                          ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            height: 4.h,
                                            child: SvgPicture.asset(
                                                AssetsPath.menuDots),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Text(
                                            language.services,
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    showCupertinoModalBottomSheet(
                                      expand: false,
                                      enableDrag: true,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14)),
                                      context: context,
                                      builder: (context) => SafeArea(
                                        child: CommentView(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 8.h,
                                    padding: EdgeInsets.only(left: 15),
                                    width: size.width * 0.56,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 4.h,
                                          child: SvgPicture.asset(
                                              AssetsPath.comments),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                            child: Text(
                                                controller
                                                        .commentController.text
                                                        .toString()
                                                        .trim()
                                                        .isEmpty
                                                    ? language.comments
                                                    : controller
                                                        .commentController.text
                                                        .toString()
                                                        .trim(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: textTheme.bodyText1!
                                                    .copyWith(
                                                        fontSize: 9.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors
                                                            .grey.shade400)))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Container(
                            // margin: EdgeInsets.only(bottom: 10),
                            padding:
                                EdgeInsets.only(left: 8, right: 8, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: PrimaryElevatedBtn(
                                        buttonText: language.findACar,
                                        onPressed: () {
                                          controller.createOrder(context);
                                          controller.update();
                                        })),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    showCupertinoModalBottomSheet(
                                      expand: false,
                                      enableDrag: true,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14)),
                                      context: context,
                                      builder: (context) => Wrap(
                                        children: <Widget>[
                                          SafeArea(
                                            child: PreOrderView(),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 8.h,
                                    width: 17.w,
                                    padding: EdgeInsets.all(5),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        if (controller.preOrder)
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Icon(
                                              Icons.check_circle,
                                              color: Colors.green[800],
                                            ),
                                          ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 18,
                                                child: SvgPicture.asset(
                                                    AssetsPath.preOrder),
                                              ),
                                              Text(
                                                language.preOrder,
                                                style: TextStyle(
                                                  color: Colors.grey.shade400,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 36,
                          ),
                        ],
                      ),
                    ),
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
