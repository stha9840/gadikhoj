// In: app/service_locator/service_locator.dart

import 'package:dio/dio.dart';
import 'package:finalyearproject/app/shared_pref/token_shared_prefs.dart';
import 'package:finalyearproject/core/network/api_service.dart';
import 'package:finalyearproject/core/network/hive_service.dart';
import 'package:finalyearproject/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:finalyearproject/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:finalyearproject/features/auth/data/repository/remote_repository/user_remote_repository.dart';
// IMPORTANT: Import the INTERFACE file
import 'package:finalyearproject/features/auth/domain/repository/user_repository.dart';
import 'package:finalyearproject/features/auth/domain/use_case/user_delete_usecase.dart';
import 'package:finalyearproject/features/auth/domain/use_case/user_get_usecase.dart';
import 'package:finalyearproject/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:finalyearproject/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:finalyearproject/features/auth/domain/use_case/user_update_usecase.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/profile_view_model/view_model/profile_view_model.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:finalyearproject/features/booking/get_booking/data/data_source/remote_data_source/get_booking_remote_datasource.dart';
import 'package:finalyearproject/features/booking/get_booking/data/repository/booking_remote_repository.dart';
import 'package:finalyearproject/features/booking/get_booking/domain/repository/get_booking_repository.dart';
import 'package:finalyearproject/features/booking/get_booking/domain/use_case/cancel_user_booking_use_case.dart';
import 'package:finalyearproject/features/booking/get_booking/domain/use_case/delete_user_booking_use_case.dart';
import 'package:finalyearproject/features/booking/get_booking/domain/use_case/get_user_booking_use_case.dart';
import 'package:finalyearproject/features/booking/get_booking/domain/use_case/update_user_booking_use_case.dart';
import 'package:finalyearproject/features/booking/get_booking/presentation/view_model/get_booking_view_model.dart';
import 'package:finalyearproject/features/home/data/data_source/remote_data_source/vehicle_remote_data_source.dart';
import 'package:finalyearproject/features/home/data/repository/remote_repository/remote_repository.dart';
import 'package:finalyearproject/features/home/domain/repository/vehicle_repository.dart';
import 'package:finalyearproject/features/home/domain/use_case/create_booking_usecase.dart';
import 'package:finalyearproject/features/home/domain/use_case/get_all_vehicles_usecase.dart';
import 'package:finalyearproject/features/home/presentation/view_model/Booking/booking_view_model.dart';
import 'package:finalyearproject/features/home/presentation/view_model/vehicle_view_model.dart';
import 'package:finalyearproject/features/saved_vechile/data/data_source/saved_vechile_remote_data_source.dart';
import 'package:finalyearproject/features/saved_vechile/data/repository/saved_vechile_remote_repository.dart';
import 'package:finalyearproject/features/saved_vechile/domain/repository/saved_vechile_repository.dart';
import 'package:finalyearproject/features/saved_vechile/domain/usecase/add_saved_vechile_usecase.dart';
import 'package:finalyearproject/features/saved_vechile/domain/usecase/get_saved_vechile_usecase.dart';
import 'package:finalyearproject/features/saved_vechile/domain/usecase/remove_saved_vechile_usecase.dart';
import 'package:finalyearproject/features/saved_vechile/presentation/view_model/saved_vechile_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:finalyearproject/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:finalyearproject/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finalyearproject/features/auth/domain/use_case/request_password_reset_usecase.dart';
import 'package:finalyearproject/features/auth/domain/use_case/reset_password_usecase.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/forgot_password_view_model/forgot_password_view_model.dart';

final serviceLocator = GetIt.instance;

