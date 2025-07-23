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
import 'package:finalyearproject/features/booking/get_booking/data/data_source/get_booking_datasource.dart';
import 'package:finalyearproject/features/booking/get_booking/data/data_source/remote_data_source/get_booking_remote_datasource.dart';
import 'package:finalyearproject/features/booking/get_booking/data/repository/booking_remote_repository.dart';
import 'package:finalyearproject/features/booking/get_booking/domain/repository/get_booking_repository.dart';
import 'package:finalyearproject/features/booking/get_booking/domain/use_case/cancel_user_booking_use_case.dart';
import 'package:finalyearproject/features/booking/get_booking/domain/use_case/delete_user_booking_use_case.dart';
import 'package:finalyearproject/features/booking/get_booking/domain/use_case/get_user_booking_use_case.dart';
import 'package:finalyearproject/features/booking/get_booking/domain/use_case/update_user_booking_use_case.dart';
import 'package:finalyearproject/features/booking/get_booking/presentation/view_model/get_booking_event.dart';
import 'package:finalyearproject/features/booking/get_booking/presentation/view_model/get_booking_view_model.dart';
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
  await serviceLocator
      .reset(); // ✅ Clears previous registrations (safe during dev)

  await _initHiveService();
  await _initSharedPrefs();
  await _initAuthModule();
  await _initSplashModule();
  await _initVehicleModule(); // ✅ Registers VehicleRemoteDatasource only here
  await _initBookingModule(); // ✅ No duplicate registration
}

Future<void> _initHiveService() async {
  if (!serviceLocator.isRegistered<HiveService>()) {
    serviceLocator.registerLazySingleton<HiveService>(() => HiveService());
  }
}

Future<void> _initSharedPrefs() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  if (!serviceLocator.isRegistered<SharedPreferences>()) {
    serviceLocator.registerLazySingleton(() => sharedPrefs);
  }

  if (!serviceLocator.isRegistered<TokenSharedPrefs>()) {
    serviceLocator.registerLazySingleton(
      () => TokenSharedPrefs(
        sharedPreferences: serviceLocator<SharedPreferences>(),
      ),
    );
  }
}

Future<void> _initAuthModule() async {
  if (!serviceLocator.isRegistered<ApiService>()) {
    serviceLocator.registerLazySingleton<ApiService>(() => ApiService(Dio()));
  }

  serviceLocator.registerFactory(
    () => UserLocalDatasource(hiveservice: serviceLocator<HiveService>()),
  );

  serviceLocator.registerFactory(
    () => UserRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );

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

  serviceLocator.registerFactory(
    () => LoginViewModel(userLoginUsecase: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => RegisterViewModel(
      registerUsecase: serviceLocator<RegisterUserUseCase>(),
    ),
  );
}

Future<void> _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashViewModel());
}

