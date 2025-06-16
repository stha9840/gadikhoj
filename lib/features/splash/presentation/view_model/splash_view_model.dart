// lib/features/splash/presentation/view_model/splash_view_model.dart

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:finalyearproject/view/login_view.dart';

class SplashViewModel extends Cubit<void> {
  SplashViewModel() : super(null);

  Future<void> init(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginView()),
      );
    }
  }
}
