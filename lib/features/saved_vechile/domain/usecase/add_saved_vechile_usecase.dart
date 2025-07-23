import 'package:dartz/dartz.dart';
import 'package:finalyearproject/app/shared_pref/token_shared_prefs.dart';
import 'package:finalyearproject/app/use_case/use_case.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/saved_vechile/domain/repository/saved_vechile_repository.dart';

class AddSavedVehicleParams {
  final String vehicleId;
  AddSavedVehicleParams({required this.vehicleId});
}

class AddSavedVehicleUsecase implements UseCaseWithParams<void, AddSavedVehicleParams> {
  final ISavedVehicleRepository _repository;
  final TokenSharedPrefs _tokenSharedPrefs;

  AddSavedVehicleUsecase({
    required ISavedVehicleRepository repository,
    required TokenSharedPrefs tokenSharedPrefs,
  })  : _repository = repository,
        _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, void>> call(AddSavedVehicleParams params) async {
    // 1. Get the token
    final tokenResult = await _tokenSharedPrefs.getToken();
    return tokenResult.fold(
      (failure) => Left(failure),
      // 2. If token exists, make the repository call with the token
      (token) => _repository.addSavedVehicle(params.vehicleId, token),
    );
  }
}