import 'package:dartz/dartz.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/saved_vechile/domain/entity/saved_vechile_entity.dart';

abstract interface class ISavedVehicleRepository {
  Future<Either<Failure, void>> addSavedVehicle(String vehicleId , String? token);

  Future<Either<Failure, void>> removeSavedVehicle(String vehicleId , String? token);

  Future<Either<Failure, List<SavedVehicleEntity>>> getSavedVehicles(String? token);
}