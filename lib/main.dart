import 'package:finalyearproject/features/auth/presentation/view_model/profile_view_model/view_model/profile_event.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/profile_view_model/view_model/profile_view_model.dart';
import 'package:finalyearproject/features/home/data/data_source/remote_data_source/vehicle_remote_data_source.dart';
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
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService().init();

  // RESET GetIt to avoid duplicate registrations on hot reload or restart
  if (GetIt.I.isRegistered<VehicleRemoteDatasource>()) {
    await GetIt.I.reset();
  }

  await setupLocator();

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
         BlocProvider<UserViewModel>(
            create: (_) => serviceLocator<UserViewModel>()..add(GetUserEvent()),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}
