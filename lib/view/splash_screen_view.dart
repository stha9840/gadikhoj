import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:finalyearproject/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 160,
            width: 160,
            child: Lottie.asset("assets/lottie/Animation - 1747329645355.json"),
          ),
          const SizedBox(height: 16),
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 44, color: Colors.black),
              children: [
                TextSpan(
                  text: 'Gadi ',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue ),
                ),
                TextSpan(
                  text: 'khoj',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ),
      nextScreen: const LoginView(),
      splashIconSize: 250,
      backgroundColor: Colors.white,
    );
  }
}
