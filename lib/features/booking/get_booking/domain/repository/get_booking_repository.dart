import 'package:dartz/dartz.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/booking/get_booking/domain/entity/booking.dart';

abstract interface class IBookingRepository {
  Future<Either<Failure, List<BookingEntity>>> getUserBookings(String token);
   Future<Either<Failure, void>> updateUserBooking(
      String id, Map<String, dynamic> data, String token);
  Future<Either<Failure, void>> deleteUserBooking(String id , String token);
  Future<Either<Failure, void>> cancelUserBooking(String id , String token);
}
