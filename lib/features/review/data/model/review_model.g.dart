// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => ReviewModel(
      reviewId: json['_id'] as String?,
      userId: json['userId'] as String,
      vehicleId: json['vehicleId'] as String,
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String,
    );

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'vehicleId': instance.vehicleId,
      'rating': instance.rating,
      'comment': instance.comment,
      '_id': instance.reviewId,
    };
