// features/reviews/domain/use_case/get_all_reviews_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/review/domain/entity/review_entity.dart';
import 'package:finalyearproject/features/review/domain/repository/review_repository.dart';

class GetAllReviewsUsecase {
  final ReviewRepository repository;

  GetAllReviewsUsecase({required this.repository});

  Future<Either<Failure, List<ReviewEntity>>> call() async {
    return await repository.getAllReviews();
  }
}