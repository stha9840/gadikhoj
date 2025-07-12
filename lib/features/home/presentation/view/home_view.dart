import 'package:finalyearproject/features/home/domain/use_case/create_booking_usecase.dart';
import 'package:finalyearproject/features/home/presentation/view/booking_view.dart';
import 'package:finalyearproject/features/home/presentation/view_model/Booking/booking_view_model.dart';
import 'package:finalyearproject/features/home/presentation/view_model/vehicle_state.dart';
import 'package:finalyearproject/features/home/presentation/view_model/vehicle_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:finalyearproject/features/home/domain/entity/vehicle.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: BlocBuilder<VehicleBloc, VehicleState>(
            builder: (context, state) {
              if (state is VehicleLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is VehicleLoaded) {
                final vehicles = state.vehicles;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row (Location + Profile)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.location_on,
                                color: Colors.grey,
                                size: 26,
                              ),
                              SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Your location",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "Gangabu, Kathmandu",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const CircleAvatar(
                            radius: 21,
                            backgroundColor: Colors.orangeAccent,
                            child: Icon(
                              Icons.person,
                              size: 24,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Search Bar
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Search Vehicle",
                          prefixIcon: const Icon(Icons.search, size: 20),
                          suffixIcon: const Icon(Icons.tune, size: 20),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      const Text(
                        "Vehicle Type",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Filter Chips (static for now)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip("All", selected: true),
                            _buildFilterChip("Car"),
                            _buildFilterChip("Truck"),
                            _buildFilterChip("Micro"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Vehicle cards built dynamically
                      ...vehicles.map((vehicle) => _buildVehicleCard(vehicle)),
                    ],
                  ),
                );
              } else if (state is VehicleError) {
                return Center(child: Text(state.message));
              } else {
                // Initial or unknown state
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }

  static Widget _buildFilterChip(String label, {bool selected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: selected ? Colors.blueAccent : Colors.grey.shade200,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildVehicleCard(VehicleEntity vehicle) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isTablet = screenWidth > 600;

        return Container(
          padding: const EdgeInsets.all(11),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(19),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.08 * 255).round()),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Title and Favorite icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle.vehicleName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        vehicle.vehicleType,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.favorite_border, size: 18),
                ],
              ),
              const SizedBox(height: 8),

              // Image
              Center(
                child: Image.network(
                  'http://192.168.157.46:5000/uploads/${vehicle.filepath}',
                  height: isTablet ? 160 : 120,
                  width: isTablet ? 260 : null,
                  fit: BoxFit.contain,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          const Icon(Icons.broken_image),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(
                      height: 100,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),

              // Specs row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: IconText(
                      icon: FontAwesomeIcons.gasPump,
                      text: "${vehicle.fuelCapacityLitres} litres",
                    ),
                  ),
                  Expanded(
                    child: IconText(
                      icon: FontAwesomeIcons.weightHanging,
                      text: "${vehicle.loadCapacityKg} kg",
                    ),
                  ),
                  Expanded(
                    child: IconText(
                      icon: FontAwesomeIcons.userGroup,
                      text: vehicle.passengerCapacity,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Price and Rent button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              "Npr ${vehicle.pricePerTrip.toStringAsFixed(0)} /- ",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(
                          text: "Per trip",
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => BlocProvider(
                                create:
                                    (context) => BookingBloc(
                                      createBookingUsecase:
                                          context.read<CreateBookingUsecase>(),
                                    ),
                                child: BookingScreen(
                                  vehicle:
                                      vehicle, // ✅ required parameter being passed
                                ),
                              ),
                        ),
                      );
                    },
                    child: const Text("Rent Now"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class IconText extends StatelessWidget {
  final IconData icon;
  final String text;

  const IconText({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 11.5, color: Colors.grey)),
      ],
    );
  }
}
