class ApiEndpoints {
  ApiEndpoints._();

  // Timeouts
  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  // Local server for Android emulator
  static const String serverAddress = "http://192.168.101.6:5000/api/";

  // Auth
  static const String login = "auth/login";
  static const String register = "auth/register";

  // Vehicle
  static const String getAllVehicles = "admin/vehicle/";

  // Booking
  static const String createBooking = "bookings/";
  static const String getUserBookings = "bookings/my";

  static const String updateBookings = "bookings/";
  static const String deleteBookings = "bookings/";
  static const String cancelBookings = "bookings/";

  // User
  static const String getUser = "auth/me";
  static const String updateUser = "auth/";
  static const String deleteUser = "auth/";

  //saved vechile
  static const String addSavedVechile = "saved-vehicles/";
  static const String getSavedVechile = "saved-vehicles/";
  static const String removeSavedVechile = "saved-vehicles/";
}
