import 'package:dio/dio.dart';
import 'package:finalyearproject/app/constant/api_endpoints.dart';
import 'package:finalyearproject/core/network/api_service.dart';
import 'package:finalyearproject/features/home/data/data_source/vehicle_datasource.dart';
import 'package:finalyearproject/features/home/data/dto/get_all_vehicles_dto.dart';
import 'package:finalyearproject/features/home/data/model/vehicle_api_model.dart';
import 'package:finalyearproject/features/home/domain/entity/vehicle.dart';

class VehicleRemoteDatasource implements IVehicleDatasource {
  final ApiService _apiService;
  VehicleRemoteDatasource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<List<VehicleEntity>> getAllVehicles(String? token) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.getAllVehicles,
        // Remove the header since it's unnecessary
      );

      if (response.statusCode == 200) {
        GetAllVehiclesDto dto = GetAllVehiclesDto.fromJson(response.data);
        return VehicleApiModel.toEntityList(dto.data);
      } else {
        throw Exception("Failed to fetch vehicles: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Failed to fetch vehicles: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error occurred: $e");
    }
  }
  
  @override
Future<void> createBooking(
  String? token,
  String vehicleId, {
  required DateTime startDate,
  required DateTime endDate,
  required String pickupLocation,
  required String dropLocation,
  required double totalPrice,
}) async {
  try {
    final response = await _apiService.dio.post(
      ApiEndpoints.createBooking,
      data: {
        "vehicleId": vehicleId,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "pickupLocation": pickupLocation,
        "dropLocation": dropLocation,
        "totalPrice": totalPrice,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      ),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception("Failed to create booking: ${response.statusMessage}");
    }
  } on DioException catch (e) {
    throw Exception("Booking failed: ${e.response?.data ?? e.message}");
  } catch (e) {
    throw Exception("Unexpected error: $e");
  }
}
}
