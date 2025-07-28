// // features/reviews/data/repository/review_repository_impl.dart

// import 'package:dartz/dartz.dart';
// import 'package:finalyearproject/core/error/failure.dart';
// import 'package:finalyearproject/features/review/data/data_source/remote_data_source/review_remote_data_source.dart';
// import 'package:finalyearproject/features/review/data/model/review_model.dart';
// import 'package:finalyearproject/features/review/domain/entity/review_entity.dart';
// import 'package:finalyearproject/features/review/domain/repository/review_repository.dart';

// class ReviewRepositoryImpl implements ReviewRepository {
//   final ReviewRemoteDataSource remoteDataSource;

//   ReviewRepositoryImpl({required this.remoteDataSource});

//   @override
//   Future<Either<Failure, List<ReviewEntity>>> getAllReviews() async {
//     try {
//       final reviews = await remoteDataSource.getAllReviews();
//       return Right(reviews);
//     _} catch (e) {
//       return Left(Failure(error: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, bool>> addReview(ReviewEntity review) async {
//     try {
//       // You might need to cast the entity to a model if it has toJson
//       // This implementation assumes ReviewEntity can be converted
//       final result = await remoteDataSource.addReview(review as ReviewModel);
//       return Right(result);
//     } catch (e) {
//       return Left(Failure(error: e.toString()));
//     }
//   }
// }