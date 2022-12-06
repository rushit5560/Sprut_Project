import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../resources/app_constants/app_constants.dart';
import '../../../../../../resources/app_themes/app_themes.dart';
import '../../../../resources/configs/helpers/helpers.dart';
import '../../../widgets/primary_elevated_btn/primary_elevated_btn.dart';
import '../../payment_screen/controllers/payment_controller.dart';

class PaymentAddView extends GetView<PaymentController> {
  const PaymentAddView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //food delivery
    if(Helpers.isLoginTypeIn() == AppConstants.TAXI_APP){
      Helpers.systemStatusBar();
    }else {
      Helpers.systemStatusBar1();
    }

    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;
    return GetBuilder<PaymentController>(
      init: PaymentController(),
      initState: (_) {},
      builder: (_) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: Helpers.primaryBackgroundColor(colorScheme),
            body: SafeArea(
              child: ListView(
                shrinkWrap: true,
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
                      language.replenish_balance,
                      style: textTheme.bodyText1!.copyWith(
                        fontSize: 12.sp,
                        // color: AppThemes.dark,
                        color: Helpers.primaryTextColor(),
                      ),
                    ),
                  ),
                  buildBalanceItem(textTheme, colorScheme, language),
                  SizedBox(
                    height: 8.0,
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
                        controller.updateBalance(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildBalanceItem(
      TextTheme textTheme, ColorScheme colorScheme, AppLocalizations language) {
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
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            alignment: Alignment.center,
            height: 60,
            padding: EdgeInsets.all(4),
            child: Row(
              children: [
                Container(
                  height: 2.5.h,
                  width: 10.w,
                  child: SvgPicture.asset(
                    "assets/payments/balance.svg",
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  language.balance,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Helpers.primaryTextColor(),//food delivery
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
                    "(${controller.balance} ${language.currency_symbol})",
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
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 0.0, bottom: 6.0),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 6.0, bottom: 6.0),
            child: Text(
              language.enter_add_amount,
              textAlign: TextAlign.left,
              style: textTheme.bodyText1!.copyWith(
                fontSize: 10.sp,
                // color: AppThemes.dark,
                color: Helpers.secondaryTextColor(),//food delivery
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 8.0,
              bottom: 8.0,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.primary),
              borderRadius: BorderRadius.all(
                Radius.circular(4.0),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      controller.paymentAdd = "50";
                      controller.update();
                    },
                    child: Container(
                      padding: EdgeInsets.all(4.0),
                      height: 60,
                      decoration: BoxDecoration(
                        color: controller.paymentAdd == "50"
                            ? colorScheme.primary
                            // : Colors.white,
                            : Helpers.secondaryBackground(), //food delivery
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          bottomLeft: Radius.circular(4.0),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "50${language.currency_symbol}",
                        textAlign: TextAlign.center,
                        style: textTheme.bodyText1!.copyWith(
                          fontSize: 10.sp,
                          color: controller.paymentAdd == "50"
                              ? Colors.white
                              // : AppThemes.dark,
                              : Helpers.secondaryTextColor(),
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
                      controller.paymentAdd = "100";
                      controller.update();
                    },
                    child: Container(
                      padding: EdgeInsets.all(4.0),
                      height: 60,
                      decoration: BoxDecoration(
                        color: controller.paymentAdd == "100"
                            ? colorScheme.primary
                            // : Colors.white,
                            : Helpers.secondaryBackground(),//food delivery
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "100\₴",
                        textAlign: TextAlign.center,
                        style: textTheme.bodyText1!.copyWith(
                          fontSize: 10.sp,
                          color: controller.paymentAdd == "100"
                              ? Colors.white
                              // : AppThemes.dark,
                              : Helpers.secondaryTextColor(),
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
                      controller.paymentAdd = "200";
                      controller.update();
                    },
                    child: Container(
                      padding: EdgeInsets.all(4.0),
                      height: 60,
                      decoration: BoxDecoration(
                        color: controller.paymentAdd == "200"
                            ? colorScheme.primary
                            // : Colors.white,
                            : Helpers.secondaryBackground(), //food delivery
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "200\₴",
                        textAlign: TextAlign.center,
                        style: textTheme.bodyText1!.copyWith(
                          fontSize: 10.sp,
                          color: controller.paymentAdd == "200"
                              ? Colors.white
                              : Helpers.secondaryTextColor(), //food delivery
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
                      controller.paymentAdd = "other";
                      controller.update();
                    },
                    child: Container(
                      padding: EdgeInsets.all(4.0),
                      height: 60,
                      decoration: BoxDecoration(
                        color: controller.paymentAdd == "other"
                            ? colorScheme.primary
                            // : Colors.white,
                            : Helpers.secondaryBackground(), //Food Delivery
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
                          color: controller.paymentAdd == "other"
                              ? Colors.white
                              // : AppThemes.dark,
                              : Helpers.secondaryTextColor(), //Food Delivery
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (controller.paymentAdd == "other")
            Container(
              margin: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
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
                        border: Border.all(color: colorScheme.primary),
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/payments/currency.svg",
                          ),
                          const SizedBox(
                            width: 12.0,
                          ),
                          Expanded(
                            child: TextField(
                              controller: controller.amountController,
                              style: TextStyle(
                                  fontSize: 18, fontFamily: "SF-Pro Display" ,color: Helpers.primaryTextColor()),
                              focusNode: controller.amountFocusNode,
                              onChanged: (text) {},
                              textInputAction: TextInputAction.done,
                              maxLines: 1,
                              maxLength: 4,
                              textAlignVertical: TextAlignVertical.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                suffixIconConstraints: BoxConstraints(
                                  maxWidth: 30,
                                  maxHeight: 30,
                                ),
                                counterText: "",
                                suffixIcon: controller.amountFocusNode.hasFocus
                                    ? GestureDetector(
                                        onTap: () {
                                          controller.amountController.clear();
                                          controller.update();
                                        },
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          width: 30,
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.grey,
                                            size: 3.h,
                                          ),
                                        ),
                                      )
                                    : null,
                                labelStyle: TextStyle(
                                    color: Helpers.secondaryTextColor(),
                                    fontSize: 18,
                                    fontFamily: "SF-Pro Display"),
                                isDense: true,
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
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
                        controller.updateAmountController("subtract");
                      },
                      child: Container(
                        padding: EdgeInsets.all(4.0),
                        height: 60,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            bottomLeft: Radius.circular(4.0),
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
                        controller.updateAmountController("add");
                      },
                      child: Container(
                        padding: EdgeInsets.all(4.0),
                        height: 60,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(4.0),
                            bottomRight: Radius.circular(4.0),
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
          SizedBox(
            height: 8.0,
          ),
        ],
      ),
    );
  }
}
