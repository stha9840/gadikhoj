import 'package:dartz/dartz.dart';
import 'package:finalyearproject/features/auth/domain/entity/user_entity.dart';

abstract class IUserRepository {
  Future<Either<String, bool>> registerUser(UserEntity user);
  Future<Either<String, UserEntity>> login(String email, String password);
}
