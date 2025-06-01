import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row
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
                      child: Icon(Icons.person, size: 24, color: Colors.black),
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
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

                // Filter Chips
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

                // Vehicle Cards
                _buildVehicleCard(
                  title: "Tata Intra V30",
                  subtitle: "Mini Truck",
                  image: "assets/images/tata.png",
                  price: "3000",
                ),
                _buildVehicleCard(
                  title: "Hyundai Eon",
                  subtitle: "Compact Car",
                  image: "assets/images/eon.png",
                  price: "2500",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildFilterChip(String label, {bool selected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Text(label, style: TextStyle(fontSize: 12)),
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: selected ? Colors.blueAccent : Colors.grey.shade200,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildVehicleCard({
    required String title,
    required String subtitle,
    required String image,
    required String price,
  }) {
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
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Title and Favorite
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        subtitle,
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

              // Responsive Image
              Center(
                child: Image.asset(
                  image,
                  height: isTablet ? 160 : 120,
                  width: isTablet ? 260 : null,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 10),

              // Specs Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Expanded(
                    child: IconText(
                      icon: FontAwesomeIcons.gasPump,
                      text: "35 litres",
                    ),
                  ),
                  Expanded(
                    child: IconText(
                      icon: FontAwesomeIcons.weightHanging,
                      text: "1300 kg",
                    ),
                  ),
                  Expanded(
                    child: IconText(
                      icon: FontAwesomeIcons.userGroup,
                      text: "2–3 people",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Price and Rent Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Npr $price /- ",
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
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Rent Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
