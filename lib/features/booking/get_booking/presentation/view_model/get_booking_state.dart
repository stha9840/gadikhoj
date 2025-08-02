// booking_state.dart
import 'package:equatable/equatable.dart';
import 'package:finalyearproject/features/booking/get_booking/domain/entity/booking.dart';

abstract class GetBookingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BookingInitial extends GetBookingState {}

class BookingLoading extends GetBookingState {}

class BookingLoaded extends GetBookingState {
  final List<BookingEntity> bookings;

  BookingLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

class BookingError extends GetBookingState {
  final String message;

  BookingError(this.message);

  @override
  List<Object?> get props => [message];
}
