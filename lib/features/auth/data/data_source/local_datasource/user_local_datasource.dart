import 'package:finalyearproject/core/network/hive_service.dart';
import 'package:finalyearproject/features/auth/data/data_source/user_datasource.dart';
import 'package:finalyearproject/features/auth/data/model/user_hive_model.dart';
import 'package:finalyearproject/features/auth/domain/entity/user_entity.dart';


class UserLocalDatasource implements IUserDataSource {
  final HiveService _hiveService;

  UserLocalDatasource({required HiveService hiveService})
      : _hiveService = hiveService;


  @override
  Future<void> registerUser(UserEntity user) async {
    try {
      final userModel = UserHiveModel.fromEntity(user);
      await _hiveService.registerUser(userModel);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }
  
  @override
  Future<UserEntity> login(String username, String password) async {try {
      final user = await _hiveService.login(username, password);
      if (user != null && user.password == password) {
        return user.toEntity();

      } else {
        throw Exception('Invalid username or password');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
  
}
