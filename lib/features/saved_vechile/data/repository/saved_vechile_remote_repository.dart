import 'package:dartz/dartz.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/saved_vechile/data/data_source/saved_vechile_remote_data_source.dart';
import 'package:finalyearproject/features/saved_vechile/domain/entity/saved_vechile_entity.dart';
import 'package:finalyearproject/features/saved_vechile/domain/repository/saved_vechile_repository.dart';

class SavedVehicleRepositoryImpl implements ISavedVehicleRepository {
  final SavedVehicleRemoteDataSource _dataSource;

  SavedVehicleRepositoryImpl({required SavedVehicleRemoteDataSource dataSource})
    : _dataSource = dataSource;

 @override
Future<Either<Failure, void>> addSavedVehicle(String vehicleId, String? token) async {
  try {
    final result = await _dataSource.addSavedVehicle(vehicleId, token); // ← Pass token
    return Right(result);
  } catch (e) {
    return Left(ApiFailure(message: e.toString()));
  }
}


  @override
  Future<Either<Failure, List<SavedVehicleEntity>>> getSavedVehicles(String? token) async {
    try {
      final savedVehicleModels = await _dataSource.getSavedVehicles(token);
        final List<SavedVehicleEntity> savedVehicleEntities = savedVehicleModels
      .map((model) => model.toEntity())
      .toList();
  return Right(savedVehicleEntities);
} catch (e) {
  return Left(ApiFailure(message: e.toString()));
}
  }

 @override
Future<Either<Failure, void>> removeSavedVehicle(String vehicleId, String? token) async {
  try {
    final result = await _dataSource.removeSavedVehicle(vehicleId, token); // ← Pass token
    return Right(result);
  } catch (e) {
    return Left(ApiFailure(message: e.toString()));
  }
}

}
