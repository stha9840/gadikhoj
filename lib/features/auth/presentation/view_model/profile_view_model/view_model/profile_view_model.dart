// features/auth/presentation/view_model/user_view_model/user_bloc.dart

import 'package:finalyearproject/core/utils/snackbar_helper.dart';
import 'package:finalyearproject/features/auth/domain/use_case/user_delete_usecase.dart';
import 'package:finalyearproject/features/auth/domain/use_case/user_get_usecase.dart';
import 'package:finalyearproject/features/auth/domain/use_case/user_update_usecase.dart';

import 'package:finalyearproject/features/auth/presentation/view/login_view.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/profile_view_model/view_model/profile_event.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/profile_view_model/view_model/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserViewModel extends Bloc<UserEvent, UserState> {
  final GetUserUseCase _getUserUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final DeleteUserUseCase _deleteUserUseCase;

  UserViewModel({
    required GetUserUseCase getUserUseCase,
    required UpdateUserUseCase updateUserUseCase,
    required DeleteUserUseCase deleteUserUseCase,
  })  : _getUserUseCase = getUserUseCase,
        _updateUserUseCase = updateUserUseCase,
        _deleteUserUseCase = deleteUserUseCase,
        super(UserInitial()) {
    on<GetUserEvent>(_getUser);
    on<UpdateUserEvent>(_updateUser);
    on<DeleteUserEvent>(_deleteUser);
  }

  Future<void> _getUser(
    GetUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    final result = await _getUserUseCase();
    result.fold(
      (failure) => emit(UserFailure(message: failure.message)),
      (user) => emit(UserLoaded(user: user)),
    );
  }

  Future<void> _updateUser(
    UpdateUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    final result = await _updateUserUseCase(
        UpdateUserParams(userId: event.userId, user: event.user));
    result.fold(
      (failure) {
        emit(UserFailure(message: failure.message));
        showMySnackBar(context: event.context, message: failure.message);
      },
      (_) {
        emit(const UserSuccess(message: "Profile updated successfully!"));
        showMySnackBar(context: event.context, message: "Profile updated successfully!");
        // Optionally, you can re-fetch the user data to show the updated info
        add(GetUserEvent());
      },
    );
  }

  Future<void> _deleteUser(
    DeleteUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    final result = await _deleteUserUseCase(DeleteUserParams(userId: event.userId));
    result.fold(
      (failure) {
        emit(UserFailure(message: failure.message));
        showMySnackBar(context: event.context, message: failure.message,);
      },
      (_) {
        emit(const UserSuccess(message: "Account deleted successfully."));
        showMySnackBar(context: event.context, message: "Account deleted successfully.");
        Navigator.of(event.context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) =>  LoginView()),
          (Route<dynamic> route) => false,
        );
      },
    );
  }
}