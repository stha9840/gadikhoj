import 'package:flutter/material.dart';
import 'package:finalyearproject/view/login_view.dart';
import 'package:finalyearproject/view/signup_view.dart';
import 'package:finalyearproject/view/splash_screen_view.dart';
import 'package:finalyearproject/view/dashboard_view.dart'; // 👈 Make sure this import exists

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auth App',
      theme: ThemeData(fontFamily: 'Arial'),
      home: const SplashScreenView(),
      routes: {
        '/login': (context) => const LoginView(),
        '/signup': (context) => const SignUpView(),
        '/dashboard': (context) => const DashboardView(), 
      },
    );
  }
}
