import 'package:dartz/dartz.dart';
import 'package:finalyearproject/app/shared_pref/token_shared_prefs.dart';
import 'package:finalyearproject/app/use_case/use_case.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/home/domain/entity/vehicle.dart';
import 'package:finalyearproject/features/home/domain/repository/vehicle_repository.dart';

class GetAllVehiclesUsecase implements UseCaseWithoutParams<List<VehicleEntity>> {
  final IVehicleRepository _vehicleRepository;
  final TokenSharedPrefs _tokenSharedPrefs;

  GetAllVehiclesUsecase({
    required IVehicleRepository vehicleRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  })  : _vehicleRepository = vehicleRepository,
        _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, List<VehicleEntity>>> call() async {
    final token = await _tokenSharedPrefs.getToken();
    return token.fold(
      (failure) => Left(failure),
      (tokenValue) => _vehicleRepository.getAllVehicles(tokenValue),
    );
  }
}
