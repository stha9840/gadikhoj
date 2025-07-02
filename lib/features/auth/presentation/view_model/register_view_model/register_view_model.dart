
import 'package:finalyearproject/core/utils/snackbar_helper.dart';
import 'package:finalyearproject/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterViewModel extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUserUseCase _registerUsecase;

  RegisterViewModel({required RegisterUserUseCase registerUsecase})
    : _registerUsecase = registerUsecase,
      super(RegisterState.initial()) {
    on<RegisterUserEvent>(_registerUseEvent);
  }

  Future<void> _registerUseEvent(
    RegisterUserEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
  
    final result = await _registerUsecase(
      RegisterUserParams(
        name: event.username, // include this if your use case requires it
        email: event.email,
        password: event.password,
      ),
    );
    print("Register usecase result: $result"); // DEBUG

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, isSuccess: false));
        showMySnackBar(
          context: event.context,
          message: "Failed to register user : ${failure.message}",
        );
      },
      (success) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(
          context: event.context,
          message: "User Successfully register",
        );
      },
    );
  }
}
