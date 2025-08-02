import 'package:finalyearproject/features/auth/presentation/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 // Import LoginView
import '../view_model/splash_view_model.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Trigger the SplashViewModel logic if needed
      // context.read<SplashViewModel>().init(context);

      // Navigate to LoginView after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
        );
      });
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 36, color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Gadi ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  TextSpan(
                    text: 'khoj',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              'Find your perfect ride',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            Lottie.asset(
              "assets/lottie/Animation - 1747329645355.json",
              height: 150,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
