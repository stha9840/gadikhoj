import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.location_on, color: Colors.grey),
                      SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Your location",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            "Gangabu, Kathmandu",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.orangeAccent.withOpacity(0.3),
                    child: Icon(Icons.person, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              //Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: "Search Vehicle",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: const Icon(Icons.tune),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(19),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              //vehicle Type FIlter Chips
              Row(
                children: [
                  _buildFilterChip("All", selected: true),
                  _buildFilterChip("Car"),
                  _buildFilterChip("Truck"),
                  _buildFilterChip("Micro"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool selected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Text(label),
        labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
        backgroundColor: selected ? Colors.blue : Colors.grey.shade200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
      ),
    );
  }
}
