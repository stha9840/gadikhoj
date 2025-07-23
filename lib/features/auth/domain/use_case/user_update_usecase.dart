// features/auth/domain/use_case/update_user_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finalyearproject/app/shared_pref/token_shared_prefs.dart';
import 'package:finalyearproject/app/use_case/use_case.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/auth/domain/entity/user_entity.dart';
import 'package:finalyearproject/features/auth/domain/repository/user_repository.dart';

class UpdateUserParams extends Equatable {
  final String userId;
  final UserEntity user;

  const UpdateUserParams({required this.userId, required this.user});

  @override
  List<Object?> get props => [userId, user];
}

class UpdateUserUseCase implements UseCaseWithParams<void, UpdateUserParams> {
  final IUserRepository _iUserRepository;
  final TokenSharedPrefs _tokenSharedPrefs;

  UpdateUserUseCase({
    required IUserRepository iUserRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  })  : _iUserRepository = iUserRepository,
        _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, void>> call(UpdateUserParams params) async {
    final tokenResult = await _tokenSharedPrefs.getToken();

    return tokenResult.fold(
      (failure) => Left(failure),
      (token) async => await _iUserRepository.updateUser(params.userId, params.user, token),
    );
  }
}