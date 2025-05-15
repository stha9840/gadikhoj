import 'package:finalyearproject/view/login_view.dart';
import 'package:finalyearproject/view/signup_view.dart';
import 'package:flutter/material.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auth App',
      theme: ThemeData(fontFamily: 'Arial'),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginView(),
        '/signup': (context) => const SignUpView(),
      },
    );
  }
}
