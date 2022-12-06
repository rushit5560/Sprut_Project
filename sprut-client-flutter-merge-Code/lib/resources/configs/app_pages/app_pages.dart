import 'package:get/route_manager.dart';
import 'package:sprut/presentation/pages/about_us/bindings/about_us_binding.dart';
import 'package:sprut/presentation/pages/about_us/views/about_us_view.dart';
import 'package:sprut/presentation/pages/news/bindings/news_binding.dart';
import 'package:sprut/presentation/pages/news/views/news_view.dart';
import 'package:sprut/presentation/pages/order_history/bindings/order_history_binding.dart';
import 'package:sprut/presentation/pages/order_history/views/order_history_view.dart';
import 'package:sprut/presentation/pages/search_screen/bindings/search_binding.dart';
import 'package:sprut/presentation/pages/search_screen/views/search_view_old.dart';
import 'package:sprut/presentation/pages/settings/bindings/settings_binding.dart';
import 'package:sprut/presentation/pages/settings/views/settings_view.dart';

import '../../../presentation/pages/choose_on_map/bindings/choose_on_map_binding.dart';
import '../../../presentation/pages/choose_on_map/views/choose_on_map_view.dart';
import '../../../presentation/pages/delivery_home/bindings/add_food_suggestion_binding.dart';
import '../../../presentation/pages/delivery_home/bindings/establishment_binding.dart';
import '../../../presentation/pages/delivery_home/bindings/establishment_details_binding.dart';
import '../../../presentation/pages/delivery_home/delivery_home_view.dart';
import '../../../presentation/pages/delivery_home/views/establishment_details_view/establishment_details_screen.dart';
import '../../../presentation/pages/delivery_home/views/establishment_details_view/product_details/product_item_details_screen.dart';
import '../../../presentation/pages/delivery_home/views/establishment_search_view/establishment_search_view.dart';
import '../../../presentation/pages/delivery_home/views/food_search_address/search_bottom_sheet.dart';
import '../../../presentation/pages/delivery_home/views/items_list_screen.dart';
import '../../../presentation/pages/delivery_home/views/product_search_view/product_search_view.dart';
import '../../../presentation/pages/home_screen/bindings/home_binding.dart';
import '../../../presentation/pages/home_screen/views/add_addresses_views/add_home_address_view.dart';
import '../../../presentation/pages/home_screen/views/add_addresses_views/add_work_address_view.dart';
import '../../../presentation/pages/home_screen/views/home_view.dart';
import '../../../presentation/pages/order_screen/bindings/order_binding.dart';
import '../../../presentation/pages/order_screen/views/completed_order/order_completed_screen.dart';
import '../../../presentation/pages/order_screen/views/order_map_view.dart';
import '../../../presentation/pages/order_screen/views/order_view.dart';
import '../../../presentation/pages/payment_screen/bindings/payment_binding.dart';
import '../../../presentation/pages/payment_screen/views/payment_view.dart';
import '../../../presentation/pages/search_screen/views/search_view.dart';
import '../../../presentation/pages/tariff_screen/bindings/tariff_binding.dart';
import '../../../presentation/pages/tariff_screen/views/tariff_view.dart';
import '../routes/routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
        name: Routes.homeScreen,
        page: () => HomeView(),
        binding: HomeBinding()),
    GetPage(
      name: Routes.addHomeAddress,
      page: () => AddHomeAddress(),
    ),
    GetPage(
      name: Routes.addWorkAddress,
      page: () => AddWorkAddress(),
    ),
    GetPage(
        name: Routes.chooseOnMap,
        page: () => ChooseOnMapView(),
        binding: ChooseOnMapBinding()),
    GetPage(
        name: Routes.tarrifSelectionView,
        page: () => TariffView(),
        binding: TariffBinding()),
    GetPage(
      name: Routes.paymentView,
      page: () => PaymentView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: Routes.searchView,
      page: () => SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: Routes.aboutUsView,
      page: () => AboutUsView(),
      binding: AboutUsBinding(),
    ),
    GetPage(
      name: Routes.settingsView,
      page: () => SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: Routes.orderHistoryView,
      page: () => OrderHistoryView(),
      binding: OrderHistoryBinding(),
    ),
    GetPage(
      name: Routes.newsView,
      page: () => NewsView(),
      binding: NewsBinding(),
    ),

    GetPage(
        name: Routes.orderView,
        page: () => OrderView(),
        binding: OrderBinding()),
    GetPage(
        name: Routes.orderMapView,
        page: () => OrderMapView(),
        binding: OrderBinding()),
    GetPage(
        name: Routes.foodHomeScreen,
        page: () => DeliveryHomeView(),
        binding: HomeBinding()),
    GetPage(
        name: Routes.foodDeliveryItemsScreen,
        page: () => ItemsListScreenView(),
        bindings: [HomeBinding(), EstablishmentBinding()]),
    GetPage(
        name: Routes.foodDeliveryAddressView,
        page: () => SearchBottomSheetView(),
        binding: AddressFoodSuggestionBinding()),
    GetPage(
        name: Routes.foodDeliveryEstablishmentDetailsView,
        page: () => EstablishmentDetailsScreenView(),
        bindings: [HomeBinding(), EstablishmentDetailsBinding()]),
    GetPage(
        name: Routes.foodDeliveryProductItemDetailsView,
        page: () => ProductItemDetailsScreenView(),
        bindings: [HomeBinding(), EstablishmentDetailsBinding()]),
    GetPage(
        name: Routes.foodEstablishmentSearchView,
        page: () => EstablishmentSearchView(),
        bindings: [EstablishmentDetailsBinding()]),
    GetPage(
        name: Routes.foodProductsSearchView,
        page: () => ProductsSearchView(),
        bindings: [EstablishmentDetailsBinding()]),
    GetPage(
        name: Routes.orderCompletedScreen,
        page: () => OrderCompletedScreen(),
        bindings: [EstablishmentDetailsBinding(),OrderBinding()])

  ];
}
