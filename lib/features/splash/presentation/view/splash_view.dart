  import 'package:finalyearproject/app/service_locator/service_locator.dart';
  import 'package:finalyearproject/app/shared_pref/token_shared_prefs.dart';
  import 'package:finalyearproject/features/auth/presentation/view/login_view.dart';
  import 'package:finalyearproject/features/navigation/presentation/view/dashboard_view.dart'; // Make sure this import is correct
  import 'package:flutter/material.dart';
  import 'package:lottie/lottie.dart';

  // 1. Convert to a StatefulWidget
  class SplashView extends StatefulWidget {
    const SplashView({super.key});

    @override
    State<SplashView> createState() => _SplashViewState();
  }

  class _SplashViewState extends State<SplashView> {
    @override
    void initState() {
      super.initState();
      // 2. Call the navigation logic from initState
      _checkTokenAndNavigate();
    }

    void _checkTokenAndNavigate() async {
      // Optional: A small delay to ensure the splash screen is visible
      await Future.delayed(const Duration(seconds: 3));

      // 3. Get AuthPrefs instance from your service locator
      final tokenSharedPrefs = serviceLocator<TokenSharedPrefs>();
      final tokenResult = await tokenSharedPrefs.getToken();

      // 4. Check if the widget is still in the tree before navigating
      if (!mounted) return;

      tokenResult.fold(
        (failure) {
          // 5. On failure (or no token), navigate to LoginView
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginView()),
          );
        },
        (token) {
          if (token != null && token.isNotEmpty) {
            // 6. If token exists, navigate to DashboardView
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardView()),
            );
          } else {
            // 7. If token is null or empty, navigate to LoginView
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginView()),
            );
          }
        },
      );
    }

    @override
    Widget build(BuildContext context) {
      // The UI remains the same. No changes needed here.
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