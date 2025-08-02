import 'package:finalyearproject/features/home/domain/entity/vehicle.dart';


  abstract interface class IVehicleDatasource {
  Future<List<VehicleEntity>> getAllVehicles(String? token);

  Future<void> createBooking(
    String? token,
    String vehicleId, {
    required DateTime startDate,
    required DateTime endDate,
    required String pickupLocation,
    required String dropLocation,
    required double totalPrice,
  });
}

