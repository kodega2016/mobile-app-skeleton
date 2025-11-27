import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/failure.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
  });

  Future<void> logout();

  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    // 🎭 MOCK IMPLEMENTATION
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Validate mock credentials
    if (email == 'test@example.com' && password == 'password123') {
      // Return mock successful response
      return {
        'token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
        'user': {
          'id': 'user_123',
          'email': email,
          'name': 'Test User',
          'profile_image': 'https://ui-avatars.com/api/?name=Test+User',
          'created_at': DateTime.now().toIso8601String(),
        },
      };
    } else {
      // Return mock error
      throw const UnauthorizedFailure('Invalid email or password');
    }

    /* 
    // 🌐 REAL API IMPLEMENTATION (uncomment when ready)
    try {
      final response = await dioClient.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ServerFailure('Login failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure('Unexpected error: $e');
    }
    */
  }

  @override
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    // 🎭 MOCK IMPLEMENTATION
    await Future.delayed(const Duration(seconds: 1));

    // Simple validation
    if (email.contains('@') && password.length >= 6) {
      return {
        'token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
        'user': {
          'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
          'email': email,
          'name': name,
          'profile_image': 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}',
          'created_at': DateTime.now().toIso8601String(),
        },
      };
    } else {
      throw const ValidationFailure('Invalid registration data');
    }

    /* 
    // 🌐 REAL API IMPLEMENTATION
    try {
      final response = await dioClient.post(
        ApiConstants.register,
        data: {
          'email': email,
          'password': password,
          'name': name,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ServerFailure('Registration failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure('Unexpected error: $e');
    }
    */
  }

  @override
  Future<void> logout() async {
    // 🎭 MOCK IMPLEMENTATION
    await Future.delayed(const Duration(milliseconds: 500));
    // Just return success
    return;

    /* 
    // 🌐 REAL API IMPLEMENTATION
    try {
      await dioClient.post(ApiConstants.logout);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure('Unexpected error: $e');
    }
    */
  }

  @override
  Future<UserModel> getCurrentUser() async {
    // 🎭 MOCK IMPLEMENTATION
    await Future.delayed(const Duration(milliseconds: 500));

    return UserModel(
      id: 'user_123',
      email: 'test@example.com',
      name: 'Test User',
      profileImage: 'https://ui-avatars.com/api/?name=Test+User',
      createdAt: DateTime.now(),
    );

    /* 
    // 🌐 REAL API IMPLEMENTATION
    try {
      final response = await dioClient.get(ApiConstants.profile);

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw ServerFailure('Failed to get user with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure('Unexpected error: $e');
    }
    */
  }

  // Helper method for real API error handling
  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Connection timeout');
      
      case DioExceptionType.connectionError:
        return const NetworkFailure('No internet connection');
      
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          return const UnauthorizedFailure('Unauthorized');
        } else if (statusCode == 404) {
          return const NotFoundFailure('Resource not found');
        } else {
          return ServerFailure('Server error: $statusCode');
        }
      
      default:
        return const ServerFailure('Unexpected error occurred');
    }
  }
}