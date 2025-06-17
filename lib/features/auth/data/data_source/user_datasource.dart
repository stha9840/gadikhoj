import 'package:finalyearproject/features/auth/domain/entity/user_entity.dart';

abstract interface class IUserDataSource {
  Future<void> registerUser(UserEntity userData);
  Future<UserEntity> login(String username, String password);
}
