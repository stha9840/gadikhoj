// booking_event.dart
import 'package:equatable/equatable.dart';

class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class SubmitBooking extends BookingEvent {
  final String vehicleId;
  final DateTime startDate;
  final DateTime endDate;
  final String pickupLocation;
  final String dropLocation;
  final double totalPrice;

  SubmitBooking({
    required this.vehicleId,
    required this.startDate,
    required this.endDate,
    required this.pickupLocation,
    required this.dropLocation,
    required this.totalPrice,
  });

  @override
  List<Object?> get props =>
      [vehicleId, startDate, endDate, pickupLocation, dropLocation, totalPrice];
}
