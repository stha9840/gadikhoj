  import 'package:finalyearproject/features/booking/get_booking/domain/entity/booking.dart';

  abstract interface class IGetBookingDatasource {
    Future<List<BookingEntity>> getUserBookings(String? token);
     Future<void> updateUserBooking(String? id, Map<String, dynamic> data, String? token) ;
    Future<void> deleteUserBooking(String? id, String? token) ;
    Future<void> cancelUserBooking(String? id, String? token ) ;

  }
