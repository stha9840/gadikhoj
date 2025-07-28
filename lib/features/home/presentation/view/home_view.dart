import 'package:finalyearproject/features/home/domain/entity/vehicle.dart';
import 'package:finalyearproject/features/home/domain/use_case/create_booking_usecase.dart';
import 'package:finalyearproject/features/home/presentation/view/booking_view.dart';
import 'package:finalyearproject/features/home/presentation/view/vehicle_details_page.dart';
import 'package:finalyearproject/features/home/presentation/view_model/Booking/booking_view_model.dart';
import 'package:finalyearproject/features/home/presentation/view_model/vehicle_event.dart';
import 'package:finalyearproject/features/home/presentation/view_model/vehicle_state.dart';
import 'package:finalyearproject/features/home/presentation/view_model/vehicle_view_model.dart';
import 'package:finalyearproject/features/saved_vechile/presentation/view_model/saved_vechile_event.dart';
import 'package:finalyearproject/features/saved_vechile/presentation/view_model/saved_vechile_state.dart';
import 'package:finalyearproject/features/saved_vechile/presentation/view_model/saved_vechile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<SavedVehicleBloc, SavedVehicleState>(
        listener: (context, state) {
          if (state is SavedVehicleActionSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.message), duration: const Duration(seconds: 2)));
          } else if (state is SavedVehicleError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(backgroundColor: Colors.black, content: Text(state.message), duration: const Duration(seconds: 2)));
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: BlocBuilder<VehicleBloc, VehicleState>(
              builder: (context, state) {
                if (state is VehicleLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is VehicleLoaded) {
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
                                Icon(Icons.location_on, color: Colors.grey, size: 26),
                                SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Your location", style: TextStyle(fontSize: 14, color: Colors.grey)),
                                    Text("Gangabu, Kathmandu", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                  ],
                                ),
                              ],
                            ),
                            const CircleAvatar(
                              radius: 21,
                              backgroundColor: Colors.orangeAccent,
                              child: Icon(Icons.person, size: 24, color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Search Bar
                        TextField(
                          controller: _searchController,
                          onChanged: (query) {
                            context.read<VehicleBloc>().add(SearchVehiclesEvent(query));
                          },
                          decoration: InputDecoration(
                            hintText: "Search Vehicle",
                            prefixIcon: const Icon(Icons.search, size: 20),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 20),
                                    onPressed: () {
                                      _searchController.clear();
                                      context.read<VehicleBloc>().add(const SearchVehiclesEvent(''));
                                    },
                                  )
                                : const Icon(Icons.tune, size: 20),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            contentPadding: const EdgeInsets.symmetric(vertical: 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        const Text("Vehicle Type", style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 6),

                        // Filter chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: state.vehicleTypes.map((type) {
                              return _buildFilterChip(
                                context,
                                type,
                                selected: type == state.selectedType,
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Conditionally show message or vehicle list
                        if (state.filteredVehicles.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Text(
                                "No vehicles found.",
                                style: TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            ),
                          )
                        else
                          ...state.filteredVehicles.map((vehicle) => _buildVehicleCard(context, vehicle)),
                      ],
                    ),
                  );
                } else if (state is VehicleError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text("Please wait..."));
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, {bool selected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (isSelected) {
          if (isSelected) {
            context.read<VehicleBloc>().add(FilterVehiclesEvent(label));
          }
        },
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: Colors.grey.shade200,
        selectedColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        showCheckmark: false,
      ),
    );
  }

  // ========== THE CHANGES ARE IN THIS WIDGET ==========
  Widget _buildVehicleCard(BuildContext context, VehicleEntity vehicle) {
    // 1. WRAP THE CARD IN INKWELL TO MAKE IT TAPPABLE
    return InkWell(
      onTap: () {
        // 2. NAVIGATE TO THE VehicleDetailsView, PASSING THE TAPPED VEHICLE
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VehicleDetailsView(vehicle: vehicle),
          ),
        );
      },
      borderRadius: BorderRadius.circular(19), // Match the card's border for a nice ripple effect
      child: Container(
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
            // Title and Favorite icon (no changes here)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(vehicle.vehicleName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    Text(vehicle.vehicleType, style: const TextStyle(color: Colors.grey, fontSize: 11.5)),
                  ],
                ),
                BlocBuilder<SavedVehicleBloc, SavedVehicleState>(
                  builder: (context, savedState) {
                    bool isSaved = false;
                    if (savedState is SavedVehicleSuccess) {
                      isSaved = savedState.savedVehicles.any((saved) => saved.vehicle.id == vehicle.id);
                    }
                    return IconButton(
                      icon: Icon(
                        isSaved ? Icons.favorite : Icons.favorite_border,
                        color: isSaved ? Colors.black : Colors.grey,
                        size: 24,
                      ),
                      onPressed: () {
                        if (vehicle.id == null) return;
                        if (isSaved) {
                          context.read<SavedVehicleBloc>().add(RemoveVehicleFromSaved(vehicleId: vehicle.id!));
                        } else {
                          context.read<SavedVehicleBloc>().add(AddVehicleToSaved(vehicleId: vehicle.id!));
                        }
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 3. WRAP THE IMAGE WITH A HERO WIDGET FOR ANIMATION
            Hero(
              // The tag must be unique for each vehicle but consistent across both screens
              tag: 'vehicle_image_${vehicle.id}',
              child: Center(
                child: Image.network(
                  'http://192.168.101.3:5000/uploads/${vehicle.filepath}',
                  height: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(
                      height: 100,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Specs row (no changes here)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: IconText(icon: FontAwesomeIcons.gasPump, text: "${vehicle.fuelCapacityLitres} litres")),
                Expanded(child: IconText(icon: FontAwesomeIcons.weightHanging, text: "${vehicle.loadCapacityKg} kg")),
                Expanded(child: IconText(icon: FontAwesomeIcons.userGroup, text: vehicle.passengerCapacity)),
              ],
            ),
            const SizedBox(height: 10),

            // Price and Rent button (no changes here)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Npr ${vehicle.pricePerTrip.toStringAsFixed(0)} /- ",
                        style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      const TextSpan(text: "Per trip", style: TextStyle(color: Colors.grey, fontSize: 15)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (context) => BookingBloc(
                            createBookingUsecase: context.read<CreateBookingUsecase>(),
                          ),
                          child: BookingScreen(vehicle: vehicle),
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
      ),
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