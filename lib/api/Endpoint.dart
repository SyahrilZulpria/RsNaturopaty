class Endpoint {
  static String ip = 'https://api.rsnaturopaty.com/';

  /// Decode Token
  static String decodeToken = '${ip}customer/decode_token';

  /// API Login, LogOut & Registration Customer
  static String login = '${ip}customer/login';
  static String logout = '${ip}customer/logout';
  static String registrasi = '${ip}customer/add';
  static String uodateCustomer = '${ip}customer/update';
  static String otp = '${ip}customer/req_otp';
  static String verifyAccount = '${ip}customer/verify/';
  // API verify customer/verify/19/2522 => 19=id , 2522 = otp
  static String forgotPass = '${ip}customer/forgot';
  static String logOut = '${ip}customer/logout';
  static String getDompet = '${ip}customer/ledger';
  static String getPoint = '${ip}customer/point_ledger';
  static String upProfileImg = '${ip}customer/upload_image';
  static String getCustomer = '${ip}customer/get';

  /// API Article
  static String categoryArticle = '${ip}article';
  static String getArticleCategory = '${ip}article/get_category';
  static String getArticlePermalink =
      '${ip}article/get_by_permalink/promo1'; //by : Promo1

  /// API POS

  /// API ORDER
  static String createdSalesAdd = '${ip}sales/add';
  static String salesAddItem =
      '${ip}sales/add_item/'; //get by : id dari sales add
  static String salesUpdate = '${ip}sales/update/'; //get by : id dari sales add
  static String checkoutProduct =
      '${ip}sales/checkout/'; //get by : id dari sales add
  static String getPaymentType = '${ip}payment';
  static String getTransactionDetail =
      '${ip}sales/get/'; //get by : id transction
  static String getHistoryTransaction = '${ip}sales';

  /// API REDEEM

  /// API Notification
  static String getNotification = '${ip}customer/notif';
  static String getDetailNotification = '${ip}customer/notif_detail/'; // by id

  /// API Product
  static String getProductList = '${ip}product';
  static String getProductDetail =
      '${ip}product/get/'; // get by TRISS01/1 kode product

  /// API ImageSlider
  static String imgSlider = '${ip}slider';

  /// API City & Bank
  static String city = '${ip}city/get_city_rj';
  static String bankList = '${ip}banklist';
}
