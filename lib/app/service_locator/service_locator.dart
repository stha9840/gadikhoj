// lib/app/service_locator/service_locator.dart

import 'package:finalyearproject/core/network/hive_service.dart';
import 'package:finalyearproject/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:finalyearproject/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:finalyearproject/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:finalyearproject/features/auth/domain/repository/user_repository.dart';
import 'package:finalyearproject/features/auth/data/data_source/local_datasource/user_local_datasource.dart';

final serviceLocator = GetIt.instance;

void setupLocator() {
  // Splash ViewModel
  serviceLocator.registerLazySingleton(() => SplashViewModel());

  // Hive Service
  serviceLocator.registerLazySingleton<HiveService>(() => HiveService());

  // Local Data Source
  serviceLocator.registerLazySingleton<UserLocalDatasource>(
    () => UserLocalDatasource(hiveService: serviceLocator()),
  );

  // Repository
  serviceLocator.registerLazySingleton<IUserRepository>(
    () => UserLocalRepository(userLocalDatasource: serviceLocator()),
  );

  // Use Case
  serviceLocator.registerLazySingleton(
    () => UserLoginUsecase(userRepository: serviceLocator()),
  );

  // Login ViewModel
  serviceLocator.registerFactory(
    () => LoginViewModel(userLoginUsecase: serviceLocator()),
  );
}

