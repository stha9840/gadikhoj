class ApiEndpoints {
  ApiEndpoints._();

  //Timeouts
  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  //for android emulator
  static const String serverAddress = "http://172.26.2.179:3000";

  //Auth
  static const String login = "/login";
  static const String register = "/regsiter";
}
