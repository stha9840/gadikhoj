import 'package:finalyearproject/core/network/api_service.dart';
import 'package:finalyearproject/features/auth/data/data_source/user_datasource.dart';
import 'package:finalyearproject/features/auth/domain/entity/user_entity.dart';

class UserRemoteDatasource implements IUserDataSource {
  final ApiService _apiService;

  UserRemoteDatasource({
    required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<String> loginUser(String email, String password) {
    // TODO: implement loginUser
    throw UnimplementedError();
  }

  @override
  Future<void> registerUser(UserEntity user) {
    // TODO: implement registerUser
    throw UnimplementedError();
  }
}
