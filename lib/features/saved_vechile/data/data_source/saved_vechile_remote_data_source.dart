import 'package:dio/dio.dart';
import 'package:finalyearproject/app/constant/api_endpoints.dart'; // Adjust path
import 'package:finalyearproject/core/network/api_service.dart';
import 'package:finalyearproject/features/saved_vechile/data/data_source/saved_vechile_data_source.dart';
import 'package:finalyearproject/features/saved_vechile/data/model/saved_vechile_api_model.dart';
import 'package:finalyearproject/features/saved_vechile/domain/entity/saved_vechile_entity.dart'; // Adjust path

class SavedVehicleRemoteDataSource implements ISavedVechileDataSource {
  final ApiService _apiService;

  SavedVehicleRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<void> addSavedVehicle(String vehicleId, String? token) async {
    try {
      // Corresponds to: router.post("/", savedVehicleController.addSavedVehicle);
      final response = await _apiService.dio.post(
        ApiEndpoints.addSavedVechile,
        data: {'vehicleId': vehicleId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print('reponse $response  add saved vechile');
      if (response.statusCode != 201) {
        throw Exception('Failed to save vehicle: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      // Your backend returns 400 for a duplicate vehicle.
      if (e.response?.statusCode == 400) {
        throw Exception(e.response?.data['message'] ?? 'Vehicle already saved');
      }
      throw Exception(
        'Error saving vehicle: ${e.response?.data['message'] ?? e.message}',
      );
    } catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
  }

  @override
  Future<List<SavedVehicleApiModel>> getSavedVehicles(String? token) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.getSavedVechile,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => SavedVehicleApiModel.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to get saved vehicles: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Error fetching saved vehicles: ${e.response?.data['message'] ?? e.message}',
      );
    } catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
  }

  @override
  Future<void> removeSavedVehicle(String vehicleId, String? token) async {
    try {
      final response = await _apiService.dio.delete(
        '${ApiEndpoints.removeSavedVechile}/$vehicleId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to remove saved vehicle: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Error removing vehicle: ${e.response?.data['message'] ?? e.message}',
      );
    } catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
  }
}
