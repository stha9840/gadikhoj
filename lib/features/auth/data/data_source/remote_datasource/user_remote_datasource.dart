import 'package:dio/dio.dart';
import 'package:finalyearproject/app/constant/api_endpoints.dart';
import 'package:finalyearproject/core/network/api_service.dart';
import 'package:finalyearproject/features/auth/data/data_source/user_datasource.dart';
import 'package:finalyearproject/features/auth/data/model/user_api_model.dart';
import 'package:finalyearproject/features/auth/domain/entity/user_entity.dart';

class UserRemoteDatasource implements IUserDataSource {
  final ApiService _apiService;

  UserRemoteDatasource({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        final str = response.data['token'];
        return str;
      } else {
        throw Exception("Unable to login user");
      }
    } on DioException {
      throw ("Unable to login user");
    } catch (_) {
      throw ("Unable to login user");
    }
  }

  @override
  Future<void> registerUser(UserEntity user) async {
    try {
      final userApiModel = UserApiModel.fromEntity(user);
      final response = await _apiService.dio.post(
        ApiEndpoints.register,
        data: userApiModel.toJson(),
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return;
      } else {
        throw Exception('Failed to register user: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? e.message;
      throw Exception('Failed to register user: $errorMessage');
    }
  }

  @override
  Future<UserEntity> getUser(String? token) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.getUser,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print('user reponse $response');

      if (response.statusCode == 200) {
        // --- THIS IS THE CORRECTED LINE ---
        // We extract the user map from the 'data' key in the response.
        final userApiModel = UserApiModel.fromJson(response.data['data']);
        return userApiModel.toEntity();
      } else {
        throw Exception('Failed to get user: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? e.message;
      throw Exception('Failed to get user: $errorMessage');
    }
  }

  @override
  Future<void> updateUser(String userId, UserEntity user, String? token) async {
    try {
      final userApiModel = UserApiModel.fromEntity(user);
      final response = await _apiService.dio.put(
        '${ApiEndpoints.updateUser}$userId',
        data: userApiModel.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update user: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? e.message;
      throw Exception('Failed to update user: $errorMessage');
    }
  }

  @override
  Future<void> deleteUser(String userId, String? token) async {
    try {
      final response = await _apiService.dio.delete(
        '${ApiEndpoints.deleteUser}$userId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete user: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? e.message;
      throw Exception('Failed to delete user: $errorMessage');
    }
  }
   @override
  Future<void> requestPasswordReset(String email) async {
    try {
      await _apiService.dio.post(
        ApiEndpoints.requestReset,
        data: {'email': email},
      );
      // We don't need to return anything on success
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? "Failed to send reset link.";
      throw Exception(errorMessage);
    }
  }

  @override
  Future<void> resetPassword(String token, String password) async {
    try {
      await _apiService.dio.post(
        '${ApiEndpoints.resetPassword}$token', // Append token to URL
        data: {'password': password},
      );
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? "Invalid or expired token.";
      throw Exception(errorMessage);
    }
  }
}