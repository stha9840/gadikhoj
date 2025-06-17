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
  Future<Either<Failure, bool>> registerUser(UserEntity user) async {
    try {
      await _userLocalDatasource.registerUser(user);
      return const Right(true);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: "Failed to register user: $e"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    try {
      final user = await _userLocalDatasource.login(email, password);
      return Right(user);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: "Failed to login user: $e"));
    }
  }
}
