import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';  
import 'package:finalyearproject/app/app.dart';
import 'package:finalyearproject/app/service_locator/service_locator.dart';
import 'package:finalyearproject/core/network/hive_service.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:finalyearproject/features/home/domain/use_case/create_booking_usecase.dart';
import 'package:finalyearproject/features/home/presentation/view_model/vehicle_event.dart';
import 'package:finalyearproject/features/home/presentation/view_model/vehicle_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();
  await HiveService().init();

  runApp(
    MultiProvider(
      providers: [
        Provider<CreateBookingUsecase>(
          create: (_) => serviceLocator<CreateBookingUsecase>(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LoginViewModel>(
            create: (_) => serviceLocator<LoginViewModel>(),
          ),
          BlocProvider<VehicleBloc>(
            create: (_) => serviceLocator<VehicleBloc>()..add(FetchVehiclesEvent()),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}
