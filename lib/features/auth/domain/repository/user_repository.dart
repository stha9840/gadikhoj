import 'package:dartz/dartz.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/auth/domain/entity/user_entity.dart';

abstract interface class IUserRepository {
  Future<Either<Failure, void>> registerUser(UserEntity user);
  Future<Either<Failure, String>> loginUser(String email, String password);
  Future<Either<Failure, UserEntity>> getUser(String? token);
  Future<Either<Failure, void>> updateUser(String userId, UserEntity user, String? token);
  Future<Either<Failure, void>> deleteUser(String userId, String? token);
}
