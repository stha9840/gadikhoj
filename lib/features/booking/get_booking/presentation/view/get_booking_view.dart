import 'package:finalyearproject/app/service_locator/service_locator.dart';
import 'package:finalyearproject/features/booking/get_booking/presentation/view_model/get_booking_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalyearproject/features/booking/get_booking/presentation/view_model/get_booking_event.dart';
import 'package:finalyearproject/features/booking/get_booking/presentation/view_model/get_booking_state.dart';
import 'package:finalyearproject/features/booking/get_booking/domain/entity/booking.dart';
import 'package:intl/intl.dart';

class GetBookingView extends StatelessWidget {
  const GetBookingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              serviceLocator<BookingViewModel>()..add(
                GetUserBookings(),
              ), // Dispatch the initial event right after creation
      child: const BookingListScreen(),
    );
  }
}

// Converted to a StatefulWidget to fetch bookings only once.
class BookingListScreen extends StatefulWidget {
  const BookingListScreen({super.key});

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  @override
  void initState() {
    super.initState();
    // Dispatch the event to fetch bookings when the screen is initialized.
    context.read<BookingViewModel>().add(GetUserBookings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("My Bookings"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: BlocBuilder<BookingViewModel, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          } else if (state is BookingError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: TextStyle(color: Colors.red[700], fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else if (state is BookingLoaded) {
            final bookings = state.bookings;

            if (bookings.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      "No bookings found",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Your booking history will appear here",
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<BookingViewModel>().add(GetUserBookings());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          // Pass the ViewModel to the details page
                          builder:
                              (_) => BlocProvider.value(
                                value: context.read<BookingViewModel>(),
                                child: BookingDetailsPage(booking: booking),
                              ),
                        ),
                      );
                    },
                    child: _buildBookingCard(booking),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBookingCard(BookingEntity booking) {
    // ... (This widget remains unchanged)
    final dateFormatter = DateFormat('MMM dd, yyyy');
    final vehicleName = booking.vehicle?.vehicleName ?? 'Unknown Vehicle';
    final vehicleType = booking.vehicle?.vehicleType ?? 'Unknown Type';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.grey[50]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.directions_car,
                      color: Colors.blue[600],
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicleName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          vehicleType,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(booking.status),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildDetailItem(
                      icon: Icons.calendar_today,
                      label: "From",
                      value: dateFormatter.format(booking.startDate),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDetailItem(
                      icon: Icons.event,
                      label: "To",
                      value: dateFormatter.format(booking.endDate),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDetailItem(
                      icon: Icons.location_on,
                      label: "Pickup",
                      value: booking.pickupLocation,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDetailItem(
                      icon: Icons.flag,
                      label: "Drop",
                      value: booking.dropLocation,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Price",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.green[700],
                      ),
                    ),
                    Text(
                      "Rs. ${booking.totalPrice.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookingDetailsPage extends StatelessWidget {
  final BookingEntity booking;

  const BookingDetailsPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('MMM dd, yyyy');
    final vehicleName = booking.vehicle?.vehicleName ?? 'Unknown Vehicle';
    final vehicleType = booking.vehicle?.vehicleType ?? 'Unknown Type';
    final vehicleImage = booking.vehicle?.filepath ?? '';

    return BlocListener<BookingViewModel, BookingState>(
      // Listen for state changes to show snackbars or navigate
      listener: (context, state) {
        if (state is BookingError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is BookingLoaded) {
          // When list reloads after an action, pop the details page
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text("Action Successful!"),
                backgroundColor: Colors.green,
              ),
            );
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text("Booking Details"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 1,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ... (Image and details section remains unchanged)
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child:
                    vehicleImage.isNotEmpty
                        ? ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          child: Image.network(
                            vehicleImage,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildPlaceholderImage();
                            },
                          ),
                        )
                        : _buildPlaceholderImage(),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vehicleName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                vehicleType,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildStatusChip(booking.status),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildDetailItem(
                      icon: Icons.calendar_today,
                      label: "Start Date",
                      value: dateFormatter.format(booking.startDate),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailItem(
                      icon: Icons.event,
                      label: "End Date",
                      value: dateFormatter.format(booking.endDate),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailItem(
                      icon: Icons.location_on,
                      label: "Pickup Location",
                      value: booking.pickupLocation,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailItem(
                      icon: Icons.flag,
                      label: "Drop Location",
                      value: booking.dropLocation,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Total Price: Rs. ${booking.totalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // ✅ NEW: Action buttons section
                    _buildActionButtons(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ NEW: Widget to build action buttons
  Widget _buildActionButtons(BuildContext context) {
    // Only show buttons if the booking is in a cancellable state
    final bool canCancel =
        booking.status != 'cancelled' && booking.status != 'completed';

    if (!canCancel) {
      return const SizedBox.shrink(); // Don't show any buttons
    }

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.cancel_outlined),
            label: const Text("Cancel Booking"),
            onPressed: () {
              _showConfirmationDialog(
                context: context,
                title: "Cancel Booking?",
                content: "Are you sure you want to cancel this booking?",
                onConfirm: () {
                  // Dispatch the cancel event
                  context.read<BookingViewModel>().add(
                    CancelBooking(booking.id!),
                  );
                },
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.delete_outline),
            label: const Text("Delete"),
            onPressed: () {
              _showConfirmationDialog(
                context: context,
                title: "Delete Booking?",
                content:
                    "This action is permanent and cannot be undone. Are you sure?",
                onConfirm: () {
                  // Dispatch the delete event
                  context.read<BookingViewModel>().add(
                    DeleteBooking(booking.id!),
                  );
                },
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black54,
              side: const BorderSide(color: Colors.black54),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  // ✅ NEW: Reusable confirmation dialog
  void _showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss the dialog
                onConfirm(); // Execute the action
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPlaceholderImage() {
    // ... (This widget remains unchanged)
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_car, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              "No Image Available",
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// These two helper widgets remain unchanged
Widget _buildStatusChip(String? status) {
  // ... (no changes needed)
  final statusText = status?.toLowerCase() ?? 'pending';
  Color backgroundColor;
  Color textColor;
  IconData icon;

  switch (statusText) {
    case 'confirmed':
    case 'active':
      backgroundColor = Colors.green[100]!;
      textColor = Colors.green[700]!;
      icon = Icons.check_circle;
      break;
    case 'cancelled':
      backgroundColor = Colors.red[100]!;
      textColor = Colors.red[700]!;
      icon = Icons.cancel;
      break;
    case 'completed':
      backgroundColor = Colors.blue[100]!;
      textColor = Colors.blue[700]!;
      icon = Icons.done_all;
      break;
    default:
      backgroundColor = Colors.orange[100]!;
      textColor = Colors.orange[700]!;
      icon = Icons.schedule;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: textColor),
        const SizedBox(width: 4),
        Text(
          status?.toUpperCase() ?? 'PENDING',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}

Widget _buildDetailItem({
  required IconData icon,
  required String label,
  required String value,
}) {
  // ... (no changes needed)
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}
