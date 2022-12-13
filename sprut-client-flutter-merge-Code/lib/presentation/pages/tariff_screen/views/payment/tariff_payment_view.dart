import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../data/models/tariff_screen_model/card_model.dart';
import '../../../../../../resources/app_constants/app_constants.dart';
import '../../../../../../resources/app_themes/app_themes.dart';
import '../../../../widgets/primary_elevated_btn/primary_elevated_btn.dart';
import '../../controllers/tariff_controller.dart';

class TariffPaymentView extends GetView<TariffController> {
  const TariffPaymentView({Key? key}) : super(key: key);

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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.0,
              ),
              Center(
                child: Container(
                  width: 14.w,
                  height: 5,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: colorScheme.primary,
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
                        language.payment_title,
                        style: textTheme.bodyText1!.copyWith(
                          fontSize: 12.sp,
                          color: AppThemes.dark,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        language.payment_desc,
                        style: textTheme.bodyText1!.copyWith(
                          fontSize: 9.sp,
                          color: AppThemes.lightGrey,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
              buildBalanceItem({
                "title": language.balance,
                "icon": "assets/payments/balance.svg",
              }, colorScheme, language, context),
              SizedBox(
                height: 4.0,
              ),
              buildCashItem(
                  {"title": language.cash, "icon": "assets/payments/cash.svg"},
                  context),
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
              Container(
                margin: EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  top: 16.0,
                  bottom: 16.0,
                ),
                child: PrimaryElevatedBtn(
                  buttonText: language.confirm_button,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
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
              controller.updatePaymentType(context, controller.balanceTitle,
                  Cards(id: 0, cardMask: "", cardDefault: false));
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
          // Container(
          //   margin: EdgeInsets.only(
          //     left: 8.0,
          //     right: 8.0,
          //     top: 16.0,
          //     bottom: 16.0,
          //   ),
          //   child: PrimaryElevatedBtn(
          //     buttonText: language.replenish,
          //     onPressed: () {},
          //   ),
          // ),
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
          controller.updatePaymentType(context, controller.cashTitle,
              Cards(id: 0, cardMask: "", cardDefault: false));
        },
        child: Container(
          alignment: Alignment.center,
          height: 60,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
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
                      color: Colors.black,
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
          controller.updatePaymentType(context, controller.cardTitle, cards);
        },
        child: Container(
          alignment: Alignment.center,
          height: 60,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
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
              SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  cards.cardMask!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.black,
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
                  (controller.cardTitle == controller.paymentType &&
                          cards.cardDefault!)
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
            color: Colors.white,
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
                      color: Colors.black,
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
