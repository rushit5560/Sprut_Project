import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/business_logic/blocs/authentication_bloc/auth_bloc/auth_bloc.dart';
import 'package:sprut/business_logic/blocs/connection_bloc/connection_bloc.dart';
import 'package:sprut/l10n/l10n.dart';
import 'package:sprut/presentation/pages/splash_screen/splash_screen.dart';
import 'package:sprut/resources/app_themes/app_themes.dart';
import 'package:sprut/resources/configs/routes/routes.dart';
import 'package:sprut/resources/configs/service_locator/service_locator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await setupServiceLocator();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  /// initializing [Get It]
  ///
  // if (defaultTargetPlatform == TargetPlatform.android) {
  //   AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  // }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ConnectedBloc()),
        BlocProvider(create: (context) => AuthBloc()),
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return GetMaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: SplashScreen(),
            debugShowCheckedModeBanner: false,
            routes: Routes.routes,
            theme: AppThemes.primaryMaterialTheme,
            supportedLocales: L10n.all,
          );
        },
      ),
    ),
  );
}

/*class Sprut extends StatefulWidget {
  const Sprut({Key? key}) : super(key: key);

  @override
  State<Sprut> createState() => _SprutState();
}

class _SprutState extends State<Sprut> {
  /// bool for check internet connection state
  bool isConnected = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  Future checkConnectivity() async {
    isConnected = await Helpers.checkInternetConnectivity();
    isLoading = false;
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {});
    });

    return;
  }

  var internetDialog;
  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectedBloc, ConnectedState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, connectionState) {
        if (connectionState is ConnectedFailureState) {
          if (internetDialog == null) {
            internetDialog = showDialog(
                context: context,
                barrierDismissible: false,
                barrierLabel: 'Dialog',
                builder: (context) => NoInternetScreen(onPressed: () async {
                      if (connectionState is ConnectedSucessState) {
                        Navigator.of(context).pop();
                      }
                    })).then((value) => internetDialog = null);
          }
        } else if (connectionState is ConnectedSucessState) {
          if (internetDialog != null) {
            Navigator.of(context).pop();
            internetDialog = null;
          }
        }
      },
      child: isLoading
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              alignment: Alignment.center,
              child: Center(
                child: lottie.Lottie.asset('assets/images/loading1.json',
                    height: 10.h),
              ),
            )
          : (isConnected
              ? (Helpers.isLoggedIn() == false ? LoginScreen() : SplashScreen())
              : BlocBuilder<ConnectedBloc, ConnectedState>(
                  builder: (context, connectionState) {
                  return NoInternetScreen(onPressed: () async {
                    if (isConnected == false) {
                      Navigator.pushNamed(context, Routes.splashScreen);
                    }

                    if (connectionState is ConnectedSucessState) {
                      if (Helpers.isLoggedIn() == false) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, Routes.loginScreen, (route) => false);
                      } else {
                        Navigator.pushNamedAndRemoveUntil(
                            context, Routes.splashScreen, (route) => false);
                      }
                    }
                  });
                })),
    );
    //   return isConnected
    //       ? Helpers.isLoggedIn() == false
    //           ? LoginScreen()
    //           : HomeView()
    //       : (isLoading
    //           ? Container(
    //               width: MediaQuery.of(context).size.width,
    //               height: MediaQuery.of(context).size.height,
    //               color: Colors.white,
    //               alignment: Alignment.center,
    //               child: Center(
    //                 child: lottie.Lottie.asset('assets/images/loading1.json',
    //                     height: 10.h),
    //               ),
    //             )
    //           : BlocConsumer<ConnectedBloc, ConnectedState>(
    //               listener: (context, connectionState) {},
    //               builder: (context, connectionState) {
    //                 return NoInternetScreen(onPressed: () async {
    //                   if (isConnected == false) {
    //                     Navigator.pushNamed(context, Routes.splashScreen);
    //                   }

    //                   if (connectionState is ConnectedSucessState) {
    //                     if (Helpers.isLoggedIn() == false) {
    //                       Navigator.pushNamedAndRemoveUntil(
    //                           context, Routes.loginScreen, (route) => false);
    //                     } else {
    //                       Navigator.pushNamedAndRemoveUntil(
    //                           context, Routes.homeScreen, (route) => false);
    //                     }
    //                   }
    //                 });
    //               },
    //             ));
  }
}*/
