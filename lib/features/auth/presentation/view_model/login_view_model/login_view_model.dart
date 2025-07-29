import 'package:finalyearproject/core/utils/snackbar_helper.dart';
import 'package:finalyearproject/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:finalyearproject/features/navigation/presentation/view/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:finalyearproject/features/auth/presentation/view/register_view.dart'; // make sure this import exists

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUsecase _userLoginUsecase;

  LoginViewModel({required UserLoginUsecase userLoginUsecase})
    : _userLoginUsecase = userLoginUsecase,
      super(LoginInitial()) {
    on<LoginWithEmailAndPasswordEvent>(_loginUser);
    on<NavigateToRegisterViewEvent>(_navigateToRegister);
  }

// login_view_model.dart

Future<void> _loginUser(
  LoginWithEmailAndPasswordEvent event,
  Emitter<LoginState> emit,
) async {
  emit(LoginLoading());
  final result = await _userLoginUsecase(
    UserLoginParams(email: event.email, password: event.password),
  );
  result.fold(
    (failure) {
      // Just emit the failure state. The View will handle the snackbar.
      emit(LoginFailure(message: failure.message));
    },
    (user) {
      // Just emit the success state. The View will handle navigation.
      emit(LoginSuccess());
    },
  );
}

  Future<void> _navigateToRegister(
    NavigateToRegisterViewEvent event,
    Emitter<LoginState> emit,
  ) async {
    Navigator.push(
      event.context,
      MaterialPageRoute(builder: (_) => SignUpView()),
    );
  }
}
