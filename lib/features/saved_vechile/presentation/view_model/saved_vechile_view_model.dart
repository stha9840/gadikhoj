import 'package:finalyearproject/features/saved_vechile/domain/usecase/add_saved_vechile_usecase.dart';
import 'package:finalyearproject/features/saved_vechile/domain/usecase/get_saved_vechile_usecase.dart';
import 'package:finalyearproject/features/saved_vechile/domain/usecase/remove_saved_vechile_usecase.dart';
import 'package:finalyearproject/features/saved_vechile/presentation/view_model/saved_vechile_event.dart';
import 'package:finalyearproject/features/saved_vechile/presentation/view_model/saved_vechile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavedVehicleBloc extends Bloc<SavedVehicleEvent, SavedVehicleState> {
  final GetSavedVehiclesUsecase _getSavedVehiclesUsecase;
  final AddSavedVehicleUsecase _addSavedVehicleUsecase;
  final RemoveSavedVehicleUsecase _removeSavedVehicleUsecase;

  SavedVehicleBloc({
    required GetSavedVehiclesUsecase getSavedVehiclesUsecase,
    required AddSavedVehicleUsecase addSavedVehicleUsecase,
    required RemoveSavedVehicleUsecase removeSavedVehicleUsecase,
  })  : _getSavedVehiclesUsecase = getSavedVehiclesUsecase,
        _addSavedVehicleUsecase = addSavedVehicleUsecase,
        _removeSavedVehicleUsecase = removeSavedVehicleUsecase,
        super(SavedVehicleInitial()) {
    on<GetSavedVehicles>(_onGetSavedVehicles);
    on<AddVehicleToSaved>(_onAddVehicleToSaved);
    on<RemoveVehicleFromSaved>(_onRemoveVehicleFromSaved);
  }

  Future<void> _onGetSavedVehicles(
    GetSavedVehicles event,
    Emitter<SavedVehicleState> emit,
  ) async {
    emit(SavedVehicleLoading());
    final result = await _getSavedVehiclesUsecase();
    result.fold(
      (failure) => emit(SavedVehicleError(message: failure.message)),
      (vehicles) => emit(SavedVehicleSuccess(savedVehicles: vehicles)),
    );
  }

  Future<void> _onAddVehicleToSaved(
    AddVehicleToSaved event, // <-- Event now has vehicleId
    Emitter<SavedVehicleState> emit,
  ) async {
    emit(SavedVehicleLoading());

    final params = AddSavedVehicleParams(vehicleId: event.vehicleId);
    final result = await _addSavedVehicleUsecase(params);
    // ---- END OF FIX ----

    result.fold(
      (failure) => emit(SavedVehicleError(message: failure.message)),
      (_) {
        emit(const SavedVehicleActionSuccess(message: 'Vehicle Saved!'));
        add(GetSavedVehicles());
      },
    );
  }

  Future<void> _onRemoveVehicleFromSaved(
    RemoveVehicleFromSaved event, 
    Emitter<SavedVehicleState> emit,
  ) async {
 
    final params = RemoveSavedVehicleParams(vehicleId: event.vehicleId); 
    final result = await _removeSavedVehicleUsecase(params);

    result.fold(
      (failure) => emit(SavedVehicleError(message: failure.message)),
      (_) {
        emit(const SavedVehicleActionSuccess(message: 'Vehicle Removed!'));
        add(GetSavedVehicles());
      },
    );
  }
}