import 'dart:io';

import 'package:finalyearproject/core/network/hive_service.dart';
import 'package:finalyearproject/features/auth/data/model/user_hive_model.dart';
import 'package:finalyearproject/features/auth/domain/entity/user_entity.dart';

abstract class IUserLocalDatasource {
  Future<String> loginUser(String username, String password);
  Future<void> registerUser(UserEntity user);
  Future<String> uploadProfilePicture(File file); // optional
  Future<UserEntity> getCurrentUser(); // optional
}

class UserLocalDatasource implements IUserLocalDatasource {
  final HiveService _hiveService;

  UserLocalDatasource({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  Future<String> loginUser(String username, String password) async {
    try {
      final user = await _hiveService.login(username, password);
      if (user != null && user.password == password) {
        return "Login successful";
      } else {
        throw Exception("Invalid username or password");
      }
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  @override
  Future<void> registerUser(UserEntity user) async {
    try {
      final hiveModel = UserHiveModel.fromEntity(user);
      await _hiveService.registerUser(hiveModel);
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }

  @override
  Future<String> uploadProfilePicture(File file) {
    throw UnimplementedError(); // Optional: Add logic later if needed
  }

  @override
  Future<UserEntity> getCurrentUser() {
    throw UnimplementedError(); // Optional: Implement if you store session
  }
}
