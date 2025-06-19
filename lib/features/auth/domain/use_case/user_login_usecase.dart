import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/auth/domain/repository/user_repository.dart';
import 'package:finalyearproject/app/use_case/use_case.dart';

class UserLoginParams extends Equatable {
  final String email;
  final String password;

  const UserLoginParams({required this.email, required this.password});

  const UserLoginParams.initial() : email = '', password = '';

  @override
  List<Object?> get props => [email, password];
}

class UserLoginUsecase implements UseCaseWithParams<String, UserLoginParams> {
  final IUserRepository _userRepository;

  UserLoginUsecase({required IUserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, String>> call(UserLoginParams params) {
    return _userRepository.loginUser(params.email, params.password);
  }
}
