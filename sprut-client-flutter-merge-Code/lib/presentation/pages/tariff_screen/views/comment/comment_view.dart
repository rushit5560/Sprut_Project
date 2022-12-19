import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../resources/app_constants/app_constants.dart';
import '../../../../../../resources/app_themes/app_themes.dart';
import '../../../../widgets/primary_elevated_btn/primary_elevated_btn.dart';
import '../../controllers/tariff_controller.dart';

class CommentView extends GetView<TariffController> {
  const CommentView({Key? key}) : super(key: key);

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
                        language.comment_title,
                        style: textTheme.bodyText1!.copyWith(
                          fontSize: 12.sp,
                          color: AppThemes.dark,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        language.comment_desc,
                        style: textTheme.bodyText1!.copyWith(
                          fontSize: 9.sp,
                          color: AppThemes.lightGrey,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(
                  8.0,
                ),
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
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: SvgPicture.asset(
                        "assets/images/comment.svg",
                      ),
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
                          controller.comment = value;
                          controller.update();
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 4.0, right: 4.0, bottom: 4.0, top: 8.0),
                          border: InputBorder.none,
                          labelText: language.comment_hint,
                          labelStyle: TextStyle(
                            color: colorScheme.secondaryContainer,
                            fontSize: 12,
                            fontFamily: "SF-Pro Display",
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppThemes.lightGrey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppThemes.lightGrey),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: ListView.builder(
                    padding: EdgeInsets.all(0.0),
                    itemCount: 4,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      String title = "";

                      if (index == 0) {
                        title = language.comment_1;
                      } else if (index == 1) {
                        title = language.comment_2;
                      } else if (index == 2) {
                        title = language.comment_3;
                      } else if (index == 3) {
                        title = language.comment_4;
                      }

                      return buildItem(title);
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

  Widget buildItem(String title) {
    return Container(
      margin: EdgeInsets.all(
        4.0,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          controller.commentController.text = title;
          controller.comment = title;
          controller.update();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: AppConstants.fontFamily,
                  fontWeight: FontWeight.w400,
                  fontSize: 10.sp),
            ),
            const SizedBox(
              height: 4,
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
