// features/auth/presentation/view_model/user_view_model/user_state.dart

import 'package:equatable/equatable.dart';
import 'package:finalyearproject/features/auth/domain/entity/user_entity.dart';

abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

// State when the user's profile is successfully loaded
class UserLoaded extends UserState {
  final UserEntity user;

  const UserLoaded({required this.user});

  @override
  List<Object?> get props => [user];
}

// State for a successful update or delete operation
class UserSuccess extends UserState {
  final String message;
  const UserSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

// State for any failure during user operations
class UserFailure extends UserState {
  final String message;
  const UserFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
class UserLoggedOut extends UserState {
  const UserLoggedOut();
}