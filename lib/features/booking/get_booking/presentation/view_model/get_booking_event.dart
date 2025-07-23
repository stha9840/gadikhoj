// lib/features/booking/presentation/view_model/booking_event.dart

import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

// Event to fetch all bookings for the logged-in user
class GetUserBookings extends BookingEvent {}

// Event to cancel a specific booking
class CancelBooking extends BookingEvent {
  final String bookingId;

  const CancelBooking(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}

// Event to delete a specific booking
class DeleteBooking extends BookingEvent {
  final String bookingId;

  const DeleteBooking(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}

class UpdateBooking extends BookingEvent {
  final String id;
  final Map<String, dynamic> data;

  const UpdateBooking({
    required this.id,
    required this.data,
  });

}
