// import 'package:finalyearproject/features/home/domain/use_case/get_all_vehicles_usecase.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:finalyearproject/core/error/failure.dart';
// import 'vehicle_event.dart';
// import 'vehicle_state.dart';

// class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
//   final GetAllVehiclesUsecase getAllVehiclesUsecase;

//   VehicleBloc({required this.getAllVehiclesUsecase}) : super(VehicleInitial()) {
//     on<FetchVehiclesEvent>((event, emit) async {
//       emit(VehicleLoading());
//       final failureOrVehicles = await getAllVehiclesUsecase();

//       failureOrVehicles.fold(
//         (failure) => emit(VehicleError(_mapFailureToMessage(failure))),
//         (vehicles) => emit(VehicleLoaded(vehicles)),
//       );
//     });
//   }

//  String _mapFailureToMessage(Failure failure) {
//   if (failure is ApiFailure) {
//     return failure.message;
//   }
//   return 'Unexpected error';
// }
// }
import 'package:finalyearproject/features/home/domain/entity/vehicle.dart';
import 'package:finalyearproject/features/home/domain/use_case/get_all_vehicles_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'vehicle_event.dart';
import 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final GetAllVehiclesUsecase getAllVehiclesUsecase;

  VehicleBloc({required this.getAllVehiclesUsecase}) : super(VehicleInitial()) {
    on<FetchVehiclesEvent>(_onFetchVehicles);
    on<FilterVehiclesEvent>(_onFilterVehicles);
  }

  void _onFetchVehicles(FetchVehiclesEvent event, Emitter<VehicleState> emit) async {
    emit(VehicleLoading());
    final failureOrVehicles = await getAllVehiclesUsecase();

    failureOrVehicles.fold(
      (failure) => emit(VehicleError(_mapFailureToMessage(failure))),
      (vehicles) {
        // Extract unique vehicle types from the fetched data
        final types = vehicles.map((v) => v.vehicleType).toSet().toList();
        // Add "All" to the beginning of the list
        types.insert(0, "All");

        emit(VehicleLoaded(
          allVehicles: vehicles,
          filteredVehicles: vehicles, // Initially, show all vehicles
          vehicleTypes: types,
          selectedType: "All", // "All" is selected by default
        ));
      },
    );
  }

  void _onFilterVehicles(FilterVehiclesEvent event, Emitter<VehicleState> emit) {
    final currentState = state;
    if (currentState is VehicleLoaded) {
      List<VehicleEntity> filteredList;
      if (event.vehicleType == "All") {
        // If "All" is selected, show the complete list
        filteredList = currentState.allVehicles;
      } else {
        // Otherwise, filter the list based on the selected type
        filteredList = currentState.allVehicles
            .where((vehicle) => vehicle.vehicleType == event.vehicleType)
            .toList();
      }

      // Emit the new state with the filtered list and the new selected type
      emit(currentState.copyWith(
        filteredVehicles: filteredList,
        selectedType: event.vehicleType,
      ));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ApiFailure) {
      return failure.message;
    }
    return 'Unexpected error';
  }
}