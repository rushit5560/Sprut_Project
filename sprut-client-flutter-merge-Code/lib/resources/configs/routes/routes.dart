import 'package:flutter/material.dart';
import 'package:sprut/presentation/pages/about_us/views/about_us_view.dart';
import 'package:sprut/presentation/pages/news/views/news_view.dart';
import 'package:sprut/presentation/pages/order_history/views/order_history_view.dart';
import 'package:sprut/presentation/pages/settings/views/settings_view.dart';

import '../../../presentation/pages/authentication/city_login_screen/city_login_screen.dart';
import '../../../presentation/pages/authentication/login/login_screen.dart';
import '../../../presentation/pages/authentication/otp_verification/otp_verification.dart';
import '../../../presentation/pages/choose_on_map/views/choose_on_map_view.dart';
import '../../../presentation/pages/delivery_home/delivery_home_view.dart';
import '../../../presentation/pages/delivery_home/views/establishment_details_view/establishment_details_screen.dart';
import '../../../presentation/pages/delivery_home/views/establishment_details_view/product_details/product_item_details_screen.dart';
import '../../../presentation/pages/delivery_home/views/establishment_search_view/establishment_search_view.dart';
import '../../../presentation/pages/delivery_home/views/food_search_address/search_bottom_sheet.dart';
import '../../../presentation/pages/delivery_home/views/items_list_screen.dart';
import '../../../presentation/pages/delivery_home/views/product_search_view/product_search_view.dart';
import '../../../presentation/pages/delivery_home/views/shopping_cart_view/shopping_cart_view.dart';
import '../../../presentation/pages/home_screen/select_cities/select_cities.dart';
import '../../../presentation/pages/home_screen/views/add_addresses_views/add_home_address_view.dart';
import '../../../presentation/pages/home_screen/views/add_addresses_views/add_work_address_view.dart';
import '../../../presentation/pages/home_screen/views/address_suggestion_view/address_suggestion_view.dart';
import '../../../presentation/pages/home_screen/views/home_view.dart';
import '../../../presentation/pages/order_screen/views/completed_order/order_completed_screen.dart';
import '../../../presentation/pages/order_screen/views/order_cancellation_view.dart';
import '../../../presentation/pages/order_screen/views/order_detail_view.dart';
import '../../../presentation/pages/order_screen/views/order_map_view.dart';
import '../../../presentation/pages/order_screen/views/order_view.dart';
import '../../../presentation/pages/payment_screen/views/payment_view.dart';
import '../../../presentation/pages/search_screen/views/search_view.dart';
import '../../../presentation/pages/search_screen/views/search_view_old.dart';
import '../../../presentation/pages/splash_screen/splash_screen.dart';
import '../../../presentation/pages/tariff_screen/views/tariff_view.dart';
import '../../../presentation/pages/welcome_screen/welcome_screen.dart';

class Routes {
  Routes._privateConstructor();

  static const String homeScreen = "/homeScreen";
  static const String loginScreen = "/loginScreen";
  static const String otpVerificationScreen = "/otpVerificationScreen";
  static const String cityLogin = "/cityLogin";
  static const String welcomeScreen = "/welcomeScreen";
  static const String splashScreen = "/splashScreen";
  static const String addWorkAddress = "/addWorkAddress";
  static const String addHomeAddress = "/addHomeAddress";
  static const String selectCities = "/selectCities";
  static const String chooseOnMap = "/chooseOnMap";
  static const String addressSuggestionsView = "/addressSuggestionsView";
  static const String tarrifSelectionView = "/tarrifSelected";
  static const String paymentView = "/payment";
  static const String searchView = "/search";
  static const String aboutUsView = "/aboutUs";
  static const String settingsView = "/settings";
  static const String orderHistoryView = "/orderHistory";
  static const String newsView = "/news";

  //Food Delivery Screen
  static const String orderView = "/order";
  static const String orderDetailsView = "/orderDetails";
  static const String orderCancelDetailsView = "/orderCancelDetails";

  static const String foodHomeScreen = "/foodHomeScreen";
  static const String foodDeliveryItemsScreen = "/foodDeliveryItemsScreen";
  static const String foodDeliveryAddressView = "/foodDeliveryAddressView";
  static const String foodDeliveryEstablishmentDetailsView =
      "/foodDeliveryEstablishmentDetailsView";
  static const String foodDeliveryProductItemDetailsView =
      "/foodDeliveryProductItemDetailsView";
  static const String foodDeliveryShoppingCartView =
      "/foodDeliveryShoppingCartView";
  static const String foodEstablishmentSearchView =
      "/foodEstablishmentSearchView";
  static const String foodProductsSearchView = "/foodProductsSearchView";
  static const String orderMapView = "/orderMapView";
  static const String orderCompletedScreen = "/orderCompletedScreen";

  static Map<String, Widget Function(BuildContext)> routes =
      <String, WidgetBuilder>{
    homeScreen: (_) => HomeView(),
    loginScreen: (_) => LoginScreen(),
    otpVerificationScreen: (_) => OtpVerificationScreen(),
    cityLogin: (_) => CityLogin(),
    welcomeScreen: (_) => WelcomeScreen(),
    splashScreen: (_) => SplashScreen(),
    addHomeAddress: (_) => AddHomeAddress(),
    addWorkAddress: (_) => AddWorkAddress(),
    selectCities: (_) => SelectCities(),
    chooseOnMap: (_) => ChooseOnMapView(),
    addressSuggestionsView: (_) => AddressSuggestionView(),
    tarrifSelectionView: (_) => TariffView(),
    paymentView: (_) => PaymentView(),
    searchView: (_) => SearchView(),
    aboutUsView: (_) => AboutUsView(),
    settingsView: (_) => SettingsView(),
    orderHistoryView: (_) => OrderHistoryView(),
    newsView: (_) => NewsView(),

    ///FOOD DELIVERY
    foodHomeScreen: (_) => DeliveryHomeView(),
    foodDeliveryItemsScreen: (_) => ItemsListScreenView(),
    foodDeliveryAddressView: (_) => SearchBottomSheetView(),
    foodDeliveryEstablishmentDetailsView: (_) =>
        EstablishmentDetailsScreenView(),
    foodDeliveryProductItemDetailsView: (_) => ProductItemDetailsScreenView(),
    foodDeliveryShoppingCartView: (_) => ShoppingCartView(),
    foodEstablishmentSearchView: (_) => EstablishmentSearchView(),
    foodProductsSearchView: (_) => ProductsSearchView(),
    orderMapView: (_) => OrderMapView(),
    orderCompletedScreen: (_) => OrderCompletedScreen(),
    orderCancelDetailsView: (_) => OrderCancellationView(),
    orderView: (_) => OrderView(),
    orderDetailsView: (_) => OrderDetailView(),
  };
}
