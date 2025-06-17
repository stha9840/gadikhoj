import 'package:dartz/dartz.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/auth/domain/entity/user_entity.dart';

abstract class IUserRepository {
  Future<Either<Failure, bool>> registerUser(UserEntity user);
  Future<Either<Failure, UserEntity>> login(String email, String password);
}