Future<void> setupLocator() async {
  await serviceLocator.reset();
  await _initHiveService();
  await _initSharedPrefs();
  await _initAuthModule();
  await _initSplashModule();
  await _initVehicleModule();
  await _initBookingModule();
  await _initSavedVehicleModule();
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

  // =========================================================================
  // 1. THE MAIN FIX: Register UserRemoteRepository AS its IUserRepository interface.
  // =========================================================================
  serviceLocator.registerFactory<IUserRepository>(
    () => UserRemoteRepository(
      userRemoteDatasource: serviceLocator<UserRemoteDatasource>(),
    ),
  );

  serviceLocator.registerFactory(
    () => RegisterUserUseCase(
      userRepository: serviceLocator<IUserRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserLoginUsecase(
      userRepository: serviceLocator<IUserRepository>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );

  serviceLocator.registerFactory(
    () => GetUserUseCase(
      iUserRepository: serviceLocator<IUserRepository>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UpdateUserUseCase(
      iUserRepository: serviceLocator<IUserRepository>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );

  serviceLocator.registerFactory(
    () => DeleteUserUseCase(
      iUserRepository: serviceLocator<IUserRepository>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );

  // =========================================================================
  // 2. THIS NOW WORKS: Registering the new dependencies by asking for the INTERFACE.
  // =========================================================================
  serviceLocator.registerFactory(
    () => RequestPasswordResetUsecase(
      repository: serviceLocator<IUserRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => ResetPasswordUsecase(
      repository: serviceLocator<IUserRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => ForgotPasswordViewModel(
      requestUsecase: serviceLocator<RequestPasswordResetUsecase>(),
      resetUsecase: serviceLocator<ResetPasswordUsecase>(),
    ),
  );
  // --- End of new/corrected registrations ---

  serviceLocator.registerFactory(
    () => LoginViewModel(userLoginUsecase: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => RegisterViewModel(
      registerUsecase: serviceLocator<RegisterUserUseCase>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserViewModel(
      getUserUseCase: serviceLocator<GetUserUseCase>(),
      updateUserUseCase: serviceLocator<UpdateUserUseCase>(),
      deleteUserUseCase: serviceLocator<DeleteUserUseCase>(),
    ),
  );
}

// ... [rest of the file remains the same] ...
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

Future<void> _initBookingModule() async {
  if (!serviceLocator.isRegistered<GetBookingRemoteDatasource>()) {
    serviceLocator.registerLazySingleton<GetBookingRemoteDatasource>(
      () =>
          GetBookingRemoteDatasource(apiService: serviceLocator<ApiService>()),
    );
  }
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

Future<void> _initSavedVehicleModule() async {
  serviceLocator.registerLazySingleton<SavedVehicleRemoteDataSource>(
    () => SavedVehicleRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );
  serviceLocator.registerLazySingleton<ISavedVehicleRepository>(
    () => SavedVehicleRepositoryImpl(
      dataSource: serviceLocator<SavedVehicleRemoteDataSource>(),
    ),
  );
  serviceLocator.registerFactory<GetSavedVehiclesUsecase>(
    () => GetSavedVehiclesUsecase(
        repository: serviceLocator<ISavedVehicleRepository>(),
        tokenSharedPrefs: serviceLocator<TokenSharedPrefs>()),
  );
  serviceLocator.registerFactory<AddSavedVehicleUsecase>(
    () => AddSavedVehicleUsecase(
        repository: serviceLocator<ISavedVehicleRepository>(),
        tokenSharedPrefs: serviceLocator<TokenSharedPrefs>()),
  );
  serviceLocator.registerFactory<RemoveSavedVehicleUsecase>(
    () => RemoveSavedVehicleUsecase(
        repository: serviceLocator<ISavedVehicleRepository>(),
        tokenSharedPrefs: serviceLocator<TokenSharedPrefs>()),
  );
  serviceLocator.registerFactory<SavedVehicleBloc>(
    () => SavedVehicleBloc(
      getSavedVehiclesUsecase: serviceLocator<GetSavedVehiclesUsecase>(),
      addSavedVehicleUsecase: serviceLocator<AddSavedVehicleUsecase>(),
      removeSavedVehicleUsecase: serviceLocator<RemoveSavedVehicleUsecase>(),
    ),
  );
}