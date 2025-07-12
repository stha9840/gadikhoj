// lib/app/service_locator/service_locator.dart

import 'package:dio/dio.dart';
import 'package:finalyearproject/app/shared_pref/token_shared_prefs.dart';
import 'package:finalyearproject/core/network/api_service.dart';
import 'package:finalyearproject/core/network/hive_service.dart';
import 'package:finalyearproject/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:finalyearproject/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:finalyearproject/features/auth/data/repository/remote_repository/user_remote_repository.dart';
import 'package:finalyearproject/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:finalyearproject/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:finalyearproject/features/home/data/data_source/remote_data_source/vehicle_remote_data_source.dart';
import 'package:finalyearproject/features/home/data/repository/remote_repository/remote_repository.dart';
import 'package:finalyearproject/features/home/domain/repository/vehicle_repository.dart';
import 'package:finalyearproject/features/home/domain/use_case/create_booking_usecase.dart';
import 'package:finalyearproject/features/home/domain/use_case/get_all_vehicles_usecase.dart';
import 'package:finalyearproject/features/home/presentation/view_model/Booking/booking_view_model.dart';
import 'package:finalyearproject/features/home/presentation/view_model/vehicle_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:finalyearproject/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:finalyearproject/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> setupLocator() async {
  await _initHiveService();
  await _initAuthModule();
  await _initSharedPrefs();
  await _initSplashModule();
  await _initVehicleModule();
  await _initBookingModule();
  
  
}

Future<void> _initHiveService() async {
  serviceLocator.registerLazySingleton<HiveService>(() => HiveService());
}
Future<void> _initBookingModule() async {
  // Don't re-register VehicleRemoteDatasource or IVehicleRepository here!

  // Only register CreateBookingUsecase and BookingBloc

  serviceLocator.registerLazySingleton<CreateBookingUsecase>(
    () => CreateBookingUsecase(
      repository: serviceLocator<IVehicleRepository>(),  // reuse existing repo
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );

  serviceLocator.registerFactory<BookingBloc>(
    () => BookingBloc(createBookingUsecase: serviceLocator<CreateBookingUsecase>()),
  );
}

Future<void> _initVehicleModule() async {
  // Data source
  serviceLocator.registerLazySingleton<VehicleRemoteDatasource>(
    () => VehicleRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );

  // Repository - note: you use IVehicleRepository as abstract class with concrete implementation RemoteRepository
  serviceLocator.registerLazySingleton<IVehicleRepository>(
    () => VehicleRemoteRepository(
      remoteDatasource: serviceLocator<VehicleRemoteDatasource>(),
    ),
  );

  // Use case - needs both repository and TokenSharedPrefs
  serviceLocator.registerLazySingleton<GetAllVehiclesUsecase>(
    () => GetAllVehiclesUsecase(
      vehicleRepository: serviceLocator<IVehicleRepository>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );

  // Bloc or ViewModel
  serviceLocator.registerFactory<VehicleBloc>(
    () => VehicleBloc(getAllVehiclesUsecase: serviceLocator<GetAllVehiclesUsecase>()),
  );
}



Future<void> _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashViewModel());
}
Future<void> _initSharedPrefs() async {
  // Initialize Shared Preferences if needed
  final sharedPrefs = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPrefs);
  serviceLocator.registerLazySingleton(
    () => TokenSharedPrefs(
      sharedPreferences: serviceLocator<SharedPreferences>(),
    ),
  );
}

Future _initAuthModule() async {
  // Register ApiService
  serviceLocator.registerLazySingleton<ApiService>(() => ApiService(Dio()));

  // Data Source
  serviceLocator.registerFactory(
    () => UserLocalDatasource(hiveservice: serviceLocator<HiveService>()),
  );

  serviceLocator.registerFactory(
    () => UserRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );

  // Repository
  serviceLocator.registerFactory(
    () => UserLocalRepository(
      userLocalDatasource: serviceLocator<UserLocalDatasource>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserRemoteRepository(
      userremoteDatasoource: serviceLocator<UserRemoteDatasource>(),
    ),
  );

  // Use Cases
  serviceLocator.registerFactory(
    () => RegisterUserUseCase(
      userRepository: serviceLocator<UserRemoteRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserLoginUsecase(
      userRepository: serviceLocator<UserRemoteRepository>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );

  // ViewModels
  serviceLocator.registerFactory(
    () => LoginViewModel(userLoginUsecase: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => RegisterViewModel(
      registerUsecase: serviceLocator<RegisterUserUseCase>(),
    ),
  );
}

