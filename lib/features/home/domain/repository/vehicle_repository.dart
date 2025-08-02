import 'package:dartz/dartz.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/home/data/data_source/remote_data_source/vehicle_remote_data_source.dart';
import 'package:finalyearproject/features/home/domain/entity/vehicle.dart';

class IVehicleRepository {
  final VehicleRemoteDatasource _remoteDatasource;

  IVehicleRepository({required VehicleRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  Future<Either<Failure, List<VehicleEntity>>> getAllVehicles(String? token) async {
    try {
      final vehicles = await _remoteDatasource.getAllVehicles(token);
      return Right(vehicles);
    } catch (e) {
      return Left(ApiFailure(message: "Failed to fetch vehicles: ${e.toString()}"));
    }
  }

  Future<Either<Failure, void>> createBooking(
    String? token,
    String vehicleId, {
    required DateTime startDate,
    required DateTime endDate,
    required String pickupLocation,
    required String dropLocation,
    required double totalPrice,
  }) async {
    try {
      await _remoteDatasource.createBooking(
        token,
        vehicleId,
        startDate: startDate,
        endDate: endDate,
        pickupLocation: pickupLocation,
        dropLocation: dropLocation,
        totalPrice: totalPrice,
      );
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: "Failed to create booking: ${e.toString()}"));
    }
  }
}
