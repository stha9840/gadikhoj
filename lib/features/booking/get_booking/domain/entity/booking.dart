import 'package:equatable/equatable.dart';
import 'package:finalyearproject/features/home/domain/entity/vehicle.dart'; // import vehicle entity

class BookingEntity extends Equatable {
  final String? id;
  final String userId;
  final String? vehicleId;
  final VehicleEntity? vehicle;  // add this field
  final DateTime startDate;
  final DateTime endDate;
  final String pickupLocation;
  final String dropLocation;
  final double totalPrice;
  final String? status;

  const BookingEntity({
    this.id,
    required this.userId,
     this.vehicleId,
    this.vehicle,  
    required this.startDate,
    required this.endDate,
    required this.pickupLocation,
    required this.dropLocation,
    required this.totalPrice,
    this.status,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        vehicleId,
        vehicle,
        startDate,
        endDate,
        pickupLocation,
        dropLocation,
        totalPrice,
        status,
      ];
}
