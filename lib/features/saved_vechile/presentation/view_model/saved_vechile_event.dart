import 'package:equatable/equatable.dart';

abstract class SavedVehicleEvent extends Equatable {
  const SavedVehicleEvent();
  @override
  List<Object> get props => [];
}

class GetSavedVehicles extends SavedVehicleEvent {}

class AddVehicleToSaved extends SavedVehicleEvent {
  final String vehicleId;
  const AddVehicleToSaved({required this.vehicleId});
  @override
  List<Object> get props => [vehicleId];
}

class RemoveVehicleFromSaved extends SavedVehicleEvent {
  final String vehicleId;
  const RemoveVehicleFromSaved({required this.vehicleId});
  @override
  List<Object> get props => [vehicleId];
}
