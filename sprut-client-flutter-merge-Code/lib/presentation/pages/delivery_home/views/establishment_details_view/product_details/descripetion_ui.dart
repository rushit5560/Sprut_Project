import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/presentation/pages/delivery_home/controller/establishment_details_controller.dart';

import '../../../../../../resources/app_constants/app_constants.dart';
import '../../../../../../resources/app_themes/app_themes.dart';

class DescriptionUi extends GetView<EstablishmentDetailsController> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Text(language.details,
              style: textTheme.bodyText2!.copyWith(
                  color: AppThemes.colorWhite,
                  fontWeight: FontWeight.w400,
                  fontFamily: AppConstants.fontFamily,
                  fontSize: 15.sp),
              softWrap: true,
              maxLines: 2,
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Text(
                  // "In non arcu congue, semper nulla quis, sollicitudin nibh. Fusce nec efficitur sem. Integer auctor massa quis lacus vulputate, quis gravida felis aliquet. Fusce ultricies ligula id ultricies tempor. Fusce suscipit mi nec nisi faucibus placerat. Cras tempus tempus lectus sit amet rhoncus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Suspendisse nec sapien id diam maximus aliquam. Donec commodo, ligula quis bibendum rutrum, mauris dolor cursus dolor, eu consectetur lorem libero vitae enim. Donec eget enim commodo est vestibulum porttitor. Vestibulum leo quam, cursus non scelerisque nec, sodales et leo. Nam nec nulla erat. Curabitur non rhoncus enim. In non arcu congue, semper nulla quis, sollicitudin nibh. Fusce nec efficitur sem. Integer auctor massa quis lacus vulputate, quis gravida felis aliquet. Fusce ultricies ligula id ultricies tempor. Fusce suscipit mi nec nisi faucibus placerat. Cras tempus tempus lectus sit amet rhoncus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Suspendisse nec sapien id diam maximus aliquam. Donec commodo, ligula quis bibendum rutrum, mauris dolor cursus dolor, eu consectetur lorem libero vitae enim. Donec eget enim commodo est vestibulum porttitor. Vestibulum leo quam, cursus non scelerisque nec, sodales et leo. Nam nec nulla erat. Curabitur non rhoncus enim. ",
                  '${controller.tempItems?.detailedDescription}' == "null"
                      ? ""
                      : '${controller.tempItems?.detailedDescription}',
                  style: textTheme.bodyText2!.copyWith(
                      color: AppThemes.colorWhite,
                      fontWeight: FontWeight.w400,
                      fontFamily: AppConstants.fontFamily,
                      fontSize: 12.sp),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  maxLines: 150,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
