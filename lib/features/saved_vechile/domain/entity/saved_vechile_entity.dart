import 'package:equatable/equatable.dart';
import 'package:finalyearproject/features/home/domain/entity/vehicle.dart';

class SavedVehicleEntity extends Equatable {
  final String? id; 
  final String userId;
  final VehicleEntity vehicle; 
  final DateTime? createdAt;

  const SavedVehicleEntity({
    this.id,
    required this.userId,
    required this.vehicle,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, vehicle, createdAt];
}