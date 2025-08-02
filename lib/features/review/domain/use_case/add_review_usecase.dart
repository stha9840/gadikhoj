// features/reviews/domain/use_case/add_review_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/review/domain/entity/review_entity.dart';
import 'package:finalyearproject/features/review/domain/repository/review_repository.dart';

class AddReviewUsecase {
  final ReviewRepository repository;

  AddReviewUsecase({required this.repository});

  Future<Either<Failure, bool>> call(ReviewEntity review) async {
    return await repository.addReview(review);
  }
}