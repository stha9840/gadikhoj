

import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String? id;
  final String userId;
  final String vehicleId;
  final int rating;
  final String comment;

  const ReviewEntity({
    this.id,
    required this.userId,
    required this.vehicleId,
    required this.rating,
    required this.comment,
  });

  @override
  List<Object?> get props => [id, userId, vehicleId, rating, comment];
}