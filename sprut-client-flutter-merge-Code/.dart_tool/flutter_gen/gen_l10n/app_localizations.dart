
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uk.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations returned
/// by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('uk')
  ];

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @callCar.
  ///
  /// In en, this message translates to:
  /// **'To call a car, enter your valid phone number'**
  String get callCar;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Count not connected to server\nPlease check your internet\nconnection!'**
  String get networkError;

  /// No description provided for @smsConfirm.
  ///
  /// In en, this message translates to:
  /// **'An SMS with a confirmation code has been sent to your phone number'**
  String get smsConfirm;

  /// No description provided for @enterCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter the code'**
  String get enterCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code ?'**
  String get resendCode;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'Can\'t connected to internet\nPlease check your network settings!'**
  String get noInternet;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'Cities'**
  String get city;

  /// No description provided for @whereLive.
  ///
  /// In en, this message translates to:
  /// **'Select the city where you live:'**
  String get whereLive;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to'**
  String get welcome;

  /// No description provided for @welcomeHeadline.
  ///
  /// In en, this message translates to:
  /// **'Safe high quality comfortable'**
  String get welcomeHeadline;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @issueWithVerification.
  ///
  /// In en, this message translates to:
  /// **'Having issues with receiving\nverification code?'**
  String get issueWithVerification;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @changeMobile.
  ///
  /// In en, this message translates to:
  /// **'Change phone number'**
  String get changeMobile;

  /// No description provided for @notReceiveSms.
  ///
  /// In en, this message translates to:
  /// **'Not received an SMS'**
  String get notReceiveSms;

  /// No description provided for @verification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verification;

  /// No description provided for @whereToArrive.
  ///
  /// In en, this message translates to:
  /// **'Where to arrive?'**
  String get whereToArrive;

  /// No description provided for @whereToGo.
  ///
  /// In en, this message translates to:
  /// **'Where to go?'**
  String get whereToGo;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// No description provided for @lastTrip.
  ///
  /// In en, this message translates to:
  /// **'Last trip'**
  String get lastTrip;

  /// No description provided for @turnOnGPSMessage.
  ///
  /// In en, this message translates to:
  /// **'Turn on GPS for automatic determination of your location'**
  String get turnOnGPSMessage;

  /// No description provided for @myLocation.
  ///
  /// In en, this message translates to:
  /// **'My Location'**
  String get myLocation;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @orderHistory.
  ///
  /// In en, this message translates to:
  /// **'Order history'**
  String get orderHistory;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get setting;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @news.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// No description provided for @becomeDriver.
  ///
  /// In en, this message translates to:
  /// **'To become a driver'**
  String get becomeDriver;

  /// No description provided for @toMakeMoney.
  ///
  /// In en, this message translates to:
  /// **'Make money at the time that is convenient for you'**
  String get toMakeMoney;

  /// No description provided for @startSearchCar.
  ///
  /// In en, this message translates to:
  /// **'Start searching for a car or swipe up to change the car class'**
  String get startSearchCar;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @findACar.
  ///
  /// In en, this message translates to:
  /// **'Find a car'**
  String get findACar;

  /// No description provided for @preOrder.
  ///
  /// In en, this message translates to:
  /// **'Preorder'**
  String get preOrder;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @withRate.
  ///
  /// In en, this message translates to:
  /// **'With these rates the average time to get a car is 5 minutes'**
  String get withRate;

  /// No description provided for @minOrderAmount.
  ///
  /// In en, this message translates to:
  /// **'The minimum order amount is:'**
  String get minOrderAmount;

  /// No description provided for @homeAddress.
  ///
  /// In en, this message translates to:
  /// **'Home Address'**
  String get homeAddress;

  /// No description provided for @workAddress.
  ///
  /// In en, this message translates to:
  /// **'Work Address'**
  String get workAddress;

  /// No description provided for @enterHomeLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter home location:'**
  String get enterHomeLocation;

  /// No description provided for @enterWorkLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter work location:'**
  String get enterWorkLocation;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get min;

  /// No description provided for @minimumu_cost.
  ///
  /// In en, this message translates to:
  /// **'Minimum cost:'**
  String get minimumu_cost;

  /// No description provided for @price_for_km.
  ///
  /// In en, this message translates to:
  /// **'Price for km:'**
  String get price_for_km;

  /// No description provided for @downtime.
  ///
  /// In en, this message translates to:
  /// **'Downtime:'**
  String get downtime;

  /// No description provided for @no_of_seats.
  ///
  /// In en, this message translates to:
  /// **'Number of seats:'**
  String get no_of_seats;

  /// No description provided for @minimum_price_order.
  ///
  /// In en, this message translates to:
  /// **'The minimum price of the order may change, if you choose additional services to the order'**
  String get minimum_price_order;

  /// No description provided for @got_it.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get got_it;

  /// No description provided for @vinnytsia.
  ///
  /// In en, this message translates to:
  /// **'Vinnytsia'**
  String get vinnytsia;

  /// No description provided for @uman.
  ///
  /// In en, this message translates to:
  /// **'Uman'**
  String get uman;

  /// No description provided for @haisyn.
  ///
  /// In en, this message translates to:
  /// **'Haisyn'**
  String get haisyn;

  /// No description provided for @payment_title.
  ///
  /// In en, this message translates to:
  /// **'Payment methods'**
  String get payment_title;

  /// No description provided for @payment_desc.
  ///
  /// In en, this message translates to:
  /// **'What type of payment do you want to pay for the ride?'**
  String get payment_desc;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @add_card.
  ///
  /// In en, this message translates to:
  /// **'Add Card'**
  String get add_card;

  /// No description provided for @card.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// No description provided for @replenish.
  ///
  /// In en, this message translates to:
  /// **'Replenish'**
  String get replenish;

  /// No description provided for @service_title.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get service_title;

  /// No description provided for @service_desc.
  ///
  /// In en, this message translates to:
  /// **'What additional services do you need?'**
  String get service_desc;

  /// No description provided for @comment_title.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment_title;

  /// No description provided for @comment_desc.
  ///
  /// In en, this message translates to:
  /// **'Write a comment for the driver:'**
  String get comment_desc;

  /// No description provided for @comment_hint.
  ///
  /// In en, this message translates to:
  /// **'Start writing a comment'**
  String get comment_hint;

  /// No description provided for @comment_1.
  ///
  /// In en, this message translates to:
  /// **'I am near'**
  String get comment_1;

  /// No description provided for @comment_2.
  ///
  /// In en, this message translates to:
  /// **'Entrance number'**
  String get comment_2;

  /// No description provided for @comment_3.
  ///
  /// In en, this message translates to:
  /// **'Please call me back'**
  String get comment_3;

  /// No description provided for @comment_4.
  ///
  /// In en, this message translates to:
  /// **'Come in from the side of the'**
  String get comment_4;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// No description provided for @replenish_balance.
  ///
  /// In en, this message translates to:
  /// **'Replenish Balance'**
  String get replenish_balance;

  /// No description provided for @enter_add_amount.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount you want to fund your account'**
  String get enter_add_amount;

  /// No description provided for @other_amount.
  ///
  /// In en, this message translates to:
  /// **'Інша\nсума'**
  String get other_amount;

  /// No description provided for @confirm_button.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm_button;

  /// No description provided for @preorder_title.
  ///
  /// In en, this message translates to:
  /// **'Pre-order'**
  String get preorder_title;

  /// No description provided for @preorder_desc.
  ///
  /// In en, this message translates to:
  /// **'Select a time of 30 minutes more from this point, otherwise the order will be created for \"Now\":'**
  String get preorder_desc;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @searching_driver.
  ///
  /// In en, this message translates to:
  /// **'Searching for a driver '**
  String get searching_driver;

  /// No description provided for @arriving_driver.
  ///
  /// In en, this message translates to:
  /// **' will arrive at '**
  String get arriving_driver;

  /// No description provided for @waiting_driver.
  ///
  /// In en, this message translates to:
  /// **' is waiting for you '**
  String get waiting_driver;

  /// No description provided for @in_ride.
  ///
  /// In en, this message translates to:
  /// **'In ride'**
  String get in_ride;

  /// No description provided for @how_was_trip.
  ///
  /// In en, this message translates to:
  /// **'How was your trip?'**
  String get how_was_trip;

  /// No description provided for @your_trip_was.
  ///
  /// In en, this message translates to:
  /// **'Your trip was'**
  String get your_trip_was;

  /// No description provided for @for_payment.
  ///
  /// In en, this message translates to:
  /// **'For paymant:'**
  String get for_payment;

  /// No description provided for @ride_time.
  ///
  /// In en, this message translates to:
  /// **'Ride time:'**
  String get ride_time;

  /// No description provided for @route_length.
  ///
  /// In en, this message translates to:
  /// **'Route length:'**
  String get route_length;

  /// No description provided for @route_unit.
  ///
  /// In en, this message translates to:
  /// **'Km'**
  String get route_unit;

  /// No description provided for @cancel_trip_msg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel your trip?'**
  String get cancel_trip_msg;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @too_bad.
  ///
  /// In en, this message translates to:
  /// **'Too bad'**
  String get too_bad;

  /// No description provided for @bad.
  ///
  /// In en, this message translates to:
  /// **'Bad'**
  String get bad;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent;

  /// No description provided for @tip_for_the_driver.
  ///
  /// In en, this message translates to:
  /// **'Tip for the driver'**
  String get tip_for_the_driver;

  /// No description provided for @what_didnt_like.
  ///
  /// In en, this message translates to:
  /// **'What didn\'t you like?'**
  String get what_didnt_like;

  /// No description provided for @select_problem.
  ///
  /// In en, this message translates to:
  /// **'Select the problem you need or leave a comment:'**
  String get select_problem;

  /// No description provided for @traffic_offence.
  ///
  /// In en, this message translates to:
  /// **'Traffic offence'**
  String get traffic_offence;

  /// No description provided for @dirty_salon.
  ///
  /// In en, this message translates to:
  /// **'Dirty salon'**
  String get dirty_salon;

  /// No description provided for @ruffled_driver.
  ///
  /// In en, this message translates to:
  /// **'Ruffled driver'**
  String get ruffled_driver;

  /// No description provided for @write_personal_comment.
  ///
  /// In en, this message translates to:
  /// **'Write a personal comment:'**
  String get write_personal_comment;

  /// No description provided for @personal_comment_hint.
  ///
  /// In en, this message translates to:
  /// **'The driver scolded me because he thought I slammed the doors!'**
  String get personal_comment_hint;

  /// No description provided for @about_us.
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get about_us;

  /// No description provided for @basic_info.
  ///
  /// In en, this message translates to:
  /// **'Basic information'**
  String get basic_info;

  /// No description provided for @go_to_sprut.
  ///
  /// In en, this message translates to:
  /// **'Go to sprut.ua'**
  String get go_to_sprut;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacy_policy;

  /// No description provided for @email_contact.
  ///
  /// In en, this message translates to:
  /// **'E-mail contacts@sprut.ua'**
  String get email_contact;

  /// No description provided for @call_us.
  ///
  /// In en, this message translates to:
  /// **'Call us'**
  String get call_us;

  /// No description provided for @social_network.
  ///
  /// In en, this message translates to:
  /// **'Social networks'**
  String get social_network;

  /// No description provided for @facebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get facebook;

  /// No description provided for @instagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get instagram;

  /// No description provided for @sprut_version.
  ///
  /// In en, this message translates to:
  /// **'Sprut v1.0'**
  String get sprut_version;

  /// No description provided for @goto_sprut_url.
  ///
  /// In en, this message translates to:
  /// **'https://sprut.ua/'**
  String get goto_sprut_url;

  /// No description provided for @privacy_policy_url.
  ///
  /// In en, this message translates to:
  /// **'https://sprut.ua/legal/privacy'**
  String get privacy_policy_url;

  /// No description provided for @facebook_url.
  ///
  /// In en, this message translates to:
  /// **'https://www.facebook.com/sprut.mobi/'**
  String get facebook_url;

  /// No description provided for @instagram_url.
  ///
  /// In en, this message translates to:
  /// **'https://www.instagram.com/sprut_ua/'**
  String get instagram_url;

  /// No description provided for @email_subject.
  ///
  /// In en, this message translates to:
  /// **'Feedback on Sprut'**
  String get email_subject;

  /// No description provided for @found_driver_1.
  ///
  /// In en, this message translates to:
  /// **'We\'ve found a driver for you'**
  String get found_driver_1;

  /// No description provided for @found_driver_2.
  ///
  /// In en, this message translates to:
  /// **'driving'**
  String get found_driver_2;

  /// No description provided for @found_driver_3.
  ///
  /// In en, this message translates to:
  /// **'and will come'**
  String get found_driver_3;

  /// No description provided for @arrive_driver_1.
  ///
  /// In en, this message translates to:
  /// **'Your driver arrived'**
  String get arrive_driver_1;

  /// No description provided for @arrive_driver_2.
  ///
  /// In en, this message translates to:
  /// **'arrived on'**
  String get arrive_driver_2;

  /// No description provided for @arrive_driver_3.
  ///
  /// In en, this message translates to:
  /// **'and waiting for you'**
  String get arrive_driver_3;

  /// No description provided for @cancel_driver_1.
  ///
  /// In en, this message translates to:
  /// **'Search was cancelled'**
  String get cancel_driver_1;

  /// No description provided for @cancel_driver_2.
  ///
  /// In en, this message translates to:
  /// **'I\'m sorry, but the driver canceled your order. Search again and we will find a car for you!'**
  String get cancel_driver_2;

  /// No description provided for @favourite_addresses.
  ///
  /// In en, this message translates to:
  /// **'Favourite addresses'**
  String get favourite_addresses;

  /// No description provided for @main_settings.
  ///
  /// In en, this message translates to:
  /// **'Main settings'**
  String get main_settings;

  /// No description provided for @remind_about_preorder.
  ///
  /// In en, this message translates to:
  /// **'Remind about pre-order'**
  String get remind_about_preorder;

  /// No description provided for @your_city.
  ///
  /// In en, this message translates to:
  /// **'Your city'**
  String get your_city;

  /// No description provided for @default_fare.
  ///
  /// In en, this message translates to:
  /// **'Default fare'**
  String get default_fare;

  /// No description provided for @improve_maps.
  ///
  /// In en, this message translates to:
  /// **'Improve maps'**
  String get improve_maps;

  /// No description provided for @improve_sprut.
  ///
  /// In en, this message translates to:
  /// **'Improve Sprut'**
  String get improve_sprut;

  /// No description provided for @setting_desc.
  ///
  /// In en, this message translates to:
  /// **'The maps use mapbox technology and OpenStreetMap data. You can leave your comments and suggestions on the Mapbox website.\n\nHelp Sprut improve the service by enabling automatic sending of diagnostic and usage data.'**
  String get setting_desc;

  /// No description provided for @rate_title.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate_title;

  /// No description provided for @rate_desc.
  ///
  /// In en, this message translates to:
  /// **'Choose your favorite tariff'**
  String get rate_desc;

  /// No description provided for @reminder_title.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminder_title;

  /// No description provided for @reminder_desc.
  ///
  /// In en, this message translates to:
  /// **'Reminder of your pre-order'**
  String get reminder_desc;

  /// No description provided for @preorder_1.
  ///
  /// In en, this message translates to:
  /// **'For 10 min'**
  String get preorder_1;

  /// No description provided for @preorder_2.
  ///
  /// In en, this message translates to:
  /// **'For 15 min'**
  String get preorder_2;

  /// No description provided for @preorder_3.
  ///
  /// In en, this message translates to:
  /// **'For 20 min'**
  String get preorder_3;

  /// No description provided for @preorder_4.
  ///
  /// In en, this message translates to:
  /// **'For 25 min'**
  String get preorder_4;

  /// No description provided for @your_trips.
  ///
  /// In en, this message translates to:
  /// **'Your trips'**
  String get your_trips;

  /// No description provided for @route.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get route;

  /// No description provided for @completed_trip.
  ///
  /// In en, this message translates to:
  /// **'Completed Trip'**
  String get completed_trip;

  /// No description provided for @cancelled_trip.
  ///
  /// In en, this message translates to:
  /// **'Cancelled Trip'**
  String get cancelled_trip;

  /// No description provided for @payment_type.
  ///
  /// In en, this message translates to:
  /// **'Payment Type'**
  String get payment_type;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @repeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeat;

  /// No description provided for @min_add_amount.
  ///
  /// In en, this message translates to:
  /// **'Amount should be greater than 15'**
  String get min_add_amount;

  /// No description provided for @choose_city_title.
  ///
  /// In en, this message translates to:
  /// **'Cities'**
  String get choose_city_title;

  /// No description provided for @choose_city_desc.
  ///
  /// In en, this message translates to:
  /// **'Select the city where you live:'**
  String get choose_city_desc;

  /// No description provided for @choose_city_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get choose_city_confirm;

  /// No description provided for @order_a_taxi.
  ///
  /// In en, this message translates to:
  /// **'Order a taxi'**
  String get order_a_taxi;

  /// No description provided for @order_a_delivery.
  ///
  /// In en, this message translates to:
  /// **'Order a delivery'**
  String get order_a_delivery;

  /// No description provided for @where_to_deliver.
  ///
  /// In en, this message translates to:
  /// **'Where to deliver?'**
  String get where_to_deliver;

  /// No description provided for @select_address_or_turn_on_gps.
  ///
  /// In en, this message translates to:
  /// **'Choose an address or turn on GPS'**
  String get select_address_or_turn_on_gps;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search;

  /// No description provided for @your_orders.
  ///
  /// In en, this message translates to:
  /// **'Your orders'**
  String get your_orders;

  /// No description provided for @what_a_cash_back.
  ///
  /// In en, this message translates to:
  /// **'What is cashback?'**
  String get what_a_cash_back;

  /// No description provided for @cashBackInfoMessage.
  ///
  /// In en, this message translates to:
  /// **'Cashback is an opportunity to return % of the order price to your balance. The balance is used to pay for all services and orders in the app.'**
  String get cashBackInfoMessage;

  /// No description provided for @entrance_number_apartment_number_floor.
  ///
  /// In en, this message translates to:
  /// **'Entrance number/Apartment number/Floor/Door code'**
  String get entrance_number_apartment_number_floor;

  /// No description provided for @hint_text_of_address.
  ///
  /// In en, this message translates to:
  /// **'Floor, door and other details...'**
  String get hint_text_of_address;

  /// No description provided for @error_of_no_found_establishment.
  ///
  /// In en, this message translates to:
  /// **'Sorry, we didn\'t find any products that match'**
  String get error_of_no_found_establishment;

  /// No description provided for @view_cart.
  ///
  /// In en, this message translates to:
  /// **'View Cart'**
  String get view_cart;

  /// No description provided for @add_cart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get add_cart;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get items;

  /// No description provided for @no_stay.
  ///
  /// In en, this message translates to:
  /// **'No, stay'**
  String get no_stay;

  /// No description provided for @yes_close.
  ///
  /// In en, this message translates to:
  /// **'Yes, close'**
  String get yes_close;

  /// No description provided for @leaveEstablishmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave this establishment?'**
  String get leaveEstablishmentTitle;

  /// No description provided for @leaveEstablishmentMessage.
  ///
  /// In en, this message translates to:
  /// **'If you exit now, you will lose all the products you have selected. Do you really want to leave?'**
  String get leaveEstablishmentMessage;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @gram.
  ///
  /// In en, this message translates to:
  /// **'g'**
  String get gram;

  /// No description provided for @okay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get okay;

  /// No description provided for @cart_lower_than_minimum_title.
  ///
  /// In en, this message translates to:
  /// **'The minimum order amount is '**
  String get cart_lower_than_minimum_title;

  /// No description provided for @cart_lower_than_minimum_subtitle.
  ///
  /// In en, this message translates to:
  /// **'.\nIf the amount in the cart is less - you will still pay '**
  String get cart_lower_than_minimum_subtitle;

  /// No description provided for @choose_payment_method.
  ///
  /// In en, this message translates to:
  /// **'Choose payment method'**
  String get choose_payment_method;

  /// No description provided for @remove_card_alert_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove card?'**
  String get remove_card_alert_message;

  /// No description provided for @empty_payment_method_selection_message.
  ///
  /// In en, this message translates to:
  /// **'To complete the order, you must select the type of payment'**
  String get empty_payment_method_selection_message;

  /// No description provided for @balance_amount_alert_message.
  ///
  /// In en, this message translates to:
  /// **'To complete the order, you must top up your balance'**
  String get balance_amount_alert_message;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @top_up.
  ///
  /// In en, this message translates to:
  /// **'Top up'**
  String get top_up;

  /// No description provided for @order_processing_title_message.
  ///
  /// In en, this message translates to:
  /// **'We are processing your order. Please wait a minute \n'**
  String get order_processing_title_message;

  /// No description provided for @order_processing_sub_message.
  ///
  /// In en, this message translates to:
  /// **'\nYour order will be ready soon '**
  String get order_processing_sub_message;

  /// No description provided for @simple_search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get simple_search;

  /// No description provided for @empty_find_establishment_search.
  ///
  /// In en, this message translates to:
  /// **'Sorry, we couldn\'t find any establishments with a similar'**
  String get empty_find_establishment_search;

  /// No description provided for @empty_find_products_search.
  ///
  /// In en, this message translates to:
  /// **'Sorry, we did not find any products with a similar'**
  String get empty_find_products_search;

  /// No description provided for @empty_find_establishment_search1.
  ///
  /// In en, this message translates to:
  /// **'\nYou can change the value and try again.'**
  String get empty_find_establishment_search1;

  /// No description provided for @placeholder_message_of_search.
  ///
  /// In en, this message translates to:
  /// **'Please enter the name of the establishment'**
  String get placeholder_message_of_search;

  /// No description provided for @placeholder_message_of_product_search.
  ///
  /// In en, this message translates to:
  /// **'Please enter the product name'**
  String get placeholder_message_of_product_search;

  /// No description provided for @selected_item.
  ///
  /// In en, this message translates to:
  /// **'Selected Items:'**
  String get selected_item;

  /// No description provided for @number_appliances.
  ///
  /// In en, this message translates to:
  /// **'Specify the number of appliances'**
  String get number_appliances;

  /// No description provided for @delivery_times.
  ///
  /// In en, this message translates to:
  /// **'Your delivery time'**
  String get delivery_times;

  /// No description provided for @your_address.
  ///
  /// In en, this message translates to:
  /// **'Your address'**
  String get your_address;

  /// No description provided for @note_to_restaurant.
  ///
  /// In en, this message translates to:
  /// **'Note to Restaurant'**
  String get note_to_restaurant;

  /// No description provided for @placeholder_note_of_restaurant.
  ///
  /// In en, this message translates to:
  /// **'(Foods that you are allergic to, extra sauces e.g)'**
  String get placeholder_note_of_restaurant;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products:'**
  String get products;

  /// No description provided for @prices.
  ///
  /// In en, this message translates to:
  /// **'Price:'**
  String get prices;

  /// No description provided for @cashback.
  ///
  /// In en, this message translates to:
  /// **'Cashback'**
  String get cashback;

  /// No description provided for @shipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping:'**
  String get shipping;

  /// No description provided for @free_shipping.
  ///
  /// In en, this message translates to:
  /// **'Free shipping is not enough:'**
  String get free_shipping;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total:'**
  String get total;

  /// No description provided for @order_payment.
  ///
  /// In en, this message translates to:
  /// **'Order payment'**
  String get order_payment;

  /// No description provided for @order_in.
  ///
  /// In en, this message translates to:
  /// **'Order in'**
  String get order_in;

  /// No description provided for @order_date.
  ///
  /// In en, this message translates to:
  /// **'Order Date:'**
  String get order_date;

  /// No description provided for @confirm_order.
  ///
  /// In en, this message translates to:
  /// **'Confirm the order'**
  String get confirm_order;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @remove_item_alert_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this product from your cart?'**
  String get remove_item_alert_message;

  /// No description provided for @yes_delete.
  ///
  /// In en, this message translates to:
  /// **'Yes, delete'**
  String get yes_delete;

  /// No description provided for @currency_symbol.
  ///
  /// In en, this message translates to:
  /// **'₴'**
  String get currency_symbol;

  /// No description provided for @minimum_delivery_order_placeholder_message.
  ///
  /// In en, this message translates to:
  /// **'Delivery for orders worth at least '**
  String get minimum_delivery_order_placeholder_message;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @symbol_km.
  ///
  /// In en, this message translates to:
  /// **'KM'**
  String get symbol_km;

  /// No description provided for @symbol_min.
  ///
  /// In en, this message translates to:
  /// **'MIN'**
  String get symbol_min;

  /// No description provided for @payment_methods.
  ///
  /// In en, this message translates to:
  /// **'Payment methods:'**
  String get payment_methods;

  /// No description provided for @order_cancel_title_message.
  ///
  /// In en, this message translates to:
  /// **'The establishment canceled the order on the following occasion:\n'**
  String get order_cancel_title_message;

  /// No description provided for @order_cancel_message_remove_cart.
  ///
  /// In en, this message translates to:
  /// **'\nPlease remove it from your shopping cart and try again.'**
  String get order_cancel_message_remove_cart;

  /// No description provided for @order_payment_made_title.
  ///
  /// In en, this message translates to:
  /// **'Payment is made\n'**
  String get order_payment_made_title;

  /// No description provided for @order_payment_made_message.
  ///
  /// In en, this message translates to:
  /// **'\nPlease wait a moment'**
  String get order_payment_made_message;

  /// No description provided for @order_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Order confirmed\n'**
  String get order_confirm_title;

  /// No description provided for @order_confirm_message.
  ///
  /// In en, this message translates to:
  /// **'\nYour order will be ready soon'**
  String get order_confirm_message;

  /// No description provided for @check_order.
  ///
  /// In en, this message translates to:
  /// **'Check order'**
  String get check_order;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @order_payment_failed_title.
  ///
  /// In en, this message translates to:
  /// **'Failed to complete payment\n'**
  String get order_payment_failed_title;

  /// No description provided for @order_payment_failed_message.
  ///
  /// In en, this message translates to:
  /// **'\nPlease try again or change your payment method'**
  String get order_payment_failed_message;

  /// No description provided for @change_payment_method.
  ///
  /// In en, this message translates to:
  /// **'Change payment method'**
  String get change_payment_method;

  /// No description provided for @back_to_payment.
  ///
  /// In en, this message translates to:
  /// **'Back to payment'**
  String get back_to_payment;

  /// No description provided for @call_window_title_message.
  ///
  /// In en, this message translates to:
  /// **'Allow Sprut to make and manage phone calls?'**
  String get call_window_title_message;

  /// No description provided for @call_allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get call_allow;

  /// No description provided for @call_deny.
  ///
  /// In en, this message translates to:
  /// **'Deny'**
  String get call_deny;

  /// No description provided for @order_cancel_message.
  ///
  /// In en, this message translates to:
  /// **'Your order has been successfully canceled'**
  String get order_cancel_message;

  /// No description provided for @delivery_information.
  ///
  /// In en, this message translates to:
  /// **'Delivery information'**
  String get delivery_information;

  /// No description provided for @order_information.
  ///
  /// In en, this message translates to:
  /// **'Order information'**
  String get order_information;

  /// No description provided for @delivery_from.
  ///
  /// In en, this message translates to:
  /// **'Delivery from'**
  String get delivery_from;

  /// No description provided for @estimated_delivery_time.
  ///
  /// In en, this message translates to:
  /// **'Estimated delivery time'**
  String get estimated_delivery_time;

  /// No description provided for @delivery_completed_comment_alert_message.
  ///
  /// In en, this message translates to:
  /// **'Do you have any comments on the composition of the package that was delivered?'**
  String get delivery_completed_comment_alert_message;

  /// No description provided for @please_select_one_option.
  ///
  /// In en, this message translates to:
  /// **'Please select one option.'**
  String get please_select_one_option;

  /// No description provided for @button_yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get button_yes;

  /// No description provided for @button_no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get button_no;

  /// No description provided for @button_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get button_close;

  /// No description provided for @to_bad.
  ///
  /// In en, this message translates to:
  /// **'To bad'**
  String get to_bad;

  /// No description provided for @to_medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get to_medium;

  /// No description provided for @to_good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get to_good;

  /// No description provided for @to_excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get to_excellent;

  /// No description provided for @txt_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get txt_back;

  /// No description provided for @enter_your_product_name.
  ///
  /// In en, this message translates to:
  /// **'Enter your product name'**
  String get enter_your_product_name;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get chat;

  /// No description provided for @support_message.
  ///
  /// In en, this message translates to:
  /// **'Your order has started to be so we can\'t just cancel it :(\n\nThe order will not be refunded. Think carefully before canceling this order. For details, you can contact our call center for support'**
  String get support_message;

  /// No description provided for @support_sub_message.
  ///
  /// In en, this message translates to:
  /// **' so we can\'t just cancel it :(\nThe order will not be refunded. Think carefully before canceling this order. For details, you can contact our call center for support'**
  String get support_sub_message;

  /// No description provided for @order_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get order_cancel;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @order_cancel_request_message.
  ///
  /// In en, this message translates to:
  /// **'Are u sure you want to cancel the order?'**
  String get order_cancel_request_message;

  /// No description provided for @no_order_message.
  ///
  /// In en, this message translates to:
  /// **'You have not ordered anything yet'**
  String get no_order_message;

  /// No description provided for @working_hours.
  ///
  /// In en, this message translates to:
  /// **'Working hours:'**
  String get working_hours;

  /// No description provided for @establishment_close_message.
  ///
  /// In en, this message translates to:
  /// **'Sorry, the establishment is already closed'**
  String get establishment_close_message;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @establishment_close_air_alarm_message.
  ///
  /// In en, this message translates to:
  /// **'Sorry, the establishment is closed during the air alarm. You necessary wait for the cancellation of the air alarm alert'**
  String get establishment_close_air_alarm_message;

  /// No description provided for @out_of_stock.
  ///
  /// In en, this message translates to:
  /// **'Out of Stocks'**
  String get out_of_stock;

  /// No description provided for @call_a_cab.
  ///
  /// In en, this message translates to:
  /// **'Call a cab'**
  String get call_a_cab;

  /// No description provided for @product_not_available.
  ///
  /// In en, this message translates to:
  /// **'The product is not available:'**
  String get product_not_available;

  /// No description provided for @welcome_screen_message.
  ///
  /// In en, this message translates to:
  /// **'Select a service that will always be\n displayed when you open the application'**
  String get welcome_screen_message;

  /// No description provided for @txt_taxi.
  ///
  /// In en, this message translates to:
  /// **'Taxi'**
  String get txt_taxi;

  /// No description provided for @txt_delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get txt_delivery;

  /// No description provided for @txt_order_preparing.
  ///
  /// In en, this message translates to:
  /// **'Order Preparing'**
  String get txt_order_preparing;

  /// No description provided for @txt_order_packing.
  ///
  /// In en, this message translates to:
  /// **'Order is Packing'**
  String get txt_order_packing;

  /// No description provided for @txt_order_delivered.
  ///
  /// In en, this message translates to:
  /// **'Order Delivered'**
  String get txt_order_delivered;

  /// No description provided for @txt_order_courier_on_the_way.
  ///
  /// In en, this message translates to:
  /// **'Courier on the way'**
  String get txt_order_courier_on_the_way;

  /// No description provided for @txt_order_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Order Cancelled'**
  String get txt_order_cancelled;

  /// No description provided for @today_at.
  ///
  /// In en, this message translates to:
  /// **'Today at'**
  String get today_at;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ru', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ru': return AppLocalizationsRu();
    case 'uk': return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
