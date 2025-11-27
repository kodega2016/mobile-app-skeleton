import 'package:flutter_boilerplate/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_boilerplate/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_boilerplate/features/auth/data/repositories/auth_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../router/app_router.dart';
import '../services/hive_service.dart';
import '../services/notification_service.dart';
import '../services/secure_storage_service.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/check_auth_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // External Dependencies
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());

  // Core Services
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );
  
  getIt.registerLazySingleton<HiveService>(
    () => HiveService(),
  );
  
  getIt.registerLazySingleton<NotificationService>(
    () => NotificationService(),
  );

  // Network
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(),
  );

  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt<Connectivity>()),
  );

  // Router
  getIt.registerLazySingleton<AppRouter>(
    () => AppRouter(),
  );

  // Auth Feature - Data Sources
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      hiveService: getIt<HiveService>(),
      secureStorage: getIt<SecureStorageService>(),
    ),
  );

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      dioClient: getIt<DioClient>(),
    ),
  );

  // Auth Feature - Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // Auth Feature - Use Cases
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<CheckAuthUseCase>(
    () => CheckAuthUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(getIt<AuthRepository>()),
  );

  // Initialize services that need async setup
  await getIt<HiveService>().init();
}