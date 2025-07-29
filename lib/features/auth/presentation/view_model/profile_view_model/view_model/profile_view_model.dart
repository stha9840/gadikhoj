import 'package:finalyearproject/features/auth/domain/use_case/user_delete_usecase.dart';
import 'package:finalyearproject/features/auth/domain/use_case/user_get_usecase.dart';
import 'package:finalyearproject/features/auth/domain/use_case/user_update_usecase.dart';
import 'package:finalyearproject/features/auth/domain/use_case/logout_user_usecase.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/profile_view_model/view_model/profile_event.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/profile_view_model/view_model/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserViewModel extends Bloc<UserEvent, UserState> {
  final GetUserUseCase _getUserUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final DeleteUserUseCase _deleteUserUseCase;
  final LogoutUserUsecase _logoutUserUsecase;

  UserViewModel({
    required GetUserUseCase getUserUseCase,
    required UpdateUserUseCase updateUserUseCase,
    required DeleteUserUseCase deleteUserUseCase,
    required LogoutUserUsecase logoutUserUsecase,
  })  : _getUserUseCase = getUserUseCase,
        _updateUserUseCase = updateUserUseCase,
        _deleteUserUseCase = deleteUserUseCase,
        _logoutUserUsecase = logoutUserUsecase,
        super(UserInitial()) {
    on<GetUserEvent>(_getUser);
    on<UpdateUserEvent>(_updateUser);
    on<DeleteUserEvent>(_deleteUser);
    on<LogoutEvent>(_logoutUser);
  }

  // THIS IS THE CORRECTED _getUser METHOD
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
      UpdateUserParams(userId: event.userId, user: event.user),
    );
    result.fold(
      (failure) => emit(UserFailure(message: failure.message)),
      (_) {
        emit(const UserSuccess(message: "Profile updated successfully!"));
        add(const GetUserEvent());
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
      (failure) => emit(UserFailure(message: failure.message)),
      (_) => emit(const UserLoggedOut()),
    );
  }

  Future<void> _logoutUser(
    LogoutEvent event,
    Emitter<UserState> emit,
  ) async {
    final result = await _logoutUserUsecase();
    result.fold(
      (failure) => emit(UserFailure(message: failure.message)),
      (_) => emit(const UserLoggedOut()),
    );
  }
}