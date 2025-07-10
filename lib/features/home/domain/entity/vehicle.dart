import 'package:equatable/equatable.dart';

class VehicleEntity extends Equatable {
  final String? id;
  final String vehicleName;
  final String vehicleType;
  final int fuelCapacityLitres;
  final int loadCapacityKg;
  final String passengerCapacity;
  final double pricePerTrip;
  final String filepath;
  final String? vehicleDescription;

  const VehicleEntity({
    this.id,
    required this.vehicleName,
    required this.vehicleType,
    required this.fuelCapacityLitres,
    required this.loadCapacityKg,
    required this.passengerCapacity,
    required this.pricePerTrip,
    required this.filepath,
    this.vehicleDescription,
  });

  @override
  List<Object?> get props => [
        id,
        vehicleName,
        vehicleType,
        fuelCapacityLitres,
        loadCapacityKg,
        passengerCapacity,
        pricePerTrip,
        filepath,
        vehicleDescription,
      ];
}
