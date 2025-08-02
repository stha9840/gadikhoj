import 'package:dartz/dartz.dart';
import 'package:finalyearproject/app/shared_pref/token_shared_prefs.dart';
import 'package:finalyearproject/app/use_case/use_case.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/home/domain/repository/vehicle_repository.dart';

class CreateBookingParams {
  final String vehicleId;
  final DateTime startDate;
  final DateTime endDate;
  final String pickupLocation;
  final String dropLocation;
  final double totalPrice;

  CreateBookingParams({
    required this.vehicleId,
    required this.startDate,
    required this.endDate,
    required this.pickupLocation,
    required this.dropLocation,
    required this.totalPrice,
  });
}

class CreateBookingUsecase implements UseCaseWithParams<void, CreateBookingParams> {
  final IVehicleRepository _repository;
  final TokenSharedPrefs _tokenSharedPrefs;

  CreateBookingUsecase({
    required IVehicleRepository repository,
    required TokenSharedPrefs tokenSharedPrefs,
  })  : _repository = repository,
        _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, void>> call(CreateBookingParams params) async {
    final tokenResult = await _tokenSharedPrefs.getToken();
    return tokenResult.fold(
      (failure) => Left(failure),
      (token) => _repository.createBooking(
        token,
        params.vehicleId,
        startDate: params.startDate,
        endDate: params.endDate,
        pickupLocation: params.pickupLocation,
        dropLocation: params.dropLocation,
        totalPrice: params.totalPrice,
      ),
    );
  }
}
