
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
