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
    String? token,
  ) async {
    try {
      final bookings = await _remoteDatasource.getUserBookings(token);
      print('booking repository $bookings');
      return Right(bookings);
    } catch (e) {
      return Left(
        ApiFailure(
          message: "Failed to fetch bookings repsotory : ${e.toString()}",
        ),
      );
    }
  }
}
