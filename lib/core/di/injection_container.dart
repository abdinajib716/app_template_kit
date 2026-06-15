import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../api/api.dart';
import '../config/config.dart';
import '../network/network.dart';
import '../storage/storage.dart';
import '../theme/theme.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerLazySingleton<TokenStorage>(TokenStorage.new);
  getIt.registerLazySingleton<Dio>(_buildDio);
  getIt.registerLazySingleton<ApiClient>(() => ApiClient(getIt<Dio>()));

  getIt.registerLazySingleton<NetworkInfo>(NetworkInfoImpl.new);
  getIt.registerLazySingleton<ConnectivityCubit>(
    () => ConnectivityCubit(networkInfo: getIt<NetworkInfo>()),
  );

  final themeProvider = ThemeProvider();
  await themeProvider.init();
  getIt.registerSingleton<ThemeProvider>(themeProvider);
}

Dio _buildDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppEnvironment.apiBaseUrl,
      connectTimeout: AppEnvironment.apiConnectTimeout,
      receiveTimeout: AppEnvironment.apiReceiveTimeout,
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  dio.interceptors.add(AuthInterceptor(getIt<TokenStorage>()));

  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(requestBody: false, responseBody: false),
    );
  }

  return dio;
}
