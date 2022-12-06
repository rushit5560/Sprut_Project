import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/resources/app_themes/app_themes.dart';
import 'package:sprut/resources/configs/helpers/helpers.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprut/presentation/pages/order_screen/controllers/order_controller.dart';

import '../../../../../resources/app_constants/app_constants.dart';
import '../../../../../resources/assets_path/assets_path.dart';
import '../../../../../resources/configs/helpers/helpers.dart';
import '../../../../widgets/cash_back_dialog/cash_back_dialog.dart';
import '../../../../widgets/custom_dialog/widget_dialog.dart';
import '../../../../widgets/primary_elevated_btn/primary_elevated_btn.dart';
import '../../controllers/order_controller.dart';

class OrderCompletedDetailView extends GetView<OrderController> {
  final orderID;
  final fromView;

  OrderCompletedDetailView(this.orderID, this.fromView);

  @override
  Widget build(BuildContext context) {
    Helpers.systemStatusBar1();

    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return GetBuilder<OrderController>(
      initState: (_) {
        controller.optionYesOrNo = "";
        controller.selectedIndex = 1;
        controller.getOrderInfoInitCall(context, orderID.toString());
      },
      builder: (_) {
        if (controller.isLoading == true) {
          return Center(
            child: SizedBox(
              child: Lottie.asset('assets/images/loading1.json'),
              height: 100,
              width: 95,
            ),
          );
        } else {
          return Container(
            color: Colors.black,
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Text(
                  "${controller.orderInfoDetails.value?.establishment?.name.toString()}",
                  style: textTheme.bodyText1!.copyWith(
                    fontSize: 18.sp,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      //${language.order}: ${controller.orderInfoDetails.value?.orderId} /
                      TextSpan(
                        text: controller.orderInfoDetails.value?.createdAt == null ? "" : '${Helpers.orderCreatedDate(context, controller.orderInfoDetails.value?.createdAt,language.today_at)} /',
                        style: textTheme.bodyText2!.copyWith(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w400,
                            color: AppThemes.offWhiteColor,
                            decoration: TextDecoration.none),
                      ),
                      TextSpan(
                        text: " ${Helpers.getOrderStatusByDeliveryStatus(context, '${controller.orderInfoDetails.value?.status}', language)}",
                        style: textTheme.bodyText2!.copyWith(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w400,
                            color: controller.orderCurrentStatus ==
                                    "Order cancelled"
                                ? Colors.yellow
                                : AppThemes.orderCompletedStatusColor,
                            decoration: TextDecoration.none),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Divider(
                  color: AppThemes.lightLineColor2,
                  thickness: 0.5,
                  height: 0.5,
                  endIndent: 25,
                  indent: 25,
                ),
                SizedBox(height: 8),
                Expanded(
                    child: SingleChildScrollView(
                      controller: controller.scrollViewController,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          if (fromView.toString() == "orderCompleted") ...[
                            //&& controller.orderCurrentStatus != "Order delivered"
                            _buildCommentView(context),
                          ],
                          if(controller.orderCurrentStatus != "Order cancelled")...[
                            _buildDriverView(context),
                            // _buildRateView(context),
                          ],
                          _buildOrder(context),
                          _buildDeliveryInformation(context),
                          _buildInformation(context)
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: PrimaryElevatedBtn(
                          buttonText:
                          fromView == "orderCompleted"
                                  ? language.button_close
                                  : language.txt_back,
                          onPressed: () {

                            if(fromView == "orderCompleted"){
                              if(controller.comment.isEmpty){
                                controller.emptyOption = "show";
                                controller.update();
                                controller.scrollViewController.jumpTo(0);
                              }else {
                                controller.emptyOption = "";
                                controller.update();
                                bool isValue = false;
                                if(controller.comment == "yes"){
                                  isValue = true;
                                }
                                controller.feedbackOrder(context, isValue);
                              }
                            }else {
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                )),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildDeliveryInformation(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Align(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                language.delivery_information,
                style: textTheme.bodyText1!.copyWith(
                    fontSize: 11.sp, color: Colors.white),
              ),
            ),
            alignment: Alignment.centerLeft),
        Container(
          margin: EdgeInsets.all(8),
          width: double.infinity,
          padding: EdgeInsets.only(left: 16, right: 0, bottom: 8, top: 8),
          child: Row(
            children: [
              Column(
                children: [
                  Image.asset(
                    AssetsPath.home,
                    height: 4.h,
                    width: 4.w,
                  ),
                  Container(width: 1, height: 3.h, color: Color(0xffEADB57)),
                  SizedBox(height: 3),
                  Image.asset(
                    AssetsPath.location,
                    height: 4.h,
                    width: 4.w,
                    color: Colors.white,
                  ),
                ],
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${language.delivery_from}",
                      style: textTheme.bodySmall!
                          .copyWith(fontSize: 9.sp, color: Color(0xffAAAAAA)),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      controller.getEstablishmentAddress(),
                      style: textTheme.bodyText1!.copyWith(
                        fontSize: 11.sp,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 8),
                    Container(
                        width: double.infinity,
                        height: 1,
                        color: Helpers.primaryLineColor()),
                    SizedBox(height: 8),
                    Text(
                      "${language.where_to_deliver}",
                      style: textTheme.bodySmall!
                          .copyWith(fontSize: 9.sp, color: Color(0xffAAAAAA)),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      controller.getDeliveryAddress(),
                      style: textTheme.bodyText1!.copyWith(
                        fontSize: 11.sp,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Helpers.primaryLineColor())),
        ),
      ],
    );
  }

  Widget _buildDriverView(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.all(8),
      width: double.infinity,
      padding: EdgeInsets.only(right: 0, bottom: 8, top: 8),
      child: Row(
        children: [
          ClipRRect(
            child: Image.network(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRwsCcItkbcOT4I3iQ40pAytBCecmH7Zw2NvZ-jHf_fRSr_G6NafXdXzBHoSF0saXKmDps&amp;usqp=CAU',
              width: 65,
              height: 65,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(32)),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${controller.orderInfoDetails.value?.car?.driverName}",
                  style: textTheme.bodyText1!.copyWith(
                    fontSize: 18.sp,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 4),
                Text(
                  "${controller.orderInfoDetails.value?.car?.licensePlateNumber}",
                  style: textTheme.bodySmall!
                      .copyWith(fontSize: 9.sp, color: Color(0xffAAAAAA)),
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${language.total}",
                    style: textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 8.sp,
                        color: Helpers.subtitleTextColor()),
                    textAlign: TextAlign.end,
                  ),
                  Text(
                    // "${controller.getCartItemTotalAmount(controller.orderInfoDetails.value?.products)} ${language.currency_symbol}",
                    "${controller.getCartItemFinalWithDiscountAndWithoutDiscountTotalAmount(controller.orderInfoDetails.value?.products)} ${language.currency_symbol}",
                    style: textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: Colors.white),
                    textAlign: TextAlign.end,
                  )
                ],
              ),
              padding: EdgeInsets.all(8.0),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRateView(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.all(8),
      width: double.infinity,
      padding: EdgeInsets.only(right: 0, bottom: 8, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () async {
              print("Click star 1");
              if (fromView == "orderCompleted") {
                controller.updateRatingIndex(1);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    height: 22,
                    width: 22,
                    margin: EdgeInsets.only(left: 4.0),
                    child: SvgPicture.asset(
                      controller.selectedIndex > 0
                          ? AssetsPath.selectedStar
                          : AssetsPath.unSelectedStar,
                    )),
                Align(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "${language.to_bad}",
                        style: textTheme.bodyText1!.copyWith(
                            fontSize: 8.sp,
                            color: AppThemes.offWhiteColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    alignment: Alignment.center),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              print("Click star 2");
              if (fromView == "orderCompleted") {
                controller.updateRatingIndex(2);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    height: 22,
                    width: 22,
                    margin: EdgeInsets.only(left: 4.0),
                    child: SvgPicture.asset(
                      controller.selectedIndex > 1
                          ? AssetsPath.selectedStar
                          : AssetsPath.unSelectedStar,
                    )),
                Align(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "${language.bad}",
                        style: textTheme.bodyText1!.copyWith(
                            fontSize: 8.sp,
                            color: AppThemes.offWhiteColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    alignment: Alignment.center),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              print("Click star 3");
              if (fromView == "orderCompleted") {
                controller.updateRatingIndex(3);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    height: 22,
                    width: 22,
                    margin: EdgeInsets.only(left: 4.0),
                    child: SvgPicture.asset(
                      controller.selectedIndex > 2
                          ? AssetsPath.selectedStar
                          : AssetsPath.unSelectedStar,
                    )),
                Align(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "${language.to_medium}",
                        style: textTheme.bodyText1!.copyWith(
                            fontSize: 8.sp,
                            color: AppThemes.offWhiteColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    alignment: Alignment.center),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              print("Click star 4");
              if (fromView == "orderCompleted") {
                controller.updateRatingIndex(4);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    height: 22,
                    width: 22,
                    margin: EdgeInsets.only(left: 4.0),
                    child: SvgPicture.asset(
                      controller.selectedIndex > 3
                          ? AssetsPath.selectedStar
                          : AssetsPath.unSelectedStar,
                    )),
                Align(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "${language.to_good}",
                        style: textTheme.bodyText1!.copyWith(
                            fontSize: 8.sp,
                            color: AppThemes.offWhiteColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    alignment: Alignment.center),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              print("Click star");
              if (fromView == "orderCompleted") {
                controller.updateRatingIndex(5);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    height: 22,
                    width: 22,
                    margin: EdgeInsets.only(left: 4.0),
                    child: SvgPicture.asset(
                      controller.selectedIndex > 4
                          ? AssetsPath.selectedStar
                          : AssetsPath.unSelectedStar,
                    )),
                Align(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "${language.to_excellent}",
                        style: textTheme.bodyText1!.copyWith(
                            fontSize: 8.sp,
                            color: AppThemes.offWhiteColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    alignment: Alignment.center),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentView(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Align(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                language.delivery_completed_comment_alert_message,
                style: textTheme.bodyText1!.copyWith(
                    fontSize: 12.sp, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            alignment: Alignment.center),
        if(controller.emptyOption == "show")...[
          Align(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  language.please_select_one_option,
                  style: textTheme.bodyText1!
                      .copyWith(fontSize: 12.sp, color: Color(0xffD60F28)),
                  textAlign: TextAlign.center,
                ),
              ),
              alignment: Alignment.center),
        ],
        SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 10.0, top: 0),
              child: Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    controller.emptyOption = "";
                    controller.optionYesOrNo = "yes";
                    controller.update();
                  },
                  child: Text(
                    language.button_no,
                    style: TextStyle(
                        color: controller.comment == "yes"
                            ? AppThemes.colorWhite
                            : AppThemes.primary,
                        fontSize: 12.sp,
                        fontFamily: AppConstants.fontFamily,
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(107.0, 6.h)),
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.all(
                        controller.comment == "yes"
                            ? colorScheme.primary
                            : Colors.transparent),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(
                            color: AppThemes.primary.withOpacity(0.5)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 0),
              child: Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    controller.emptyOption = "";
                    controller.optionYesOrNo = "no";
                    controller.update();
                  },
                  child: Text(
                    language.button_yes,
                    style: TextStyle(
                        color: AppThemes.colorWhite,
                        fontSize: 12.sp,
                        fontFamily: AppConstants.fontFamily,
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(107.0, 6.h)),
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.all(
                        controller.comment == "no"
                            ? colorScheme.primary
                            : Colors.transparent),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(
                            color: AppThemes.primary.withOpacity(0.5)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.0)
      ],
    );
  }

  Widget _buildInformation(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(language.order_information,
                  style: textTheme.bodyText1!.copyWith(
                      fontSize: 13.sp, color: Colors.white)),
            ),
            Spacer()
          ],
        ),
        Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
              border: Border.all(color: Helpers.primaryLineColor()),
              borderRadius: BorderRadius.circular(8)),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                "${language.products}",
                                style: textTheme.bodySmall!.copyWith(
                                    fontSize: 12.sp, color: Color(0xff838383)),
                                textAlign: TextAlign.start,
                              ),
                              Spacer(),
                              Text(
                                "${controller.orderInfoDetails.value?.products?.length} ${language.items}",
                                style: textTheme.bodySmall!.copyWith(
                                    fontSize: 12.sp,
                                    color: Colors.white),
                                textAlign: TextAlign.end,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                "${language.prices}",
                                style: textTheme.bodySmall!.copyWith(
                                    fontSize: 12.sp, color: Color(0xff838383)),
                                textAlign: TextAlign.start,
                              ),
                              Spacer(),
                              Text(
                                "${controller.getCartItemTotalAmount(controller.orderInfoDetails.value?.products)} ${language.currency_symbol}",
                                style: textTheme.bodySmall!.copyWith(
                                    fontSize: 12.sp,
                                    color: Colors.white),
                                textAlign: TextAlign.end,
                              )
                            ],
                          ),
                        ),
                        if (controller.orderInfoDetails.value != null) ...[
                          if ((controller.orderInfoDetails.value!.establishment!.cashbackPercent ?? 0) > 0) ...[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  //open cashback alert dialog
                                  showDialog(
                                      context: context,
                                      builder: (context) => CashBackDialog(
                                        message: "",
                                      ));
                                },
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                            height: 15,
                                            width: 15,
                                            child: SvgPicture.asset(
                                              AssetsPath.icAlertFull,
                                            )),
                                        SizedBox(
                                          width: 4.0,
                                        ),
                                        Text(
                                          "${language.cashback} ${controller.orderInfoDetails.value!.establishment!.cashbackPercent.toString()}%:",
                                          style: textTheme.bodySmall!.copyWith(
                                              fontSize: 12.sp,
                                              color: colorScheme.primary),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Text(
                                      "${controller.getCashback(controller.orderInfoDetails.value?.products)} ${language.currency_symbol}",
                                      style: textTheme.bodySmall!.copyWith(
                                          fontSize: 12.sp,
                                          color: Colors.white),
                                      textAlign: TextAlign.end,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                "${language.shipping}",
                                style: textTheme.bodySmall!.copyWith(
                                    fontSize: 12.sp, color: Color(0xff838383)),
                                textAlign: TextAlign.start,
                              ),
                              Spacer(),
                              Text(
                                "${controller.orderInfoDetails.value?.establishment?.calculatedPrice} ${language.currency_symbol}",
                                style: textTheme.bodySmall!.copyWith(
                                    fontSize: 12.sp,
                                    color: Colors.white),
                                textAlign: TextAlign.end,
                              )
                            ],
                          ),
                        ),
                        if(controller.orderInfoDetails.value != null)...[
                          if (double.parse(controller.freeShippingAmount()) >
                              0) ...[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "${language.free_shipping}",
                                      style: textTheme.bodySmall!.copyWith(
                                          fontSize: 12.sp,
                                          color: Color(0xff838383)),
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  // Spacer(),
                                  Text(
                                    "${controller.freeShippingAmount()} ${language.currency_symbol}",
                                    style: textTheme.bodySmall!.copyWith(
                                        fontSize: 13.sp,
                                        color: Colors.white),
                                    textAlign: TextAlign.end,
                                  )
                                ],
                              ),
                            ),
                          ]
                        ],
                        Divider(color: Colors.white),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                "${language.total}",
                                style: textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                    color: Colors.white),
                                textAlign: TextAlign.start,
                              ),
                              Spacer(),
                              Text(
                                "${controller.getCartItemFinalWithDiscountAndWithoutDiscountTotalAmount(controller.orderInfoDetails.value?.products)} ${language.currency_symbol}",
                                style: textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                    color: Colors.white),
                                textAlign: TextAlign.end,
                              )
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
        ),
      ],
    );
  }

  Widget _buildOrder(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Align(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                language.your_orders,
                style: textTheme.bodyText1!.copyWith(
                    fontSize: 11.sp, color: Colors.white),
              ),
            ),
            alignment: Alignment.centerLeft),
        Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Helpers.primaryLineColor())),
          child: SizedBox(
            width: double.infinity,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "${controller.orderInfoDetails.value?.products![index].quantity}x ${controller.orderInfoDetails.value?.products![index].productData?.name}",
                                style: textTheme.bodySmall!.copyWith(
                                    fontSize: 10.sp, color: Color(0xff838383)),
                                textAlign: TextAlign.start,
                                softWrap: true,
                                maxLines: 2,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "${controller.getItemPriceWith2Digit("${controller.orderInfoDetails.value?.products![index].price.toString()}")} ${language.currency_symbol}",
                              style: textTheme.bodySmall!.copyWith(
                                  fontSize: 10.sp,
                                  color: Colors.white),
                              textAlign: TextAlign.end,
                              softWrap: true,
                              maxLines: 2,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: controller.orderInfoDetails.value?.products?.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        /*Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Helpers.primaryLineColor())),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                "${language.products}",
                                style: textTheme.bodySmall!.copyWith(
                                    fontSize: 12.sp, color: Color(0xff838383)),
                                textAlign: TextAlign.start,
                              ),
                              Spacer(),
                              Text(
                                "${controller.orderInfoDetails.value?.products?.length} ${language.items}",
                                style: textTheme.bodySmall!.copyWith(
                                    fontSize: 12.sp,
                                    color: Colors.white),
                                textAlign: TextAlign.end,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                "${language.prices}",
                                style: textTheme.bodySmall!.copyWith(
                                    fontSize: 12.sp, color: Color(0xff838383)),
                                textAlign: TextAlign.start,
                              ),
                              Spacer(),
                              Text(
                                "${controller.getCartItemTotalAmount(controller.orderInfoDetails.value?.products)} ${language.currency_symbol}",
                                style: textTheme.bodySmall!.copyWith(
                                    fontSize: 12.sp,
                                    color: Colors.white),
                                textAlign: TextAlign.end,
                              )
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
        ),*/
      ],
    );
  }

  //call allowed or not alert dialog
  onViewAlertDialog(BuildContext context) async {
    BuildContext moContext;
    moContext = context;

    var textTheme = Theme.of(moContext).textTheme;
    var language = AppLocalizations.of(moContext)!;

    var titleWidget = Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: language.call_window_title_message,
            style: textTheme.bodyText2!.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.white),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
    showDialog(
        context: moContext,
        builder: (moContext) => WidgetDialog(
              titleWidget: titleWidget,
              icons: AssetsPath.callBigIconsWhite,
              okButtonText: language.call_allow,
              closeButtonText: language.call_deny,
              isSingleButton: false,
              isBothButtonHide: false,
              isCloseDialog: true,
              onPositivePressed: () {
                //close screen
                Navigator.of(moContext).pop();
              },
              onNegativePressed: () {
                debugPrint("OnPressed1!!");
                Navigator.of(moContext).pop();
              },
            ));
  }
}
