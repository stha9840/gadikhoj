import 'package:finalyearproject/features/auth/domain/entity/user_entity.dart';

abstract interface class IUserDataSource {
  Future<void> registerStudent(UserEntity userData);

  Future<String> loginStudent(String username, String password);


}