// In: features/auth/domain/use_case/request_password_reset_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/auth/domain/repository/user_repository.dart';

class RequestPasswordResetUsecase {
  final IUserRepository _repository;

  // --- THIS IS THE CHANGE ---
  // Wrap the parameter in curly braces {} and add 'required'.
  RequestPasswordResetUsecase({required IUserRepository repository})
      : _repository = repository;

  Future<Either<Failure, void>> call(String email) async {
    return await _repository.requestPasswordReset(email);
  }
}