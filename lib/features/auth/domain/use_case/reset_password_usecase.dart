// In: features/auth/domain/use_case/reset_password_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/auth/domain/repository/user_repository.dart';

class ResetPasswordUsecase {
  final IUserRepository _repository;

  // --- THIS IS THE CHANGE ---
  ResetPasswordUsecase({required IUserRepository repository})
      : _repository = repository;

  Future<Either<Failure, void>> call(String token, String password) async {
    return await _repository.resetPassword(token, password);
  }
}