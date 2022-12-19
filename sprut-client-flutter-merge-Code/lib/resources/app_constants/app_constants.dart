class AppConstants {
  static String fontFamily = "SF-Pro Display";

  // for dio
  static const CONNECT_TIMEOUT = 1000;
  static const RECEIVE_TIMEOUT = 1000;

  static const DEFAULT_EMAIL = "contact@sprut.ua";
  static const DEFAULT_PHONE = "9900";


  static const UKR_PRICE_SYMBOL = '₴';
  static const RUSS_PRICE_SYMBOL = 'UHA';

  //FOOD DELIVERY
  //Drawer Redirect URL
  static const BECOME_DRIVER_URL = "https://sprut.ua/drivers";
  //Type of app
  static const FOOD_APP = "1";
  static const TAXI_APP = "2";

  static const ORDER_STATUS_NEW = "new";
  static const ORDER_STATUS_CANCELED_KITCHEN = "canceledKitchen";
  static const ORDER_STATUS_NOT_ACCEPTED = "notAccepted";
  static const ORDER_STATUS_ACCEPTED = "accepted";
  static const ORDER_STATUS_PAID = "paid";
  static const ORDER_STATUS_PAYMENT_WAIT = "paymentWait";
  static const ORDER_STATUS_COOKING = "cooking";
  static const ORDER_STATUS_CANCELED_CLIENT = "canceledClient";
  static const ORDER_STATUS_CANCELED_CLIENT_PAYMENT = "canceledClientPayment";
  static const ORDER_STATUS_READY_FOR_DELIVERY = "readyForDelivery";
  static const ORDER_STATUS_HANDED_TO_COURIER = "handedToCourier";
  static const ORDER_STATUS_DELIVERED = "completed";


  static const ORDER_STATUS_DRIVER_ASSIGNED = "driver-assigned";
  static const ORDER_STATUS_DRIVER_ARRIVED = "arrived";
  static const ORDER_STATUS_DRIVER_TRANSPORTING = "transporting";
  static const ORDER_STATUS_DRIVER_SEARCHING = "searching";
  static const ORDER_STATUS_DRIVER_CANCELLED = "cancelled";

}
