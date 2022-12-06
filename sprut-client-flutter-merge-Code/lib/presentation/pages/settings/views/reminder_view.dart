import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../resources/app_themes/app_themes.dart';
import '../../../../../resources/configs/helpers/helpers.dart';
import '../../../../resources/app_constants/app_constants.dart';
import '../../../widgets/primary_elevated_btn/primary_elevated_btn.dart';
import '../controllers/settings_controller.dart';

class ReminderView extends GetView<SettingsController> {
  ReminderView({Key? key}) : super(key: key);

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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...[
                        Text(
                          language.reminder_title,
                          style: textTheme.bodyText1!.copyWith(
                            fontSize: 12.sp,
                            color: AppThemes.dark,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          language.reminder_desc,
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
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: ListView.builder(
                      padding: EdgeInsets.all(0.0),
                      itemCount: controller.preOrders.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return buildItem(
                            index, controller.preOrders[index], language);
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
                      controller.savePreorder();
                      Navigator.pop(context);
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

  Widget buildItem(int index, int preorder, AppLocalizations language) {
    return Container(
      margin: EdgeInsets.all(
        4.0,
      ),
      child: GestureDetector(
        onTap: () {
          if (index == 0) {
            controller.preOrderTime = 10;
          } else if (index == 1) {
            controller.preOrderTime = 15;
          } else if (index == 2) {
            controller.preOrderTime = 20;
          } else if (index == 3) {
            controller.preOrderTime = 25;
          }

          controller.update();
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
              SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  index == 0
                      ? language.preorder_1
                      : (index == 1
                          ? language.preorder_2
                          : (index == 2
                              ? language.preorder_3
                              : (index == 3
                                  ? language.preorder_4
                                  : language.preorder_1))),
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
                  controller.preOrderTime == preorder
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
}