Future<void> _initVehicleModule() async {
  if (!serviceLocator.isRegistered<VehicleRemoteDatasource>()) {
    serviceLocator.registerLazySingleton<VehicleRemoteDatasource>(
      () => VehicleRemoteDatasource(apiService: serviceLocator<ApiService>()),
    );
  }

  if (!serviceLocator.isRegistered<IVehicleRepository>()) {
    serviceLocator.registerLazySingleton<IVehicleRepository>(
      () => VehicleRemoteRepository(
        remoteDatasource: serviceLocator<VehicleRemoteDatasource>(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<GetAllVehiclesUsecase>()) {
    serviceLocator.registerLazySingleton<GetAllVehiclesUsecase>(
      () => GetAllVehiclesUsecase(
        vehicleRepository: serviceLocator<IVehicleRepository>(),
        tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
      ),
    );
  }

  serviceLocator.registerFactory<VehicleBloc>(
    () => VehicleBloc(
      getAllVehiclesUsecase: serviceLocator<GetAllVehiclesUsecase>(),
    ),
  );
}

// Future<void> _initBookingModule() async {

//   if (!serviceLocator.isRegistered<CreateBookingUsecase>()) {
//     serviceLocator.registerLazySingleton<CreateBookingUsecase>(
//       () => CreateBookingUsecase(
//         repository: serviceLocator<IVehicleRepository>(),
//         tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
//       ),
//     );
//   }

//   serviceLocator.registerFactory(
//     () => GetUserBookingsUsecase(
//       bookingRepository: serviceLocator<IBookingRepository>(),
//       tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
//     ),
//   );

//   serviceLocator.registerFactory<BookingBloc>(
//     () => BookingBloc(
//       createBookingUsecase: serviceLocator<CreateBookingUsecase>(),
//     ),
//   );

//   serviceLocator.registerLazySingleton(
//     () => GetBookingBloc(
//       getUserBookingsUsecase: serviceLocator<GetUserBookingsUsecase>(),
//     ),
//   );
// }

// Future<void> _initBookingModule() async {
//   // Register the remote datasource if not registered
//   if (!serviceLocator.isRegistered<GetBookingRemoteDatasource>()) {
//     serviceLocator.registerLazySingleton<GetBookingRemoteDatasource>(
//       () =>
//           GetBookingRemoteDatasource(apiService: serviceLocator<ApiService>()),
//     );
//   }

//   // if (!serviceLocator.isRegistered<IBookingRepository>()) {
//   //   serviceLocator.registerLazySingleton<IBookingRepository>(
//   //     () => ( remoteDatasource: serviceLocator<GetBookingRemoteDatasource>(),
//   //     ),
//   //   );
//   // }

//   serviceLocator.registerFactory<GetBookingRemoteRepository>(
//     () => GetBookingRemoteRepository(remoteDatasource: serviceLocator<GetBookingRemoteDatasource>()
//     ),
//   );


//   if (!serviceLocator.isRegistered<CreateBookingUsecase>()) {
//     serviceLocator.registerLazySingleton<CreateBookingUsecase>(
//       () => CreateBookingUsecase(
//         repository: serviceLocator<IVehicleRepository>(),
//         tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
//       ),
//     );
//   }

//   serviceLocator.registerFactory(
//     () => GetUserBookingsUsecase(
//       bookingRepository: serviceLocator<IBookingRepository>(),
//       tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
//     ),
//   );

//   serviceLocator.registerFactory<BookingBloc>(
//     () => BookingBloc(
//       createBookingUsecase: serviceLocator<CreateBookingUsecase>(),
//     ),
//   );

//   serviceLocator.registerLazySingleton(
//     () => GetBookingBloc(
//       getUserBookingsUsecase: serviceLocator<GetUserBookingsUsecase>(),
//     ),
//   );
// }

Future<void> _initBookingModule() async {
  // Register the remote datasource if not registered
  if (!serviceLocator.isRegistered<GetBookingRemoteDatasource>()) {
    serviceLocator.registerLazySingleton<GetBookingRemoteDatasource>(
      () => GetBookingRemoteDatasource(apiService: serviceLocator<ApiService>()),
    );
  }

  // Register the repository as the interface type
  if (!serviceLocator.isRegistered<IBookingRepository>()) {
    serviceLocator.registerLazySingleton<IBookingRepository>(
      () => GetBookingRemoteRepository(
        remoteDatasource: serviceLocator<GetBookingRemoteDatasource>(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<CreateBookingUsecase>()) {
    serviceLocator.registerLazySingleton<CreateBookingUsecase>(
      () => CreateBookingUsecase(
        repository: serviceLocator<IVehicleRepository>(),
        tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
      ),
    );
  }

  serviceLocator.registerFactory(
    () => GetUserBookingsUsecase(
      bookingRepository: serviceLocator<IBookingRepository>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );

    serviceLocator.registerFactory(
    () => UpdateUserBookingUsecase(
      bookingRepository: serviceLocator<IBookingRepository>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );

    serviceLocator.registerFactory(
    () => DeleteUserBookingUsecase(
      bookingRepository: serviceLocator<IBookingRepository>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );

    serviceLocator.registerFactory(
    () => CancelUserBookingUsecase(
      bookingRepository: serviceLocator<IBookingRepository>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );



  serviceLocator.registerFactory<BookingBloc>(
    () => BookingBloc(
      createBookingUsecase: serviceLocator<CreateBookingUsecase>(),
    ),
  );

  serviceLocator.registerFactory<BookingViewModel>(
  () => BookingViewModel(
    getUserBookingsUsecase: serviceLocator<GetUserBookingsUsecase>(),
    cancelUserBookingUsecase: serviceLocator<CancelUserBookingUsecase>(),
    deleteUserBookingUsecase: serviceLocator<DeleteUserBookingUsecase>(),
    updateUserBookingUsecase: serviceLocator<UpdateUserBookingUsecase>(),
  ),
);

}
