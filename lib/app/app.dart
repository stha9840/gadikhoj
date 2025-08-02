

import 'package:finalyearproject/features/splash/presentation/view/splash_view.dart';
import 'package:flutter/material.dart';

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<LoginViewModel>(
//           create: (_) => serviceLocator<LoginViewModel>(),
//         ),
//         // Add other providers here if needed
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: getApplicationTheme(),
//         home:  LoginView(),
//       ),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashView(), // This widget can now access LoginViewModel
    );
  }
}
