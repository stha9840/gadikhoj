
    import 'package:finalyearproject/app/app.dart';
    import 'package:finalyearproject/app/service_locator/service_locator.dart';
    import 'package:finalyearproject/core/network/hive_service.dart';
  import 'package:finalyearproject/features/auth/domain/use_case/user_login_usecase.dart';
  import 'package:finalyearproject/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
    import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';

    // void main() async {
    //   WidgetsFlutterBinding.ensureInitialized();
    //   await setupLocator();
    //   await HiveService().init(); // handles registration
    //   runApp(const MyApp());
    // }


  //   void main() {
  //   runApp(
  //     MultiBlocProvider(
  //       providers: [
  //         BlocProvider<LoginViewModel>(
  //           create: (_) => serviceLocator<LoginViewModel>(),
  //         ),
  //         // other providers...
  //       ],
  //       child: MyApp(),
  //     ),
  //   );
  // }


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();
  await HiveService().init();


  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LoginViewModel>(
          create: (_) => serviceLocator<LoginViewModel>(),
        ),
        // Add other BLoCs here
      ],
      child: const MyApp(),
    
    ),
    
  );
}
