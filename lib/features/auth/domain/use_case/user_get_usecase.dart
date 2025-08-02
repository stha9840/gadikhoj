// features/auth/domain/use_case/get_user_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:finalyearproject/app/shared_pref/token_shared_prefs.dart';
import 'package:finalyearproject/app/use_case/use_case.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/auth/domain/entity/user_entity.dart';
import 'package:finalyearproject/features/auth/domain/repository/user_repository.dart';




class GetUserUseCase implements UseCaseWithoutParams<UserEntity> {
  final IUserRepository _iUserRepository;
  final TokenSharedPrefs _tokenSharedPrefs;

  GetUserUseCase({
    required IUserRepository iUserRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  })  : _iUserRepository = iUserRepository,
        _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, UserEntity>> call() async {
    final tokenResult = await _tokenSharedPrefs.getToken();

    return tokenResult.fold(
      (failure) => Left(failure),
      (token) async => await _iUserRepository.getUser(token),
    );
  }
}