
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finalyearproject/app/shared_pref/token_shared_prefs.dart';
import 'package:finalyearproject/app/use_case/use_case.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/auth/domain/repository/user_repository.dart';

class DeleteUserParams extends Equatable {
  final String userId;

  const DeleteUserParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}



class DeleteUserUseCase implements UseCaseWithParams<void, DeleteUserParams> {
  final IUserRepository _iUserRepository;
  final TokenSharedPrefs _tokenSharedPrefs;

  DeleteUserUseCase({
    required IUserRepository iUserRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  })  : _iUserRepository = iUserRepository,
        _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, void>> call(DeleteUserParams params) async {
    final tokenResult = await _tokenSharedPrefs.getToken();

    return tokenResult.fold(
      (failure) => Left(failure),
      (token) async => await _iUserRepository.deleteUser(params.userId, token),
    );
  }
}