// lib/features/booking/presentation/view_model/booking_state.dart

import 'package:equatable/equatable.dart';
import 'package:finalyearproject/features/booking/get_booking/domain/entity/booking.dart';

abstract class BookingState extends Equatable {
  const BookingState();
  
  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final List<BookingEntity> bookings;

  const BookingLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

class BookingError extends BookingState {
  final String message;

  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
}

// Optional: Add states for showing temporary messages (like a Snackbar)
// without losing the main list view.
// class BookingActionSuccess extends BookingState {
//   final String message;
//   const BookingActionSuccess(this.message);
//   @override
//   List<Object?> get props => [message];
// }