import 'package:dartz/dartz.dart';
import 'package:flutter_boilerplate/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_boilerplate/features/auth/data/datasources/auth_remote_data_source.dart';

import '../../../../core/network/network_info.dart';
import '../../../../core/utils/failure.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

/// Auth Repository Implementation (Data Layer)
/// Implements offline-first architecture with cache-first strategy
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Check network connectivity
      final isConnected = await networkInfo.isConnected;
      
      if (!isConnected) {
        return const Left(NetworkFailure('No internet connection'));
      }

      // Make remote call
      final response = await remoteDataSource.login(
        email: email,
        password: password,
      );

      // Extract and save token
      final token = response['token'] as String?;
      if (token != null) {
        await localDataSource.saveToken(token);
      }

      // Extract user and cache it
      final userJson = response['user'] as Map<String, dynamic>;
      final userModel = UserModel.fromJson(userJson);
      await localDataSource.cacheUser(userModel);

      return Right(userModel.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure('Login failed: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final isConnected = await networkInfo.isConnected;
      
      if (!isConnected) {
        return const Left(NetworkFailure('No internet connection'));
      }

      final response = await remoteDataSource.register(
        email: email,
        password: password,
        name: name,
      );

      final token = response['token'] as String?;
      if (token != null) {
        await localDataSource.saveToken(token);
      }

      final userJson = response['user'] as Map<String, dynamic>;
      final userModel = UserModel.fromJson(userJson);
      await localDataSource.cacheUser(userModel);

      return Right(userModel.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure('Registration failed: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final isConnected = await networkInfo.isConnected;
      
      // Try remote logout if connected
      if (isConnected) {
        try {
          await remoteDataSource.logout();
        } catch (e) {
          // Continue with local logout even if remote fails
        }
      }

      // Always clear local data
      await localDataSource.clearToken();
      await localDataSource.clearCache();

      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure('Logout failed: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> checkAuthStatus() async {
    try {
      // First, check for cached user (offline-first)
      final cachedUser = await localDataSource.getCachedUser();
      final token = await localDataSource.getToken();

      if (cachedUser == null || token == null) {
        return const Left(UnauthorizedFailure('Not authenticated'));
      }

      // Return cached user immediately
      final userEntity = cachedUser.toEntity();

      // Try to refresh from server in background if connected
      final isConnected = await networkInfo.isConnected;
      if (isConnected) {
        _refreshUserInBackground();
      }

      return Right(userEntity);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure('Auth check failed: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      // Try cache first (offline-first)
      final cachedUser = await localDataSource.getCachedUser();
      
      if (cachedUser != null) {
        // Return cached data immediately
        final userEntity = cachedUser.toEntity();
        
        // Refresh from network in background if connected
        final isConnected = await networkInfo.isConnected;
        if (isConnected) {
          _refreshUserInBackground();
        }
        
        return Right(userEntity);
      }

      // If no cache, try network
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return const Left(NetworkFailure('No cached data and no internet connection'));
      }

      final userModel = await remoteDataSource.getCurrentUser();
      await localDataSource.cacheUser(userModel);

      return Right(userModel.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure('Failed to get user: $e'));
    }
  }

  // Background refresh - fire and forget
  Future<void> _refreshUserInBackground() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      await localDataSource.cacheUser(userModel);
    } catch (e) {
      // Silently fail - we already have cached data
    }
  }
}