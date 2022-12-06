import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprut/presentation/pages/order_screen/controllers/order_controller.dart';
import 'package:sprut/resources/assets_path/assets_path.dart';

import '../../../../business_logic/blocs/connection_bloc/connection_bloc.dart';
import '../../../../business_logic/blocs/connection_bloc/connection_state/connection_state.dart';
import '../../../../resources/configs/helpers/helpers.dart';
import '../../../../resources/configs/routes/routes.dart';
import '../../../widgets/cash_back_dialog/cash_back_dialog.dart';
import '../../../widgets/common_dialog/common_dialog.dart';
import '../../../widgets/custom_dialog/widget_dialog.dart';
import '../../../widgets/primary_container/primary_container.dart';
import '../../no_internet/no_internet.dart';

class OrderCancellationView extends GetView<OrderController> {
  @override
  Widget build(BuildContext context) {
    Helpers.systemStatusBar1();
    dynamic object = ModalRoute.of(context)!.settings.arguments;
    Map<String, dynamic> mapData = jsonDecode(object);

    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return BlocConsumer<ConnectedBloc, ConnectedState>(
      listener: (context, state) {
        if (state is ConnectedInitialState) {}
        if (state is ConnectedSucessState) {}

        if (state is ConnectedFailureState) {}
      },
      builder: (context, connectionState) {
        return connectionState is ConnectedFailureState
            ? NoInternetScreen(onPressed: () async {})
            : Scaffold(
          appBar: AppBar(
              elevation: 0,
              backgroundColor: Helpers.primaryBackgroundColor(colorScheme),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: PrimaryContainer(
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          FocusScope.of(context).unfocus();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: colorScheme.background,
                        ))),
              )),
          body: SafeArea(
            top: false,
            bottom: false,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AssetsPath.sadIcon,
                        color: Helpers.primaryTextColor(),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "${language.order_cancel}",
                        style: textTheme.headline1!.copyWith(
                            fontSize: 15.sp, color: Helpers.primaryTextColor()),
                      ),
                      SizedBox(height: 8),
                      Text(
                        controller.orderInfoDetails.value?.createdAt == null
                            ? ""
                            : "${Helpers.orderCreatedDate(context, controller.orderInfoDetails.value?.createdAt, language.today_at)}",
                        style: textTheme.bodySmall!
                            .copyWith(fontSize: 9.sp, color: Color(0xffAAAAAA)),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 4, bottom: 4),
                        child: Divider(
                          color: Helpers.primaryTextColor(),
                        ),
                      ),
                      Text(
                        "${language.support_message}",
                        //${Helpers.getOrderStatusByDeliveryStatus(context, '${controller.orderInfoDetails.value?.deliveryStatus}', language)} ${language.support_sub_message}
                        style: textTheme.bodyText1!.copyWith(
                            fontSize: 12.sp, color: Helpers.primaryTextColor()),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "9900",
                        style: textTheme.bodyText1!.copyWith(
                            fontSize: 20.sp,
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(height: 2),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(
                                Icons.phone_rounded,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                "${language.call}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Helpers.launchUrl("tel:9900");
                          // onViewAlertDialog(context);
                        },
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text("${language.order_information}",
                              style: textTheme.bodyText1!.copyWith(
                                  fontSize: 11.sp,
                                  color: Helpers.primaryTextColor())),
                          Spacer()
                        ],
                      ),
                      SizedBox(height: 4),
                      _buildInformation(context),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            openCancelAlertDialog(context, mapData);
                          },
                          child: Text("${language.cancel}",
                              style: textTheme.bodyText1!.copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                  color: Colors.white)),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
          backgroundColor: Helpers.primaryBackgroundColor(colorScheme),
        );
      },
    );
  }

  Widget _buildInformation(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Helpers.primaryTextColor()),
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
                            "${controller.orderInfoDetails.value?.products![0].quantity} ${language.items}",
                            style: textTheme.bodySmall!.copyWith(
                                fontSize: 12.sp,
                                color: Helpers.primaryTextColor()),
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
                                color: Helpers.primaryTextColor()),
                            textAlign: TextAlign.end,
                          )
                        ],
                      ),
                    ),
                    if ((controller.orderInfoDetails.value!.establishment!
                                .cashbackPercent ??
                            0) >
                        0) ...[
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
                                    "${language.cashback} ${controller.orderInfoDetails.value!.establishment!.cashbackPercent.toString()}%",
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
                                    color: Helpers.primaryTextColor()),
                                textAlign: TextAlign.end,
                              )
                            ],
                          ),
                        ),
                      )
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
                                color: Helpers.primaryTextColor()),
                            textAlign: TextAlign.end,
                          )
                        ],
                      ),
                    ),
                    if (double.parse(controller.freeShippingAmount()) > 0) ...[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${language.free_shipping}",
                                style: textTheme.bodySmall!.copyWith(
                                    fontSize: 12.sp, color: Color(0xff838383)),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "${controller.freeShippingAmount()} ${language.currency_symbol}",
                              style: textTheme.bodySmall!.copyWith(
                                  fontSize: 12.sp,
                                  color: Helpers.primaryTextColor()),
                              textAlign: TextAlign.end,
                            )
                          ],
                        ),
                      ),
                    ],
                    Divider(color: Helpers.primaryTextColor()),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "${language.total}",
                            style: textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                                color: Helpers.primaryTextColor()),
                            textAlign: TextAlign.start,
                          ),
                          Spacer(),
                          Text(
                            "${controller.getCartItemFinalWithDiscountAndWithoutDiscountTotalAmount(controller.orderInfoDetails.value?.products)} ${language.currency_symbol}",
                            style: textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                                color: Helpers.primaryTextColor()),
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
                color: Helpers.primaryTextColor()),
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
                Helpers.launchUrl("tel:900");
              },
              onNegativePressed: () {
                debugPrint("OnPressed1!!");
                Navigator.of(moContext).pop();
              },
            ));
  }

  //order cancel alert dialog
  onCancelAlertDialog(
      BuildContext context, Map<String, dynamic> mapData) async {
    BuildContext moContext;
    moContext = context;

    var textTheme = Theme.of(moContext).textTheme;
    var language = AppLocalizations.of(moContext)!;

    var titleWidget = Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: language.order_cancel_message,
            style: textTheme.bodyText2!.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Helpers.primaryTextColor()),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
    showDialog(
        context: moContext,
        builder: (moContext) => WidgetDialog(
              titleWidget: titleWidget,
              icons: AssetsPath.orderCancelCartIcon,
              okButtonText: language.okay,
              closeButtonText: "",
              isSingleButton: true,
              isBothButtonHide: false,
              isCloseDialog: false,
              onPositivePressed: () {
                controller.timer?.cancel();
                controller.timer1?.cancel();
                //close screen
                Navigator.of(moContext).pop();
                if (mapData['from'].toString() == "orderListing") {
                  Get.back();
                  Get.back();
                } else {
                  Get.offAllNamed(Routes.foodHomeScreen);
                }
              },
              onNegativePressed: () {
                debugPrint("OnPressed1!!");
                Navigator.of(moContext).pop();
              },
            ));
  }

  //open cancel order alert dialog
  openCancelAlertDialog(
      BuildContext context, Map<String, dynamic> mapData) async {
    BuildContext moContext;
    moContext = context;

    var textTheme = Theme.of(moContext).textTheme;
    var language = AppLocalizations.of(moContext)!;

    showDialog(
      context: context,
      builder: (moContext) => CommonDialog(
        message: "",
        title: language.order_cancel_request_message,
        icons: "",
        okButtonText: language.yes,
        closeButtonText: language.no,
        isSingleButton: true,
        onPositivePressed: () async {
          Navigator.of(moContext).pop();
          controller.timer?.cancel();
          //call cancel api
          var response = await controller.cancelOrderCall(context);
          onCancelAlertDialog(context, mapData);
        },
        onNegativePressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
