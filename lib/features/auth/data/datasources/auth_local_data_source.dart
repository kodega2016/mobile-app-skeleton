import '../../../../core/services/hive_service.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/utils/failure.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearCache();
  Future<String?> getToken();
  Future<void> saveToken(String token);
  Future<void> clearToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final HiveService hiveService;
  final SecureStorageService secureStorage;

  static const String _userKey = 'cached_user';

  AuthLocalDataSourceImpl({
    required this.hiveService,
    required this.secureStorage,
  });

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userData = hiveService.getUser();
      if (userData != null) {
        return UserModel.fromJson(Map<String, dynamic>.from(userData));
      }
      return null;
    } catch (e) {
      throw CacheFailure('Failed to get cached user: $e');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await hiveService.saveUser(user.toJson());
    } catch (e) {
      throw CacheFailure('Failed to cache user: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await hiveService.deleteUser();
    } catch (e) {
      throw CacheFailure('Failed to clear cache: $e');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return await secureStorage.getToken();
    } catch (e) {
      throw CacheFailure('Failed to get token: $e');
    }
  }

  @override
  Future<void> saveToken(String token) async {
    try {
      await secureStorage.saveToken(token);
    } catch (e) {
      throw CacheFailure('Failed to save token: $e');
    }
  }

  @override
  Future<void> clearToken() async {
    try {
      await secureStorage.deleteToken();
    } catch (e) {
      throw CacheFailure('Failed to clear token: $e');
    }
  }
}