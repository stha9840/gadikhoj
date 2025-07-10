import 'package:dartz/dartz.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/home/data/data_source/remote_data_source/vehicle_remote_data_source.dart';
import 'package:finalyearproject/features/home/domain/entity/vehicle.dart';
import 'package:finalyearproject/features/home/domain/repository/vehicle_repository.dart';

   class VehicleRemoteRepository implements IVehicleRepository {
  final VehicleRemoteDatasource _remoteDatasource;

  VehicleRemoteRepository({required VehicleRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  @override
  Future<Either<Failure, List<VehicleEntity>>> getAllVehicles(String? token) async {
    try {
      final vehicles = await _remoteDatasource.getAllVehicles(token);
      return Right(vehicles);
    } catch (e) {
      return Left(
        ApiFailure(message: "Failed to fetch vehicles: ${e.toString()}"),
      );
    }
  }
}
