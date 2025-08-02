// lib/features/home/presentation/pages/home_view.dart
import 'package:finalyearproject/features/home/domain/entity/vehicle.dart';
import 'package:finalyearproject/features/home/presentation/widgets/vehicle_cart.dart';
import 'package:flutter/material.dart';
import '../widgets/filter_chip_list.dart';
import '../widgets/search_bar.dart';
import '../widgets/location_tile.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Vehicle> vehicles = [
      Vehicle(
        title: "Tata Intra V30",
        subtitle: "Mini Truck",
        image: "assets/images/tata.png",
        price: "3000",
        fuelCapacity: "35 litres",
        weight: "1300 kg",
        seats: "2–3 people",
      ),
      Vehicle(
        title: "Hyundai Eon",
        subtitle: "Compact Car",
        image: "assets/images/eon.png",
        price: "2500",
        fuelCapacity: "30 litres",
        weight: "900 kg",
        seats: "4–5 people",
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LocationTile(),
                const SizedBox(height: 16),
                const HomeSearchBar(),
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
                const FilterChipList(),
                const SizedBox(height: 14),
                ...vehicles.map((v) => VehicleCard(vehicle: v)).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
