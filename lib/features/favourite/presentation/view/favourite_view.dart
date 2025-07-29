import 'package:finalyearproject/features/home/presentation/view/booking_view.dart';
import 'package:finalyearproject/features/saved_vechile/domain/entity/saved_vechile_entity.dart';
import 'package:finalyearproject/features/saved_vechile/presentation/view_model/saved_vechile_event.dart';
import 'package:finalyearproject/features/saved_vechile/presentation/view_model/saved_vechile_state.dart';
import 'package:finalyearproject/features/saved_vechile/presentation/view_model/saved_vechile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FavouriteView extends StatefulWidget {
  const FavouriteView({super.key});

  @override
  State<FavouriteView> createState() => _FavouriteViewState();
}

class _FavouriteViewState extends State<FavouriteView> {
  @override
  void initState() {
    super.initState();
    context.read<SavedVehicleBloc>().add(GetSavedVehicles());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Saved Vehicles",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFFF9F9F9),
      body: BlocConsumer<SavedVehicleBloc, SavedVehicleState>(
        listener: (context, state) {
          if (state is SavedVehicleActionSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is SavedVehicleError &&
              !state.message.contains('Failed to fetch')) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is SavedVehicleLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SavedVehicleError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed:
                        () => context.read<SavedVehicleBloc>().add(
                          GetSavedVehicles(),
                        ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is SavedVehicleSuccess) {
            if (state.savedVehicles.isEmpty) {
              return const Center(
                child: Text(
                  'No saved vehicles yet.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              itemCount: state.savedVehicles.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final savedVehicle = state.savedVehicles[index];
                return _buildSavedVehicleCard(context, savedVehicle);
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildSavedVehicleCard(
    BuildContext context,
    SavedVehicleEntity savedVehicle,
  ) {
    final vehicle = savedVehicle.vehicle;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 4,
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {},
        splashColor: Colors.grey.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicle.vehicleName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          vehicle.vehicleType,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'http://192.168.101.4:5000/uploads/${vehicle.filepath}',
                  height: 150,
                  fit: BoxFit.contain,
                  errorBuilder:
                      (_, __, ___) => const Icon(
                        Icons.broken_image,
                        size: 100,
                        color: Colors.grey,
                      ),
                  loadingBuilder:
                      (context, child, loadingProgress) =>
                          loadingProgress == null
                              ? child
                              : const Center(
                                child: CircularProgressIndicator(),
                              ),
                ),
              ),
              const SizedBox(height: 14),

              // Specs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _specItem(
                    FontAwesomeIcons.gasPump,
                    "${vehicle.fuelCapacityLitres}L",
                  ),
                  _specItem(
                    FontAwesomeIcons.weightHanging,
                    "${vehicle.loadCapacityKg}kg",
                  ),
                  _specItem(
                    FontAwesomeIcons.userGroup,
                    vehicle.passengerCapacity,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Price and Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Price
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              "Npr ${vehicle.pricePerTrip.toStringAsFixed(0)} ",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const TextSpan(
                          text: "/ trip",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  // Buttons: Remove & Book Now
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          context.read<SavedVehicleBloc>().add(
                            RemoveVehicleFromSaved(vehicleId: vehicle.id!),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                        ),
                        child: const Text("Remove"),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (_) => BookingScreen(vehicle: vehicle),
                          //   ),
                          // );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Book Now"),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _specItem(IconData icon, String value) {
    return Column(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 12.5, color: Colors.black87),
        ),
      ],
    );
  }
}
