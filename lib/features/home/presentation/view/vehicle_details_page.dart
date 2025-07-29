import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:finalyearproject/features/home/domain/entity/vehicle.dart';
import 'package:finalyearproject/features/home/domain/use_case/create_booking_usecase.dart';
import 'package:finalyearproject/features/home/presentation/view/booking_view.dart';
import 'package:finalyearproject/features/home/presentation/view_model/Booking/booking_view_model.dart';

class VehicleDetailsView extends StatelessWidget {
  final VehicleEntity vehicle;

  const VehicleDetailsView({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      // App bar with just the title
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "Vehicle Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Column(
        children: [
          // Top vehicle image (NO HERO)
          SizedBox(
            height: size.height * 0.25,
            width: double.infinity,
            child: Image.network(
              'http://192.168.101.4:5000/uploads/${vehicle.filepath}',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Center(
                child: Icon(Icons.broken_image, size: 100, color: Colors.grey),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),

          // Content below image
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: ListView(
                children: [
                  // Name and price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vehicle.vehicleName,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            vehicle.vehicleType,
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "NPR ${vehicle.pricePerTrip.toStringAsFixed(0)}",
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            "/trip",
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Vehicle specs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _specBox(FontAwesomeIcons.gasPump, "${vehicle.fuelCapacityLitres}L", "Fuel"),
                      _specBox(FontAwesomeIcons.weightHanging, "${vehicle.loadCapacityKg}kg", "Load"),
                      _specBox(FontAwesomeIcons.userGroup, vehicle.passengerCapacity, "Seats"),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Description section
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    vehicle.vehicleDescription ?? "No description available.",
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade700, height: 1.6),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Rent Now button at the bottom
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => BookingBloc(
                    createBookingUsecase: context.read<CreateBookingUsecase>(),
                  ),
                  child: BookingScreen(vehicle: vehicle),
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 2,
          ),
          child: const Text("Rent Now", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  // Vehicle spec box
  Widget _specBox(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 22, color: Colors.grey.shade700),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }
}
