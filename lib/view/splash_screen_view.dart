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
      splash: SizedBox(
        height: 160,
        width: 160,
        child: Lottie.asset("assets/lottie/Animation - 1747329645355.json"),
      ),
      nextScreen: const LoginView(),
      splashIconSize: 150, // This can match the Lottie size
      backgroundColor: Colors.white,
    );
  }

}
