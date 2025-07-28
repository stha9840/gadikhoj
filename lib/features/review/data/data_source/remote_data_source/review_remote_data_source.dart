// // features/reviews/data/data_source/review_remote_data_source.dart

// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:finalyearproject/app/constant/api_endpoints.dart';
// import 'package:finalyearproject/features/review/data/model/review_model.dart';
// // Your API constants

// class ReviewRemoteDataSource {
//   final Dio dio;

//   ReviewRemoteDataSource({required this.dio});

//   Future<List<ReviewModel>> getAllReviews() async {
//     try {
//       // Assuming you have an endpoint to get all reviews
//       final response = await dio.get(ApiEndpoints.reviews);
//       if (response.statusCode == 200) {
//         final List<dynamic> data = response.data['reviews']; // Adjust key based on your API response
//         return data.map((json) => ReviewModel.fromJson(json)).toList();
//       } else {
//         throw Exception('Failed to load reviews');
//       }
//     } catch (e) {
//       throw Exception('Error getting reviews: $e');
//     }
//   }

//   Future<bool> addReview(ReviewModel review) async {
//     try {
//       final response = await dio.post(
//         ApiEndpoints.reviews, // Assuming POST to /reviews adds a new one
//         data: review.toJson(),
//       );
//       return response.statusCode == 201 || response.statusCode == 200;
//     } catch (e) {
//       throw Exception('Failed to add review: $e');
//     }
//   }
// }