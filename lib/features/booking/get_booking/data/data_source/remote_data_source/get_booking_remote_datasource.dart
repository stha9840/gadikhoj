import 'package:dio/dio.dart';
import 'package:finalyearproject/app/constant/api_endpoints.dart';
import 'package:finalyearproject/core/network/api_service.dart';
import 'package:finalyearproject/features/booking/get_booking/data/data_source/get_booking_datasource.dart';
import 'package:finalyearproject/features/booking/get_booking/data/model/get_booking_api_model.dart';
import 'package:finalyearproject/features/booking/get_booking/domain/entity/booking.dart';

class GetBookingRemoteDatasource implements IGetBookingDatasource {
  final ApiService _apiService;

  GetBookingRemoteDatasource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<List<BookingEntity>> getUserBookings(String? token) async {
    final response = await _apiService.dio.get(
      ApiEndpoints.getUserBookings,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200) {
      final data = response.data as List;
      final bookingModels =
          data.map((e) => BookingApiModel.fromJson(e)).toList();
      return bookingModels.map((e) => e.toEntity()).toList();
    } else {
      throw Exception("Failed to fetch bookings: ${response.statusMessage}");
    }
  }

  @override
  Future<void> cancelUserBooking(String? id, String? token) async {
    try {
      final response = await _apiService.dio.patch(
        '${ApiEndpoints.cancelBookings}/$id/cancel',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print('📦 Response status: ${response.statusCode}');
      print('📦 Response data: ${response.data}');

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception("Failed to cancel booking: ${response.statusMessage}");
      }
    } on DioError catch (e) {
      throw Exception(
        "DioError cancelling booking: ${e.response?.data ?? e.message}",
      );
    } catch (e) {
      throw Exception("Unknown error cancelling booking: $e");
    }
  }

  @override
  Future<void> deleteUserBooking(String? id, String? token) async {
    try {
      // Corresponds to: router.delete("/:bookingId", ...)
      final response = await _apiService.dio.delete(
        '${ApiEndpoints.deleteBookings}/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to delete booking: ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception("Failed to delete booking: $e");
    }
  }

  @override
  Future<void> updateUserBooking(
    String? id,
    Map<String, dynamic> data,
    String? token,
  ) async {
    try {
      // Corresponds to: router.patch("/:bookingId", ...)
      final response = await _apiService.dio.patch(
        '${ApiEndpoints.updateBookings}/$id',
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to update booking: ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception("Failed to update booking: $e");
    }
  }
}
