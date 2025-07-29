import 'package:dartz/dartz.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/auth/domain/repository/user_repository.dart';

class LogoutUserUsecase {
  final IUserRepository _repository;

  LogoutUserUsecase({required IUserRepository repository})
      : _repository = repository;

  Future<Either<Failure, void>> call() async {
    return await _repository.logoutUser();
  }
}