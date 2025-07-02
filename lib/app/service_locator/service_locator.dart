// lib/app/service_locator/service_locator.dart

import 'package:dio/dio.dart';
import 'package:finalyearproject/core/network/api_service.dart';
import 'package:finalyearproject/core/network/hive_service.dart';
import 'package:finalyearproject/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:finalyearproject/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:finalyearproject/features/auth/data/repository/remote_repository/user_remote_repository.dart';
import 'package:finalyearproject/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:finalyearproject/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:finalyearproject/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:finalyearproject/features/auth/data/data_source/local_datasource/user_local_datasource.dart';

final serviceLocator = GetIt.instance;

Future<void> setupLocator() async {
  await _initHiveService();
  await _initAuthModule();
  await _initSplashModule();
}

Future<void> _initHiveService() async {
  serviceLocator.registerLazySingleton<HiveService>(() => HiveService());
}

Future<void> _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashViewModel());
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

