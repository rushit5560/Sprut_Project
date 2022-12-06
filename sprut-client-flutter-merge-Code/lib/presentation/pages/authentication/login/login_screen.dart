import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/business_logic/blocs/authentication_bloc/auth_bloc/auth_bloc.dart';
import 'package:sprut/business_logic/blocs/authentication_bloc/auth_event/auth_event.dart';
import 'package:sprut/business_logic/blocs/authentication_bloc/auth_state/auth_state.dart';
import 'package:sprut/presentation/widgets/app_logo/app_logo.dart';
import 'package:sprut/presentation/widgets/custom_text_field/custom_text_field.dart';
import 'package:sprut/presentation/widgets/primary_elevated_btn/primary_elevated_btn.dart';
import 'package:sprut/resources/app_strings/app_strings.dart';
import 'package:sprut/resources/assets_path/assets_path.dart';
import 'package:sprut/resources/configs/helpers/helpers.dart';
import 'package:sprut/resources/configs/routes/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../resources/app_constants/app_constants.dart';
import '../../../../resources/configs/service_locator/service_locator.dart';
import '../../../../resources/services/database/database.dart';
import '../../../../resources/services/database/database_keys.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// User Phone Field Text Editing Controller
  final TextEditingController textEditingController = TextEditingController();

  /// [Form Key] for validating phone number field
  final _formKey = GlobalKey<FormState>();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    Helpers.systemStatusBar();

    var language = AppLocalizations.of(context)!;

    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState is AuthUsingMobileInProgress) {
          Helpers.showCircularProgressDialog(context: context);
        }

        if (authState is SucceedAuthUsingMobile) {
          /// Clearing Current user [mobile number] while navigating to otp screen
          Navigator.pop(context);

          Navigator.pushNamed(context, Routes.otpVerificationScreen,
              arguments: {"userPhone": textEditingController.text});
        }

        if (authState is FailureAuthUsingMobile) {
          log(authState.toString());
          Navigator.pop(context);
        }
        if (authState is ChangeMobileInitiate) {
          textEditingController.text = authState.mobile;
        }
      },
      builder: (context, authState) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: _formKey,
            child: SafeArea(
              top: false,
              bottom: false,
              child: Scaffold(
                bottomNavigationBar: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Platform.isIOS ? 10 : 5,
                        vertical: Platform.isIOS ? 23 : 10),
                    child: PrimaryElevatedBtn(
                        color: textEditingController.text.length < 9
                            ? colorScheme.secondary
                            : colorScheme.primary,
                        buttonText: language.continueText,
                        onPressed: () async {
                          bool isConnected =
                              await Helpers.checkInternetConnectivity();

                          if (!isConnected) {
                            Helpers.internetDialog(context);
                            return;
                          }

                          if (_formKey.currentState!.validate() == false) {
                            return;
                          }
                          //save default
                          DatabaseService databaseService = serviceLocator.get<DatabaseService>();
                          databaseService.saveToDisk(DatabaseKeys.isLoginTypeIn, AppConstants.TAXI_APP);
                          /// If Internet Connection state is Connected Then Adding Event to [Auth Bloc] to start sign using Mobile
                          context.read<AuthBloc>().add(AuthLoginUsingMobile(
                              mobileNumber: textEditingController.text));
                        }),
                  ),
                ),
                body: SafeArea(
                  top: false,
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(fit: StackFit.expand, children: [
                      SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 16.h,
                                ),
                                Center(child: AppLogo()),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(language.login,
                                    style: textTheme.headline1!
                                        .copyWith(fontSize: 15.sp)),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Text(language.callCar,
                                    style: textTheme.bodyText1!.copyWith(
                                        fontSize: 10.sp,
                                        color: colorScheme.secondary)),
                                SizedBox(
                                  height: 1.h,
                                ),
                                CustomTextField(
                                  focusNode: focusNode,
                                  isHomeScreen: false,
                                  isOther: true,
                                  textInputType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(9),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  suffixIcon:
                                      textEditingController.text.isNotEmpty
                                          ? IconButton(
                                              onPressed: () {
                                                textEditingController.clear();

                                                setState(() {});
                                              },
                                              icon: Icon(Icons.close))
                                          : null,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return ErrorMessages.validPhoneNumber;
                                    } else if (value.length < 9) {
                                      return ErrorMessages.validPhoneNumber;
                                    }
                                    return null;
                                  },
                                  prefixIcon: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.asset(
                                          AssetsPath.phone,
                                          height: 5.h,
                                          width: 4.w,
                                        )
                                      ]),
                                  controller: textEditingController,
                                  hintText: language.phoneNumber,
                                ),
                              ]),
                        ),
                      ),
                    ]),
                  ),
                ),
                backgroundColor: colorScheme.onBackground,
              ),
            ),
          ),
        );
      },
    );
  }
}
