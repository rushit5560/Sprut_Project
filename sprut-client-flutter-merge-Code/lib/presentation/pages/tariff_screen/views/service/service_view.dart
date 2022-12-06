import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../data/models/tariff_screen_model/service_model.dart';
import '../../../../../../resources/app_constants/app_constants.dart';
import '../../../../../../resources/app_themes/app_themes.dart';
import '../../../../widgets/primary_elevated_btn/primary_elevated_btn.dart';
import '../../controllers/tariff_controller.dart';

class ServiceView extends GetView<TariffController> {
  const ServiceView({Key? key}) : super(key: key);

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
                        language.service_title,
                        style: textTheme.bodyText1!.copyWith(
                          fontSize: 12.sp,
                          color: AppThemes.dark,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        language.service_desc,
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
                    itemCount: controller.services.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return buildItem(controller.services[index]);
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

  Widget buildItem(ServiceModel serviceModel) {
    return Container(
      margin: EdgeInsets.all(
        4.0,
      ),
      child: GestureDetector(
        onTap: () {
          if (controller.getServiceExist(serviceModel.optionId)) {
            controller.serviceRemove = serviceModel;
          } else {
            controller.service = serviceModel;
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
              Container(
                height: 4.h,
                width: 15.w,
                child: Image.asset(
                  controller.getServiceIconExist(serviceModel.code),
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  serviceModel.name!,
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
                  controller.getServiceExist(serviceModel.optionId)
                      ? "assets/services/checkbox_selected.svg"
                      : "assets/services/checkbox_unselected.svg",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
