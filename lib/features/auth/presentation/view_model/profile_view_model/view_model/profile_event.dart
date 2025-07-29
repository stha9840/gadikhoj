// features/auth/presentation/view_model/profile_view_model/view_model/profile_event.dart

import 'package:equatable/equatable.dart';
import 'package:finalyearproject/features/auth/domain/entity/user_entity.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

// Event to fetch the current user's profile
class GetUserEvent extends UserEvent {
  const GetUserEvent();
}

// Event to update the user's profile
class UpdateUserEvent extends UserEvent {
  // CLEANED: No BuildContext here
  final String userId;
  final UserEntity user;

  const UpdateUserEvent({
    required this.userId,
    required this.user,
  });

  @override
  List<Object?> get props => [userId, user];
}

// Event to delete the user's profile
class DeleteUserEvent extends UserEvent {
  // CLEANED: No BuildContext here
  final String userId;

  const DeleteUserEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

// Event for logging out
class LogoutEvent extends UserEvent {
  // ADDED: const constructor for consistency and performance
  const LogoutEvent();
}