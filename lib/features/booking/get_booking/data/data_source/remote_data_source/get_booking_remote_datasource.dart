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
final bookingModels = data.map((e) => BookingApiModel.fromJson(e)).toList();
return bookingModels.map((e) => e.toEntity()).toList();
  } else {
    throw Exception("Failed to fetch bookings: ${response.statusMessage}");
  }

    }
  }
