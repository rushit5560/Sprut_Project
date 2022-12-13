// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/business_logic/blocs/authentication_bloc/auth_bloc/auth_bloc.dart';
import 'package:sprut/business_logic/blocs/authentication_bloc/auth_event/auth_event.dart';
import 'package:sprut/business_logic/blocs/authentication_bloc/auth_state/auth_state.dart';
import 'package:sprut/presentation/widgets/primary_elevated_btn/primary_elevated_btn.dart';
import 'package:sprut/resources/app_constants/app_constants.dart';
import 'package:sprut/resources/app_themes/app_themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../resources/configs/helpers/helpers.dart';

class OtpVerificationDialog extends StatefulWidget {
  final String userPhoneNumber;
  OtpVerificationDialog({required this.userPhoneNumber});
  @override
  State<OtpVerificationDialog> createState() => _OtpVerificationDialogState();
}

class _OtpVerificationDialogState extends State<OtpVerificationDialog> {
  final List<String> options = ["Not received an SMS", "Change phone number"];

  int radioBtnValue = 0;
  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    options[0] = language.notReceiveSms;
    options[1] = language.changeMobile;
    var colorScheme = Theme.of(context).colorScheme;

    var textTheme = Theme.of(context).textTheme;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ChangeMobileNumber) {
          /// [Closing Current Screen and Dialog and navigating back to login screen]
          Navigator.pop(context);
          Navigator.pop(context);
          context
              .read<AuthBloc>()
              .emit(ChangeMobileInitiate(mobile: widget.userPhoneNumber));
        }
      },
      child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    language.issueWithVerification,
                    style: textTheme.bodyText1!
                        .copyWith(color: AppThemes.dark, fontSize: 12.sp),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                ...List.generate(
                    options.length,
                    (index) => GestureDetector(
                          onTap: () {
                            radioBtnValue = index;
                            log(radioBtnValue.toString());
                            setState(() {});
                          },
                          child: Container(
                            height: 4.h,
                            child: Row(
                              children: [
                                Transform.scale(
                                  scale: 1.3,
                                  child: Radio(
                                    activeColor: colorScheme.primary,
                                    groupValue: index,
                                    value: radioBtnValue,
                                    onChanged: (value) {},
                                  ),
                                ),
                                Text(
                                  options[index],
                                  style: textTheme.bodyText1!.copyWith(
                                      color: AppThemes.dark, fontSize: 10.sp),
                                )
                              ],
                            ),
                          ),
                        )),
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            language.cancel,
                            style: TextStyle(
                                color: colorScheme.error,
                                fontFamily: AppConstants.fontFamily,
                                fontWeight: FontWeight.w400,
                                fontSize: 10.sp),
                          ),
                        ),
                      ),
                      Expanded(
                          child: PrimaryElevatedBtn(
                              fontSize: 11.sp,
                              height: 44.0,
                              buttonText: language.confirm,
                              onPressed: () async {
                                if (radioBtnValue == 0) {
                                  bool isConnected =
                                      await Helpers.checkInternetConnectivity();

                                  if (!isConnected) {
                                    Helpers.internetDialog(context);
                                    return;
                                  }

                                  /// If user havent received an sms
                                  Navigator.pop(context);
                                  context.read<AuthBloc>().add(AuthSendOtpAgain(
                                        mobileNumber: widget.userPhoneNumber,
                                      ));
                                } else if (radioBtnValue == 1) {
                                  // if user want to change his phoneNumber

                                  context
                                      .read<AuthBloc>()
                                      .emit(ChangeMobileNumber());
                                }
                              }))
                    ],
                  ),
                )
              ],
            ),
          ),
          decoration: BoxDecoration(
              color: colorScheme.background,
              borderRadius: BorderRadius.circular(7))),
    );
  }
}
