// lib/app/service_locator/service_locator.dart

import 'package:get_it/get_it.dart';
import 'package:finalyearproject/features/splash/presentation/view_model/splash_view_model.dart';

final serviceLocator = GetIt.instance;

void setupLocator() {
  serviceLocator.registerLazySingleton(() => SplashViewModel());
}
