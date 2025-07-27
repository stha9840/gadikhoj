// import 'package:equatable/equatable.dart';

// abstract class VehicleEvent extends Equatable {
//   const VehicleEvent();

//   @override
//   List<Object?> get props => [];
// }

// // Event to trigger fetching vehicles
// class FetchVehiclesEvent extends VehicleEvent {}

import 'package:equatable/equatable.dart';

abstract class VehicleEvent extends Equatable {
  const VehicleEvent();

  @override
  List<Object?> get props => [];
}

// Event to trigger fetching vehicles
class FetchVehiclesEvent extends VehicleEvent {}

// New event to filter vehicles by type
class FilterVehiclesEvent extends VehicleEvent {
  final String vehicleType;

  const FilterVehiclesEvent(this.vehicleType);

  @override
  List<Object?> get props => [vehicleType];
}