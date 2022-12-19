import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/business_logic/blocs/authentication_bloc/auth_bloc/auth_bloc.dart';
import 'package:sprut/business_logic/blocs/authentication_bloc/auth_event/auth_event.dart';
import 'package:sprut/business_logic/blocs/authentication_bloc/auth_state/auth_state.dart';
import 'package:sprut/presentation/widgets/app_logo/app_logo.dart';
import 'package:sprut/presentation/widgets/dialogs/otp_verification/otp_verification_dialog.dart';
import 'package:sprut/presentation/widgets/otp_text_field/otp_text_field.dart';
import 'package:sprut/presentation/widgets/primary_container/primary_container.dart';
import 'package:sprut/resources/app_constants/app_constants.dart';
import 'package:sprut/resources/assets_path/assets_path.dart';
import 'package:sprut/resources/configs/helpers/helpers.dart';
import 'package:sprut/resources/configs/routes/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprut/resources/configs/service_locator/service_locator.dart';
import 'package:sprut/resources/services/database/database.dart';
import 'package:sprut/resources/services/database/database_keys.dart';

import '../../Privacy_police/Views/privacy_policy_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController otpEditingController = TextEditingController();

  final DatabaseService databaseService = serviceLocator.get<DatabaseService>();
  @override
  Widget build(BuildContext context) {
    Helpers.systemStatusBar();

    var language = AppLocalizations.of(context)!;

    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    print(arguments);
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUsingOtpProgress) {
          Helpers.showCircularProgressDialog(context: context);
        } else if (state is AuthUsingOtpSucceed) {
          context.read<AuthBloc>().add(AuthAvailableCitiesEvent());

          Navigator.pop(context);
          databaseService.saveToDisk(DatabaseKeys.isLoggedIn, true);
          databaseService.saveToDisk(
              DatabaseKeys.userPhoneNumber, arguments["userPhone"]);

          if ((databaseService
                      .getFromDisk(DatabaseKeys.privacyPolicyAccepted) ??
                  false) ==
              false) {
            Navigator.pushReplacementNamed(context, Routes.privacyPolicy);
          } else {
            Navigator.pushReplacementNamed(context, Routes.cityLogin);
          }
        } else if (state is AuthUsingOtpFailed) {
          Navigator.pop(context);

          Helpers.showSnackBar(context, state.message);
        }
      },
      builder: (context, authState) {
        return Scaffold(
          appBar: AppBar(
              elevation: 0,
              backgroundColor: colorScheme.onBackground,
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
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 3.h,
                        ),
                        Center(child: AppLogo()),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(language.verification,
                            style:
                                textTheme.headline1!.copyWith(fontSize: 15.sp)),
                        SizedBox(
                          height: 1.h,
                        ),
                        Text(
                            "${language.smsConfirm} +380${arguments["userPhone"]}\n${language.enterCode}",
                            style: textTheme.bodyText1!.copyWith(
                                fontSize: 10.sp, color: colorScheme.secondary)),
                        SizedBox(
                          height: 1.h,
                        ),
                        OtpTextField(
                          validator: (value) {},
                          prefixIcon: Image.asset(
                            AssetsPath.phone,
                            height: 5.h,
                            width: 4.w,
                          ),
                          controller: otpEditingController,
                          onChanged: (String) async {
                            bool isConnected =
                                await Helpers.checkInternetConnectivity();

                            if (!isConnected) {
                              Helpers.internetDialog(context);
                              return;
                            }

                            if (otpEditingController.text.length == 4) {
                              context.read<AuthBloc>().add(AuthVerifyOtp(
                                    otp: otpEditingController.text,
                                  ));
                            }

                            setState(() {});

                            return;
                          },
                          suffixIcon: otpEditingController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    otpEditingController.clear();

                                    setState(() {});
                                  },
                                  icon: Icon(Icons.close),
                                )
                              : Container(
                                  width: 0,
                                ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: OtpVerificationDialog(
                                        userPhoneNumber: arguments["userPhone"],
                                      )));
                            },
                            child: Container(
                              child: Text(language.resendCode,
                                  style: TextStyle(
                                      color: colorScheme.primary,
                                      fontSize: 11.sp,
                                      fontFamily: AppConstants.fontFamily,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        )
                      ]),
                ),
              ),
            ),
          ),
          // bottomNavigationBar: BlocBuilder<ConnectedBloc, ConnectedState>(
          //   builder: (context, connectionBloc) {
          //     return Padding(
          //       padding: EdgeInsets.only(
          //           bottom: MediaQuery.of(context).viewInsets.bottom),
          //       child: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: PrimaryElevatedBtn(
          //             color: otpEditingController.text.length < 4
          //                 ? colorScheme.secondary
          //                 : colorScheme.primary,
          //             buttonText: language.continueText,
          //             onPressed: () {

          //             }),
          //       ),
          //     );
          //   },
          // ),
          backgroundColor: colorScheme.onBackground,
        );
      },
    );
  }
}
