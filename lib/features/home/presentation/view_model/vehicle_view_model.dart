import 'package:finalyearproject/features/home/domain/use_case/get_all_vehicles_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/home/domain/entity/vehicle.dart';
import 'vehicle_event.dart';
import 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final GetAllVehiclesUsecase getAllVehiclesUsecase;

  VehicleBloc({required this.getAllVehiclesUsecase}) : super(VehicleInitial()) {
    on<FetchVehiclesEvent>((event, emit) async {
      emit(VehicleLoading());
      final failureOrVehicles = await getAllVehiclesUsecase();

      failureOrVehicles.fold(
        (failure) => emit(VehicleError(_mapFailureToMessage(failure))),
        (vehicles) => emit(VehicleLoaded(vehicles)),
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    // Customize error messages based on failure type if you want
    return failure.toString();
  }
}
