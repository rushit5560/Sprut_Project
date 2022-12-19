import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/presentation/pages/home_screen/controllers/home_controller.dart';
import 'package:sprut/presentation/widgets/primary_elevated_btn/primary_elevated_btn.dart';
import 'package:sprut/resources/app_themes/app_themes.dart';

class AddressConfirmationDialog extends GetView<HomeViewController> {
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  AddressConfirmationDialog(
      {required this.textEditingController, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.only(left: 12, right: 12),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(7),
                ),
                border: Border.all(color: colorScheme.primary, width: 1)),
            height: 45,
            padding: EdgeInsets.all(10),
            child: TextField(
              style: textTheme.bodyText2!.copyWith(
                  fontSize: 10.sp,
                  color: AppThemes.dark,
                  decoration: TextDecoration.none),
              controller: textEditingController,
              readOnly: true,
              decoration: new InputDecoration.collapsed(hintText: ''),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);

                        FocusScope.of(Get.context!).requestFocus(focusNode);
                      },
                      child: Text("No",
                          style: textTheme.bodyText1!
                              .copyWith(fontSize: 10.sp, color: Colors.red))),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: PrimaryElevatedBtn(
                      fontSize: 10.sp,
                      height: 40.0,
                      buttonText: "Yes",
                      onPressed: () {
                        controller.updateSuggestions();
                        controller.suggestions = [];
                        if (controller.lastFocus == "whereToArrive") {
                          controller.arrivalArbtraryAddresssValidator(context);
                        } else {
                          controller
                              .destinationArbitraryAddressValidator(context);
                        }
                      }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
