import 'package:equatable/equatable.dart';
import 'package:finalyearproject/features/saved_vechile/domain/entity/saved_vechile_entity.dart';

abstract class SavedVehicleState extends Equatable {
  const SavedVehicleState();

  @override
  List<Object> get props => [];
}

class SavedVehicleInitial extends SavedVehicleState {}

class SavedVehicleLoading extends SavedVehicleState {}

class SavedVehicleSuccess extends SavedVehicleState {
  final List<SavedVehicleEntity> savedVehicles;

  const SavedVehicleSuccess({required this.savedVehicles});

  @override
  List<Object> get props => [savedVehicles];
}

class SavedVehicleActionSuccess extends SavedVehicleState {
  final String message;

  const SavedVehicleActionSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

/// The state when an error has occurred during an operation.
class SavedVehicleError extends SavedVehicleState {
  final String message;

  const SavedVehicleError({required this.message});

  @override
  List<Object> get props => [message];
}
