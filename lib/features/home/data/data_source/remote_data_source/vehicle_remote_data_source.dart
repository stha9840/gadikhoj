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
  Future<VehicleEntity> getVehicleById(String? token, String vehicleId) async {
    try {
      final response = await _apiService.dio.get(
        "${ApiEndpoints.getAllVehicles}$vehicleId",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final vehicleApiModel = VehicleApiModel.fromJson(response.data);
        return vehicleApiModel.toEntity();
      } else {
        throw Exception("Failed to fetch vehicle details: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Failed to fetch vehicle details: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error occurred: $e");
    }
  }

  @override
  Future<void> addVehicle(String? token, VehicleEntity vehicleEntity) async {
    try {
      final vehicleApiModel = VehicleApiModel.fromEntity(vehicleEntity);

      final response = await _apiService.dio.post(
        ApiEndpoints.getAllVehicles,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: vehicleApiModel.toJson(),
      );

      if (response.statusCode == 201) {
        return Future.value();
      } else {
        throw Exception("Failed to add vehicle: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Failed to add vehicle: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error occurred while adding vehicle: $e");
    }
  }

  @override
  Future<void> updateVehicle(String? token, String vehicleId, VehicleEntity vehicleEntity) async {
    try {
      final vehicleApiModel = VehicleApiModel.fromEntity(vehicleEntity);

      final response = await _apiService.dio.put(
        "${ApiEndpoints.getAllVehicles}$vehicleId",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: vehicleApiModel.toJson(),
      );

      if (response.statusCode == 200) {
        return Future.value();
      } else {
        throw Exception("Failed to update vehicle: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Failed to update vehicle: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error occurred while updating vehicle: $e");
    }
  }

  @override
  Future<void> deleteVehicle(String? token, String vehicleId) async {
    try {
      final response = await _apiService.dio.delete(
        "${ApiEndpoints.getAllVehicles}$vehicleId",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return Future.value();
      } else {
        throw Exception("Failed to delete vehicle: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Failed to delete vehicle: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error occurred while deleting vehicle: $e");
    }
  }
}
