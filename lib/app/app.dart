import 'package:finalyearproject/app/service_locator/service_locator.dart';
import 'package:finalyearproject/app/theme/app_theme.dart';
import 'package:finalyearproject/features/auth/presentation/view/login_view.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      home: LoginView(), // This widget can now access LoginViewModel
    );
  }
}
