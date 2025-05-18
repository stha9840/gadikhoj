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
      splash: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
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
                  height: constraints.maxHeight * 0.22,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          );
        },
      ),
      nextScreen: const LoginView(),
      splashIconSize: double.infinity,
      backgroundColor: Colors.white,
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
