import 'package:dartz/dartz.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:finalyearproject/features/auth/domain/entity/user_entity.dart';
import 'package:finalyearproject/features/auth/domain/repository/user_repository.dart';

class UserLocalRepository implements IUserRepository {
  final UserLocalDatasource _userLocalDatasource;

  UserLocalRepository({required UserLocalDatasource userLocalDatasource})
    : _userLocalDatasource = userLocalDatasource;

  @override
  Future<Either<Failure, String>> loginUser(
    String email,
    String password,
  ) async {
    try {
      final userId = await _userLocalDatasource.loginUser(email, password);
      return Right(userId);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: "Login Failed: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      await _userLocalDatasource.registerUser(user);
      return Right(null);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: "Registration failed: $e"));
    }
  }
}
