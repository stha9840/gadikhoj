// import 'package:equatable/equatable.dart';
// import 'package:finalyearproject/features/home/domain/entity/vehicle.dart';

// abstract class VehicleState extends Equatable {
//   const VehicleState();

//   @override
//   List<Object?> get props => [];
// }

// class VehicleInitial extends VehicleState {}

// class VehicleLoading extends VehicleState {}

// class VehicleLoaded extends VehicleState {
//   final List<VehicleEntity> vehicles;

//   const VehicleLoaded(this.vehicles);

//   @override
//   List<Object?> get props => [vehicles];
// }

// class VehicleError extends VehicleState {
//   final String message;

//   const VehicleError(this.message);

//   @override
//   List<Object?> get props => [message];
// }

import 'package:equatable/equatable.dart';
import 'package:finalyearproject/features/home/domain/entity/vehicle.dart';

abstract class VehicleState extends Equatable {
  const VehicleState();

  @override
  List<Object?> get props => [];
}

class VehicleInitial extends VehicleState {}

class VehicleLoading extends VehicleState {}

class VehicleLoaded extends VehicleState {
  final List<VehicleEntity> allVehicles; // Master list of all vehicles
  final List<VehicleEntity> filteredVehicles; // List of vehicles to display
  final List<String> vehicleTypes; // Unique types for filter chips
  final String selectedType; // The currently active filter

  const VehicleLoaded({
    required this.allVehicles,
    required this.filteredVehicles,
    required this.vehicleTypes,
    required this.selectedType,
  });

  // copyWith makes it easy to update the state without re-fetching data
  VehicleLoaded copyWith({
    List<VehicleEntity>? filteredVehicles,
    String? selectedType,
  }) {
    return VehicleLoaded(
      allVehicles: allVehicles,
      filteredVehicles: filteredVehicles ?? this.filteredVehicles,
      vehicleTypes: vehicleTypes,
      selectedType: selectedType ?? this.selectedType,
    );
  }

  @override
  List<Object?> get props => [allVehicles, filteredVehicles, vehicleTypes, selectedType];
}

class VehicleError extends VehicleState {
  final String message;

  const VehicleError(this.message);

  @override
  List<Object?> get props => [message];
}