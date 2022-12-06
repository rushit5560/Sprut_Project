import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:sizer/sizer.dart';
import 'package:sprut/business_logic/blocs/authentication_bloc/auth_bloc/auth_bloc.dart';
import 'package:sprut/business_logic/blocs/authentication_bloc/auth_event/auth_event.dart';
import 'package:sprut/presentation/pages/home_screen/controllers/home_controller.dart';
import 'package:sprut/presentation/pages/home_screen/select_cities/select_cities.dart';
import 'package:sprut/presentation/pages/home_screen/views/map_bottom_sheet_view/map_bottom_sheet.dart';
import 'package:sprut/presentation/widgets/my_drawer/my_drawer.dart';
import 'package:sprut/resources/app_themes/app_themes.dart';
import 'package:sprut/resources/assets_path/assets_path.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../resources/app_constants/app_constants.dart';
import '../../../../resources/configs/helpers/helpers.dart';
import '../../../../resources/configs/service_locator/service_locator.dart';
import '../../../../resources/services/database/database.dart';
import '../../../../resources/services/database/database_keys.dart';
import '../../news/controllers/news_controller.dart';


class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print("herenotificationbackground  ${message}");
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  HomeViewController controller =
      Get.put(HomeViewController(), permanent: true);

  final DatabaseService databaseService = serviceLocator.get<DatabaseService>();

  /// Create a [AndroidNotificationChannel] for heads up notifications
  late AndroidNotificationChannel channel;

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future<void> initializeFCM() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    channel = const AndroidNotificationChannel(
      'sprut_channel_id', // id
      'Sprut Notification', // title
      description: 'This is used for the sprut notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    String? token = await FirebaseMessaging.instance.getToken();
    print("heretoken $token");
    if (token!.isNotEmpty) {
      controller.updateToken(token);
    }

    // const AndroidInitializationSettings initializationSettingsAndroid =
    //     AndroidInitializationSettings('ic_launcher');
    // final IOSInitializationSettings initializationSettingsDarwin =
    //     IOSInitializationSettings(
    //         onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    //
    // final InitializationSettings initializationSettings =
    //     InitializationSettings(
    //         android: initializationSettingsAndroid,
    //         iOS: initializationSettingsDarwin);
    // flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          "herenotification  ${message.data} || ${message.notification} || ${message.notification?.android}");
      // RemoteNotification? notification = message.notification;
      dynamic data = message.data;
      print("herenotification1 $data");
      // AndroidNotification? android = message.notification?.android;
      if (data != null) {
        print("herenotification2");
        flutterLocalNotificationsPlugin.show(
          data.hashCode,
          data["title"],
          data["body"],
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              importance: Importance.max,
              icon: "ic_launcher",
            ),
          ),
        );
      }
    });
  }

  void onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text("$title"),
        content: Text("$body"),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {},
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.databaseService.saveToDisk(DatabaseKeys.isLoginTypeIn, AppConstants.TAXI_APP);
    Future.delayed(Duration(seconds: 5), () async {
      await controller.updateCurrentLocationMarker();
      await controller.updateCurrentLocationMarker();
      controller.update();
    });

    initializeFCM();
  }

  @override
  Widget build(BuildContext context) {
    Helpers.systemStatusBar();

    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return SafeArea(
      top: false,
      bottom: false,
      child: GetBuilder<HomeViewController>(
          builder: (_) => SlidingUpPanel(
                onPanelSlide: (value) {
                  controller.isBottomSheetTapped = true;
                },
                controller: controller.scrollController,
                onPanelOpened: () {
                  controller.whereToGoTapCount += 1;
                  controller.whereToArriveTapCount += 1;
                  controller.closeButtonVisible = true;
                  controller.isBottomSheetExpanded = true;

                  controller.update();

                  if (controller.lastFocus == "whereToGo" &&
                      controller.whereToGoTapCount == 1) {
                    controller.wheretoGoFocusNode.unfocus();
                    Future.delayed(const Duration(milliseconds: 200), () {
                      controller.wheretoGoFocusNode.requestFocus();
                    });
                  }
                },
                onPanelClosed: () {
                  //  controller.whereToAriveEdtingController.clear();
                  controller.wheretoGoController.clear();

                  controller.whereToGoTapCount = 0;
                  controller.whereToArriveTapCount = 0;
                  controller.isBottomSheetTapped = false;
                  controller.isBottomSheetExpanded = false;
                  controller.tappedAriveAddress = "";
                  controller.tappedDestinationAddress = "";

                  // controller.updateWhereToArrive();

                  FocusScope.of(context).unfocus();
                  controller.update();

                  print("hereclosed ${controller.currentCamPosition}");
                  if (controller.currentCamPosition != null) {
                    controller.decodeLocationString(
                        controller.currentCamPosition!.target,
                        fromCenterMarker: true);
                  } else {
                    controller.updateCurrentAddressOnBottomSheetClose();
                  }
                },
                minHeight: _scaffoldKey.currentState != null
                    ? _scaffoldKey.currentState!.isDrawerOpen
                        ? 0
                        : MediaQuery.of(context).size.width * 0.550
                    : MediaQuery.of(context).size.width * 0.550,
                maxHeight: MediaQuery.of(context).size.height,
                panel: MapBottomSheetView(),
                body: Scaffold(
                    resizeToAvoidBottomInset: false,
                    onDrawerChanged: (isOpened) {
                      setState(() {});
                    },
                    onEndDrawerChanged: (isOpened) {
                      setState(() {});
                    },
                    drawer: MyDrawer(
                      isEnable: true,
                    ),
                    key: _scaffoldKey,
                    body: Stack(alignment: Alignment.center, children: [
                      GoogleMap(
                        zoomControlsEnabled: false,
                        markers: Set<Marker>.of(controller.mapMarkers.values),
                        mapType: MapType.normal,

                        onTap: (c) {},
                        initialCameraPosition:
                            controller.initialCameraPosition!,
                        onMapCreated: controller.onMapsCreated,
                        // markers: Set<Marker>.of(value.markers.values),
                        // markers: value.mapMarkers,
                        // markers: value.markersSet,
                        // markers: Set<Marker>.of(controller.mapMarkers.values),
                        onCameraIdle: () {
                          controller.isMapChanged.value = false;
                          controller.update();
                          print('herecurrent ${controller.currentCamPosition}');
                          if (controller.currentCamPosition != null) {
                            controller.decodeLocationString(
                                controller.currentCamPosition!.target,
                                fromCenterMarker: true);
                          }
                        },
                        onCameraMove: (CameraPosition position) {
                          controller.currentCamPosition = position;
                          print('heremove ${controller.mapMarkers.length}');
                          if (controller.mapMarkers.length > 0) {
                            controller.updateControllerCache();
                            controller.isMapChanged.value = true;
                            controller.update();
                          }
                        },
                        // markers: Set.of(Marker),
                      ),
                      controller.isMapLoading == true
                          ? Positioned(
                              top: 0,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: lottie.Lottie.asset(
                                          'assets/images/loading1.json',
                                          height: 10.h),
                                    ),
                                    SizedBox(
                                      height: 37.h,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : SizedBox(),
                      controller.isMapLoading == false
                          ? Align(
                              alignment: Alignment.center,
                              child: Transform.translate(
                                offset: Offset(0, -34),
                                child: Image.asset(
                                  AssetsPath.pointer,
                                  height: 50,
                                ),
                              ),
                            )
                          : SizedBox(),
                      Positioned(
                        top: 10,
                        left: 6,
                        child: SafeArea(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _scaffoldKey.currentState!.openDrawer();
                                },
                                child: Container(
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.menu,
                                          color: Colors.white,
                                          size: 7.w,
                                        ),
                                      ),
                                      if ((databaseService.getFromDisk(
                                                      DatabaseKeys.readNews) ==
                                                  null ||
                                              (databaseService.getFromDisk(
                                                          DatabaseKeys
                                                              .readNews) !=
                                                      null &&
                                                  controller.newsCount >
                                                      databaseService
                                                          .getFromDisk(
                                                              DatabaseKeys
                                                                  .readNews))) &&
                                          controller.newsCount > 0)
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.red,
                                            ),
                                            margin: const EdgeInsets.all(4.0),
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              "${(databaseService.getFromDisk(DatabaseKeys.readNews) != null && controller.newsCount > databaseService.getFromDisk(DatabaseKeys.readNews)) ? (controller.newsCount - databaseService.getFromDisk(DatabaseKeys.readNews)).toInt() : controller.newsCount}",
                                              style:
                                                  textTheme.caption?.copyWith(
                                                color: Colors.white,
                                                fontSize: 10.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  height: 5.h,
                                  width: 5.h,
                                  decoration: BoxDecoration(
                                      color: colorScheme.primary,
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              _scaffoldKey.currentState?.isDrawerOpen == false
                                  ? controller.locationStatusBar(context)
                                  : SizedBox()
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        child: SafeArea(
                          child: GestureDetector(
                            onTap: () {
                              context
                                  .read<AuthBloc>()
                                  .add(AuthAvailableCitiesEvent());
                              showCupertinoModalBottomSheet(
                                expand: false,
                                enableDrag: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                                context: context,
                                builder: (context) =>
                                    SafeArea(child: SelectCities()),
                              );
                            },
                            child: Container(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Obx(() {
                                      return Text(
                                        controller.selectCityName.value ==
                                                "Vinnytsia"
                                            ? language.vinnytsia
                                            : (controller
                                                        .selectCityName.value ==
                                                    "Uman"
                                                ? language.uman
                                                : (controller.selectCityName
                                                            .value ==
                                                        "Haisyn"
                                                    ? language.haisyn
                                                    : controller
                                                        .selectCityName.value)),
                                        style: textTheme.bodyText1!.copyWith(
                                            fontSize: 10.sp,
                                            color: Colors.black),
                                      );
                                    }),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppThemes.dark,
                                      size: 30,
                                    )
                                  ]),
                              decoration: BoxDecoration(
                                  color: colorScheme.primary.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(8)),
                              height: 5.h,
                              width: 27.w,
                            ),
                          ),
                        ),
                      ),
                      //Food delivery
                      if(controller.selectCityName.value == "Vinnytsia")...[
                        Positioned(
                          top: 10,
                          right: 10,
                          child: SafeArea(
                            child: GestureDetector(
                              onTap: () {
                                //change to delivery screen
                                controller.changeScreenStatus(context);
                              },
                              child: Container(
                                child: Image.asset(
                                  AssetsPath.newDeliveryLogo,
                                  // height: 23.h,
                                  filterQuality: FilterQuality.high,
                                  fit: BoxFit.fill,
                                ),
                                decoration: BoxDecoration(
                                  // color:
                                  // colorScheme.primary.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(8),),
                                height: 5.h,
                                width: 27.w,
                              ),
                            ),
                          ),
                        ),
                      ]

                      //End
                      // _scaffoldKey.currentState?.isDrawerOpen == false
                      //     ? Positioned(
                      //         right: 5,
                      //         bottom: Responsive.isSmallMobile(context)
                      //             ? 36.h
                      //             : MediaQuery.of(context).size.width * 0.690,
                      //         child: controller.locationStatusBar(context))
                      //     : SizedBox(),
                    ]),
                    backgroundColor: colorScheme.onBackground),
              )),
    );
  }
}