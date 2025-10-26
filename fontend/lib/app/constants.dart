class ApiConstants {
  static const String baseUrl = 'http://127.0.0.1:3000/api';
  //http://192.168.43.142:3000/api
  //http://10.0.2.2:3000/api
  // 10.8.127.181
  static String getFolderFromCategory(int category) {
    switch (category) {
      case 1:
        return 'coffee';
      case 2:
        return 'juice';
      case 3:
        return 'tea';
      default:
        return 'coffee';
    }
  }
}
