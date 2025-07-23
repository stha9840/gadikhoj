import 'package:finalyearproject/features/auth/domain/entity/user_entity.dart';

abstract interface class IUserDataSource {
  Future<void> registerUser(UserEntity user);
  Future<String> loginUser(String email, String password);
  Future<void> updateUser(String userId, UserEntity user, String? token);
  Future<void> deleteUser(String userId, String? token);
  Future<void> getUser( String? token);
}
