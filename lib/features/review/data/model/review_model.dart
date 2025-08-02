// features/reviews/data/model/review_model.dart


import 'package:finalyearproject/features/review/domain/entity/review_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review_model.g.dart'; // Run build_runner to generate this

@JsonSerializable()
class ReviewModel extends ReviewEntity {
  @JsonKey(name: '_id')
  final String? reviewId;

  const ReviewModel({
    this.reviewId,
    required super.userId,
    required super.vehicleId,
    required super.rating,
    required super.comment,
  }) : super(id: reviewId);

  factory ReviewModel.fromJson(Map<String, dynamic> json) => _$ReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);
}