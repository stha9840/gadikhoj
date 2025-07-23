// features/auth/presentation/view_model/user_view_model/user_event.dart

import 'package:equatable/equatable.dart';
import 'package:finalyearproject/features/auth/domain/entity/user_entity.dart';
import 'package:flutter/material.dart';

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
  final BuildContext context;
  final String userId;
  final UserEntity user;

  const UpdateUserEvent({
    required this.context,
    required this.userId,
    required this.user,
  });

  @override
  List<Object?> get props => [context, userId, user];
}

// Event to delete the user's profile
class DeleteUserEvent extends UserEvent {
  final BuildContext context;
  final String userId;

  const DeleteUserEvent({required this.context, required this.userId});

  @override
  List<Object?> get props => [context, userId];
}