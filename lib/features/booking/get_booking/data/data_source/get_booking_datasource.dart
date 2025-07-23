  import 'package:finalyearproject/features/booking/get_booking/domain/entity/booking.dart';

  abstract interface class IGetBookingDatasource {
    Future<List<BookingEntity>> getUserBookings(String? token);
  }
