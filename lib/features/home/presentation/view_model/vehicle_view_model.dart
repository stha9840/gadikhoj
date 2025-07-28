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
    on<SearchVehiclesEvent>(_onSearchVehicles); // Register search event handler
  }

  // Helper method to apply both type and search filters
  List<VehicleEntity> _applyFilters({
    required List<VehicleEntity> allVehicles,
    required String selectedType,
    required String searchQuery,
  }) {
    List<VehicleEntity> vehicles = allVehicles;

    // 1. Apply type filter
    if (selectedType != "All") {
      vehicles = vehicles.where((v) => v.vehicleType == selectedType).toList();
    }

    // 2. Apply search filter
    if (searchQuery.isNotEmpty) {
      vehicles = vehicles
          .where((v) => v.vehicleName.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    return vehicles;
  }

  void _onFetchVehicles(FetchVehiclesEvent event, Emitter<VehicleState> emit) async {
    emit(VehicleLoading());
    final failureOrVehicles = await getAllVehiclesUsecase();

    failureOrVehicles.fold(
      (failure) => emit(VehicleError(_mapFailureToMessage(failure))),
      (vehicles) {
        final types = vehicles.map((v) => v.vehicleType).toSet().toList();
        types.insert(0, "All");

        emit(VehicleLoaded(
          allVehicles: vehicles,
          filteredVehicles: vehicles, // Initially show all
          vehicleTypes: types,
          selectedType: "All",
          searchQuery: '', // Initialize with an empty search query
        ));
      },
    );
  }

  void _onFilterVehicles(FilterVehiclesEvent event, Emitter<VehicleState> emit) {
    final currentState = state;
    if (currentState is VehicleLoaded) {
      // Use the helper to re-apply filters with the new type
      final filteredList = _applyFilters(
        allVehicles: currentState.allVehicles,
        selectedType: event.vehicleType, // New type
        searchQuery: currentState.searchQuery, // Keep the existing search query
      );

      emit(currentState.copyWith(
        filteredVehicles: filteredList,
        selectedType: event.vehicleType,
      ));
    }
  }

  // Handler for the search event
  void _onSearchVehicles(SearchVehiclesEvent event, Emitter<VehicleState> emit) {
    final currentState = state;
    if (currentState is VehicleLoaded) {
      // Use the helper to re-apply filters with the new search query
      final filteredList = _applyFilters(
        allVehicles: currentState.allVehicles,
        selectedType: currentState.selectedType, // Keep the existing type
        searchQuery: event.query, // New search query
      );

      emit(currentState.copyWith(
        filteredVehicles: filteredList,
        searchQuery: event.query, // Update the search query in the state
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