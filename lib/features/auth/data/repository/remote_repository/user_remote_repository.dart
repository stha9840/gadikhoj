import 'package:dartz/dartz.dart';
import 'package:finalyearproject/app/shared_pref/token_shared_prefs.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:finalyearproject/features/auth/domain/entity/user_entity.dart';
import 'package:finalyearproject/features/auth/domain/repository/user_repository.dart';

class UserRemoteRepository implements IUserRepository {
  final UserRemoteDatasource _userRemoteDatasource;
  // 1. Declare the dependency
  final TokenSharedPrefs _tokenSharedPrefs;

  UserRemoteRepository({
    required UserRemoteDatasource userRemoteDatasource,
    // 2. Add it to the constructor
    required TokenSharedPrefs tokenSharedPrefs,
  })  : _userRemoteDatasource = userRemoteDatasource,
        // 3. Initialize it
        _tokenSharedPrefs = tokenSharedPrefs;


  @override
  Future<Either<Failure, String>> loginUser(
    String email,
    String password,
  ) async {
    try {
      final result = await _userRemoteDatasource.loginUser(email, password);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  // 4. This method now works because _tokenSharedPrefs is initialized
   @override
   Future<Either<Failure, void>> logoutUser() async {
    try {
      await _tokenSharedPrefs.clearToken();
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: "Failed to logout: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      final result = await _userRemoteDatasource.registerUser(user);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUser( String? token) async {
    try {
      final result = await _userRemoteDatasource.getUser(token);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUser(String userId, UserEntity user, String? token) async {
    try {
      final result = await _userRemoteDatasource.updateUser(userId, user, token);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String userId, String? token) async {
    try {
      final result = await _userRemoteDatasource.deleteUser(userId, token);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

    @override
  Future<Either<Failure, void>> requestPasswordReset(String email) async {
    try {
      await _userRemoteDatasource.requestPasswordReset(email);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(
      String token, String password) async {
    try {
      await _userRemoteDatasource.resetPassword(token, password);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}