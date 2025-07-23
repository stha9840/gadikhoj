import 'package:dartz/dartz.dart';
import 'package:finalyearproject/app/shared_pref/token_shared_prefs.dart';
import 'package:finalyearproject/app/use_case/use_case.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/saved_vechile/domain/repository/saved_vechile_repository.dart';


class RemoveSavedVehicleParams {
  final String vehicleId;
  RemoveSavedVehicleParams({required this.vehicleId});
}
class RemoveSavedVehicleUsecase implements UseCaseWithParams<void, RemoveSavedVehicleParams> {
  final ISavedVehicleRepository _repository;
  final TokenSharedPrefs _tokenSharedPrefs;

  RemoveSavedVehicleUsecase({
    required ISavedVehicleRepository repository,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _repository = repository,
       _tokenSharedPrefs = tokenSharedPrefs;
       
         @override
         Future<Either<Failure, void>> call(RemoveSavedVehicleParams params) async {
         final tokenResult = await _tokenSharedPrefs.getToken();
    return tokenResult.fold(
      (failure) => Left(failure),
      (token) => _repository.removeSavedVehicle(params.vehicleId, token),
    );
  }
         }

 

