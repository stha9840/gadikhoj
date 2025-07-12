import 'package:finalyearproject/features/home/domain/entity/vehicle.dart';
import 'package:finalyearproject/features/home/presentation/view_model/Booking/booking_event.dart';
import 'package:finalyearproject/features/home/presentation/view_model/Booking/booking_state.dart';
import 'package:finalyearproject/features/home/presentation/view_model/Booking/booking_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final VehicleEntity vehicle;

  const BookingScreen({Key? key, required this.vehicle}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _startDate;
  DateTime? _endDate;
  final _pickupController = TextEditingController();
  final _dropController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(picked)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select start and end dates')),
        );
        return;
      }

      final totalDays = _endDate!.difference(_startDate!).inDays + 1;
      final totalPrice = widget.vehicle.pricePerTrip * totalDays;

      context.read<BookingBloc>().add(
        SubmitBooking(
          vehicleId: widget.vehicle.id!,
          startDate: _startDate!,
          endDate: _endDate!,
          pickupLocation: _pickupController.text,
          dropLocation: _dropController.text,
          totalPrice: totalPrice,
        ),
      );
    }
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _dropController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = widget.vehicle;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Vehicle'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Booking created successfully')),
            );
            Navigator.pop(context);
          } else if (state is BookingFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is BookingSubmitting) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Job Card-like Details
                  Center(
                    child: Image.network(
                      'http://192.168.157.46:5000/uploads/${vehicle.filepath}',
                      height: 140,
                      fit: BoxFit.contain,
                      errorBuilder:
                          (_, __, ___) =>
                              const Icon(Icons.broken_image, size: 80),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    vehicle.vehicleName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    vehicle.vehicleType,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _specTile(
                        FontAwesomeIcons.gasPump,
                        '${vehicle.fuelCapacityLitres} Litres',
                      ),
                      _specTile(
                        FontAwesomeIcons.weightHanging,
                        '${vehicle.loadCapacityKg} Kg',
                      ),
                      _specTile(
                        FontAwesomeIcons.userGroup,
                        vehicle.passengerCapacity,
                      ),
                    ],
                  ),
                  const Divider(height: 30),

                  // Date Selection & Input Fields
                  _buildDateField(
                    label: 'Start Date',
                    date: _startDate,
                    onTap: () => _selectDate(context, true),
                  ),
                  const SizedBox(height: 16),
                  _buildDateField(
                    label: 'End Date',
                    date: _endDate,
                    onTap: () => _selectDate(context, false),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _pickupController,
                    label: 'Pickup Location',
                    icon: Icons.location_on,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _dropController,
                    label: 'Drop Location',
                    icon: Icons.location_on_outlined,
                  ),

                  const SizedBox(height: 20),

                  if (_startDate != null && _endDate != null)
                    _buildTotalPriceCard(vehicle),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Confirm Booking'),
                      onPressed: _submitBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTotalPriceCard(VehicleEntity vehicle) {
    final totalDays = _endDate!.difference(_startDate!).inDays + 1;
    final totalPrice = vehicle.pricePerTrip * totalDays;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Total Price', style: TextStyle(fontSize: 16)),
          Text(
            'Npr ${totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(
        text: date == null ? '' : _dateFormat.format(date),
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.calendar_today),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onTap: onTap,
      validator:
          (value) =>
              value == null || value.isEmpty ? '$label is required' : null,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator:
          (value) =>
              value == null || value.isEmpty ? '$label is required' : null,
    );
  }

  Widget _specTile(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(height: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
