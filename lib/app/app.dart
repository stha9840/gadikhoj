import 'package:finalyearproject/app/theme/app_theme.dart';
import 'package:finalyearproject/features/splash/presentation/view/splash_view.dart';
import 'package:finalyearproject/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:finalyearproject/view/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:finalyearproject/view/login_view.dart';
import 'package:finalyearproject/view/signup_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      home: BlocProvider.value(
        value: GetIt.instance<SplashViewModel>(),
        child: const SplashView(),
      ),
      routes: {
        '/login': (context) => const LoginView(),
        '/signup': (context) => const SignUpView(),
        '/dashboard': (context) => const DashboardView(),
      },
    );
  }
}