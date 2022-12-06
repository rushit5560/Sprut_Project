import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/presentation/widgets/primary_elevated_btn/primary_elevated_btn.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprut/resources/configs/helpers/helpers.dart';

import '../../../resources/app_constants/app_constants.dart';

class NoInternetScreen extends StatefulWidget {
  final Function() onPressed;
  NoInternetScreen({required this.onPressed});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  Widget build(BuildContext context) {
    // print("type of:: ${Helpers.isLoginTypeIn()}");
    if(Helpers.isLoginTypeIn() == AppConstants.TAXI_APP){
      Helpers.systemStatusBar();
    }else {
      Helpers.systemStatusBar1();
    }

    var language = AppLocalizations.of(context)!;

    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PrimaryElevatedBtn(
            buttonText: language.tryAgain,
            onPressed: widget.onPressed,
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(language.noInternet,
                    textAlign: TextAlign.center,
                    style: textTheme.headline1!.copyWith(fontSize: 13.sp, color: Helpers.primaryTextColor())),
              )
            ],
          ),
        ),
        backgroundColor: Helpers.primaryBackgroundColor(colorScheme),
      ),
    );
  }
}
