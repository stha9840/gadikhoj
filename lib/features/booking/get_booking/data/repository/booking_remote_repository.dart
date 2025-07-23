// lib/features/booking/get_booking/data/repository/get_booking_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:finalyearproject/core/error/failure.dart';
import 'package:finalyearproject/features/booking/get_booking/data/data_source/get_booking_datasource.dart';
import 'package:finalyearproject/features/booking/get_booking/domain/entity/booking.dart';
import 'package:finalyearproject/features/booking/get_booking/domain/repository/get_booking_repository.dart';

class GetBookingRemoteRepository implements IBookingRepository {
  final IGetBookingDatasource _remoteDatasource;

  GetBookingRemoteRepository({required IGetBookingDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  @override
  Future<Either<Failure, List<BookingEntity>>> getUserBookings(
    String token,
  ) async {
    try {
      final bookings = await _remoteDatasource.getUserBookings(token);
      return Right(bookings);
    } catch (e) {
      return Left(
        ApiFailure(
          message: "Failed to fetch bookings in repository: ${e.toString()}",
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> cancelUserBooking(String id, String token) async {
    try {
      final result = await _remoteDatasource.cancelUserBooking(id, token);
      return Right(result);
    } catch (e) {
      return Left(
        ApiFailure(
          message: "Failed to cancel booking in repository: ${e.toString()}",
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteUserBooking(String id, String token) async {
    try {
      final result = await _remoteDatasource.deleteUserBooking(id, token);
      return Right(result);
    } catch (e) {
      return Left(
        ApiFailure(
          message: "Failed to delete booking in repository: ${e.toString()}",
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateUserBooking(
      String id, Map<String, dynamic> data, String token) async {
    try {
      final result = await _remoteDatasource.updateUserBooking(id, data, token);
      return Right(result);
    } catch (e) {
      return Left(
        ApiFailure(
          message: "Failed to update booking in repository: ${e.toString()}",
        ),
      );
    }
  }
}