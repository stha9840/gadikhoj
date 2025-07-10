
import 'package:finalyearproject/features/home/domain/entity/vehicle.dart';

abstract interface class IVehicleDatasource {
  Future<List<VehicleEntity>> getAllVehicles(String? token);

  Future<VehicleEntity> getVehicleById(String? token, String vehicleId);

  Future<void> addVehicle(String? token, VehicleEntity vehicleEntity);

  Future<void> updateVehicle(String? token, String vehicleId, VehicleEntity vehicleEntity);

  Future<void> deleteVehicle(String? token, String vehicleId);
}