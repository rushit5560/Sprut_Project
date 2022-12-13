import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprut/business_logic/blocs/connection_bloc/connection_bloc.dart';
import 'package:sprut/business_logic/blocs/connection_bloc/connection_bloc.dart';
import 'package:sprut/business_logic/blocs/connection_bloc/connection_state/connection_state.dart';

import '../../../../../../data/models/tariff_screen_model/card_model.dart';
import '../../../../../../resources/app_constants/app_constants.dart';
import '../../../../../../resources/app_themes/app_themes.dart';
import '../../../../../resources/configs/helpers/helpers.dart';
import '../../../../resources/assets_path/assets_path.dart';
import '../../../widgets/cart_leave_dialog/cart_leave_dialog.dart';
import '../../../widgets/common_dialog/common_dialog.dart';
import '../../../widgets/primary_elevated_btn/primary_elevated_btn.dart';
import '../../no_internet/no_internet.dart';
import 'payment_add_view.dart';
import '../../payment_screen/controllers/payment_controller.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDeleteDialogShow = false;
    //Food delivery
    if (Helpers.isLoginTypeIn() == AppConstants.TAXI_APP) {
      Helpers.systemStatusBar();
    } else {
      Helpers.systemStatusBar1();
    }
    //End

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
    return GetBuilder<PaymentController>(
      init: PaymentController(),
      initState: (_) {
        //Food delivery
        // controller.edit = false;
        // controller.getProfile();
        // controller.getCards();
        //End
      },
      builder: (_) {
        return Scaffold(
          backgroundColor: Helpers.primaryBackgroundColor(colorScheme),
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
                        Spacer(),
                        Container(
                          child: InkWell(
                            onTap: () {
                              controller.edit = !controller.edit;
                              controller.update();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                controller.edit
                                    ? language.ready
                                    : language.edit,
                                textAlign: TextAlign.center,
                                style: textTheme.bodyText1!.copyWith(
                                  fontSize: 12.sp,
                                  color: Colors.white,
                                ),
                              ),
                              height: 5.h,
                              width: 10.h,
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
                    language.payment_methods,
                    style: textTheme.bodyText1!.copyWith(
                      fontSize: 12.sp,
                      // color: AppThemes.dark,
                      color: Helpers.primaryTextColor(),
                    ),
                  ),
                ),
                buildBalanceItem({
                  "title": language.balance,
                  "icon": "assets/payments/balance.svg",
                }, colorScheme, language, context),
                SizedBox(
                  height: 4.0,
                ),
                //Food delivery
                if(Helpers.isLoginTypeIn() == AppConstants.TAXI_APP)...[
                  buildCashItem({
                    "title": language.cash,
                    "icon": "assets/payments/cash.svg"
                  }, context),
                ],
                //End
                // buildCashItem({
                //   "title": language.cash,
                //   "icon": "assets/payments/cash.svg"
                // }, context),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(0.0),
                    child: ListView.builder(
                      padding: EdgeInsets.all(0.0),
                      itemCount: controller.cards.length + 1,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (index == controller.cards.length) {
                          return buildItemAddCard({
                            "title": language.add_card,
                            "icon": "assets/payments/add_card.svg"
                          }, context);
                        }
                        return buildCardsItem(controller.cards[index], context);
                      },
                    ),
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

  Widget buildBalanceItem(dynamic map, ColorScheme colorScheme,
      AppLocalizations language, BuildContext context) {
    return Container(
      margin: EdgeInsets.all(
        4.0,
      ),
      decoration: BoxDecoration(
        // color: Colors.white,
        color: Helpers.secondaryBackground(),//food delivery
        borderRadius: BorderRadius.all(
          Radius.circular(7),
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              //Food Delivery
              controller.paymentType = controller.balanceTitle;
              controller.paymentChange = true;
              //End

              controller.updatePaymentType(context, controller.balanceTitle,
                  true, Cards(id: 0, cardMask: "", cardDefault: false));
            },
            child: Container(
              alignment: Alignment.center,
              height: 60,
              padding: EdgeInsets.all(4),
              child: Row(
                children: [
                  Container(
                    height: 2.5.h,
                    width: 10.w,
                    child: SvgPicture.asset(
                      map["icon"]!,
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    map["title"]!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Helpers.primaryTextColor(),
                        fontFamily: AppConstants.fontFamily,
                        fontWeight: FontWeight.w400,
                        fontSize: 10.sp),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Expanded(
                    child: Text(
                      // "(${controller.balance} \₴)",
                      "(${controller.balance} ${language.currency_symbol})",//food delivery
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
                  if (!controller.edit)
                    Container(
                      height: 2.5.h,
                      width: 8.w,
                      child: SvgPicture.asset(
                        controller.balanceTitle == controller.paymentType
                            ? "assets/payments/radio_selected.svg"
                            : "assets/payments/radio_unselected.svg",
                      ),
                    ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              top: 16.0,
              bottom: 16.0,
            ),
            child: PrimaryElevatedBtn(
              buttonText: language.replenish,
              onPressed: () {
                showCupertinoModalBottomSheet(
                  expand: false,
                  enableDrag: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  context: context,
                  builder: (context) => PaymentAddView(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCashItem(dynamic map, BuildContext context) {
    return Container(
      margin: EdgeInsets.all(
        4.0,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          controller.updatePaymentType(context, controller.cashTitle, true,
              Cards(id: 0, cardMask: "", cardDefault: false));

          //food delivery
          controller.paymentType = controller.cashTitle;
          controller.paymentChange = true;
          //End
        },
        child: Container(
          alignment: Alignment.center,
          height: 60,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            // color: Colors.white,
            color: Helpers.secondaryBackground(),//Food delivery
            borderRadius: BorderRadius.all(
              Radius.circular(7),
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 2.5.h,
                width: 10.w,
                child: SvgPicture.asset(
                  map["icon"]!,
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  map["title"]!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      // color: Colors.black,
                      color: Helpers.primaryTextColor(),//Food Delivery
                      fontFamily: AppConstants.fontFamily,
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp),
                ),
              ),
              SizedBox(
                width: 4,
              ),
              if (!controller.edit)
                Container(
                  height: 2.5.h,
                  width: 8.w,
                  child: SvgPicture.asset(
                    controller.cashTitle == controller.paymentType
                        ? "assets/payments/radio_selected.svg"
                        : "assets/payments/radio_unselected.svg",
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCardsItem(Cards cards, BuildContext context) {
    return Container(
      margin: EdgeInsets.all(
        4.0,
      ),
      child: GestureDetector(
        onTap: () {
          if (controller.edit) {
            print('Delete Cards');
            onShowRemovingDialog(context,cards);
            // controller.deleteCard(context, "${cards.id}");
          } else {
            print("Update Call");
            controller.updatePaymentType(context, controller.cardTitle, true, cards);

            //Food Delivery
            controller.paymentType = controller.cardTitle;
            controller.cardNumber = cards.cardMask.toString();
            //End
          }
        },
        child: Container(
          alignment: Alignment.center,
          height: 60,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            // color: Colors.white,
            color: Helpers.secondaryBackground(), //Food Delivery
            borderRadius: BorderRadius.all(
              Radius.circular(7),
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 2.5.h,
                width: 10.w,
                child: SvgPicture.asset(
                  "assets/payments/card.svg",
                ),
              ),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  cards.cardMask!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      // color: Colors.black,
                      color: Helpers.primaryTextColor(),//Food delivery
                      fontFamily: AppConstants.fontFamily,
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp),
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Container(
                height: 2.5.h,
                width: 8.w,
                child: SvgPicture.asset(
                  controller.edit
                      ? "assets/payments/card_delete.svg"
                      : ((controller.cardTitle == controller.paymentType && cards.cardDefault!)? "assets/payments/radio_selected.svg": "assets/payments/radio_unselected.svg"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  // Food delivery
  void onShowRemovingDialog(BuildContext context, Cards cards) {
    var language = AppLocalizations.of(context)!;
    BuildContext mContext = context;
    showDialog(
      context: mContext,
      builder: (context) =>
          CommonDialog(
            message: "",
            title: language.remove_card_alert_message,
            icons: AssetsPath.leaveCartIcon,
            okButtonText: language.yes_delete,
            closeButtonText: language.cancel,
            isSingleButton: true,
            onPositivePressed: () {
              Navigator.of(mContext).pop();

              if (controller.cards.length == 1) {
                controller.paymentType = controller.balanceTitle;
                controller.paymentChange = true;
                //controller.updatePaymentType(mContext);
                controller.update();
              }

              controller.deleteCard(mContext, "${cards.id}");
            },
            onNegativePressed: () {
              Navigator.of(mContext).pop();
            },
          ),
    );
  }

  // End
/*
  void onShowRemovingDialog(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => CartLeaveDialog(
        message: "",
        title: language.remove_item_alert_message,
        icons: AssetsPath.leaveCartIcon,
        okButtonText: language.yes_delete,
        closeButtonText: language.cancel,
        isSingleButton: true,
        onPositivePressed: () {
          controller.isDeleteDialogShow = false;
          Navigator.of(context).pop();
          controller.deleteItemInCart(item);
          print("Remove from cart!");
          if (controller.getTotalCartItem() == 0) {
            print("Empty Cart!");
            Navigator.of(context).pop();
          }
        },
        onNegativePressed: () {
          controller.isDeleteDialogShow = false;
          Navigator.of(context).pop();
        },
      ),
    );
  }*/
  Widget buildItemAddCard(dynamic map, BuildContext context) {
    return Container(
      margin: EdgeInsets.all(
        4.0,
      ),
      child: GestureDetector(
        onTap: () {
          controller.addCard(context);
        },
        child: Container(
          alignment: Alignment.center,
          height: 60,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            // color: Colors.white,
            color: Helpers.secondaryBackground(),//Food Delivery
            borderRadius: BorderRadius.all(
              Radius.circular(7),
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 2.5.h,
                width: 10.w,
                child: SvgPicture.asset(
                  map["icon"]!,
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  map["title"]!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      // color: Colors.black,
                      color: Helpers.primaryTextColor(), //Food Delivery
                      fontFamily: AppConstants.fontFamily,
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp),
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Container(
                height: 2.5.h,
                width: 8.w,
                child: SvgPicture.asset("assets/payments/add.svg"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
