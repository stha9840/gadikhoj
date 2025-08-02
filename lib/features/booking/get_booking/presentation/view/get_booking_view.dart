import 'package:finalyearproject/app/service_locator/service_locator.dart';
import 'package:finalyearproject/features/booking/get_booking/presentation/view_model/get_booking_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalyearproject/features/booking/get_booking/presentation/view_model/get_booking_event.dart';
import 'package:finalyearproject/features/booking/get_booking/presentation/view_model/get_booking_state.dart';
import 'package:finalyearproject/features/booking/get_booking/domain/entity/booking.dart';

class GetBookingView extends StatelessWidget {
  const GetBookingView({super.key});

  @override
  Widget build(BuildContext context) {
    final getBookingBloc = serviceLocator<GetBookingBloc>();
    getBookingBloc.add(GetUserBookingsEvent());
    return BlocProvider<GetBookingBloc>.value(
      value: getBookingBloc,
      child: const BookingListScreen(),
    );
  }
}

class BookingListScreen extends StatelessWidget {
  const BookingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Bookings")),
      body: BlocBuilder<GetBookingBloc, GetBookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookingError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is BookingLoaded) {
            final bookings = state.bookings;

            if (bookings.isEmpty) {
              return const Center(child: Text("No bookings found."));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                return _buildBookingCard(bookings[index]);
              },
            );
          }

          return const SizedBox.shrink(); // Initial or unknown states
        },
      ),
    );
  }

  Widget _buildBookingCard(BookingEntity booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Vehicle: ${booking.vehicleId}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text("From: ${booking.startDate}"),
            Text("To: ${booking.endDate}"),
            Text("Pickup: ${booking.pickupLocation}"),
            Text("Drop: ${booking.dropLocation}"),
            const SizedBox(height: 8),
            Text(
              "Status: ${booking.status ?? 'Pending'}",
              style: TextStyle(
                color: booking.status == 'cancelled' ? Colors.red : Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
