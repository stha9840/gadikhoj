import 'package:finalyearproject/bottom_screen/booking.dart';
import 'package:finalyearproject/bottom_screen/home.dart';
import 'package:finalyearproject/bottom_screen/notifications.dart';
import 'package:finalyearproject/bottom_screen/profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedIndex = 0;

  List<Widget> lstBottomScreen = [
    const Home(),
    const Booking(),
    const Notifications(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.only(
          top: 20,
        ), 
        child: lstBottomScreen[_selectedIndex],
      ), 
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          // showSelectedLabels: false,
          showUnselectedLabels: false,

          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 0
                    ? FontAwesomeIcons
                        .house //// Filled version
                    : FontAwesomeIcons.house, // Outline version
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 1
                    ? FontAwesomeIcons.solidCalendar
                    : FontAwesomeIcons.calendar,
              ),
              label: 'Booking',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 2
                    ? FontAwesomeIcons.solidBell
                    : FontAwesomeIcons.bell,
              ),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 3
                    ? FontAwesomeIcons.solidUser
                    : FontAwesomeIcons.user,
              ),
              label: 'Profile',
            ),
          ],
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
