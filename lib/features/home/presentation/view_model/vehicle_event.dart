import 'package:equatable/equatable.dart';

abstract class VehicleEvent extends Equatable {
  const VehicleEvent();

  @override
  List<Object?> get props => [];
}

// Event to trigger fetching vehicles
class FetchVehiclesEvent extends VehicleEvent {}

// Event to filter vehicles by type
class FilterVehiclesEvent extends VehicleEvent {
  final String vehicleType;

  const FilterVehiclesEvent(this.vehicleType);

  @override
  List<Object?> get props => [vehicleType];
}

// ADD THIS NEW EVENT
// Event to handle searching vehicles by name
class SearchVehiclesEvent extends VehicleEvent {
  final String query;

  const SearchVehiclesEvent(this.query);

  @override
  List<Object?> get props => [query];
}