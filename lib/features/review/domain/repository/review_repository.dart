import 'package:dartz/dartz.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/review/domain/entity/review_entity.dart';

abstract class ReviewRepository {
  // To get all reviews and calculate average on the client side
  Future<Either<Failure, List<ReviewEntity>>> getAllReviews();

  // To add a new review for a specific vehicle
  Future<Either<Failure, bool>> addReview(ReviewEntity review);
}