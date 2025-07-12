class ApiEndpoints {
  ApiEndpoints._();

  //Timeouts
  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  //for android emulator
  static const String serverAddress = "http://192.168.157.46:5000/api/";

  //Auth
  static const String login = "auth/login";
  static const String register = "auth/register";

  //vehicle
  static const String getAllVehicles = "admin/vehicle/";
  static const String createBooking = "bookings/";
}
