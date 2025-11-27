import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

class HiveService {
  final _logger = Logger();
  
  // Box names
  static const String userBoxName = 'user_box';
  static const String settingsBoxName = 'settings_box';
  static const String cacheBoxName = 'cache_box';

  Future<void> init() async {
    try {
      // Register adapters here
      // Hive.registerAdapter(UserAdapter());
      
      // Open boxes only if not already open
      if (!Hive.isBoxOpen(userBoxName)) {
        await Hive.openBox(userBoxName);
      }
      if (!Hive.isBoxOpen(settingsBoxName)) {
        await Hive.openBox(settingsBoxName);
      }
      if (!Hive.isBoxOpen(cacheBoxName)) {
        await Hive.openBox(cacheBoxName);
      }
      
      _logger.i('Hive initialized successfully');
    } catch (e) {
      _logger.e('Error initializing Hive: $e');
      rethrow;
    }
  }

  // Generic operations
  Box<T> getBox<T>(String boxName) {
    if (!Hive.isBoxOpen(boxName)) {
      throw Exception('Box $boxName is not open. Call init() first.');
    }
    return Hive.box<T>(boxName);
  }

  Future<void> put<T>(String boxName, String key, T value) async {
    final box = getBox<T>(boxName);
    await box.put(key, value);
  }

  T? get<T>(String boxName, String key) {
    final box = getBox<T>(boxName);
    return box.get(key);
  }

  Future<void> delete(String boxName, String key) async {
    final box = getBox(boxName);
    await box.delete(key);
  }

  Future<void> clear(String boxName) async {
    final box = getBox(boxName);
    await box.clear();
  }

  Future<void> clearAll() async {
    try {
      if (Hive.isBoxOpen(userBoxName)) {
        await Hive.box(userBoxName).clear();
      }
      if (Hive.isBoxOpen(settingsBoxName)) {
        await Hive.box(settingsBoxName).clear();
      }
      if (Hive.isBoxOpen(cacheBoxName)) {
        await Hive.box(cacheBoxName).clear();
      }
    } catch (e) {
      _logger.e('Error clearing all boxes: $e');
    }
  }

  // User box operations
  Future<void> saveUser(Map<String, dynamic> user) async {
    await put(userBoxName, 'current_user', user);
  }

  Map<String, dynamic>? getUser() {
    try {
      final data = get(userBoxName, 'current_user');
      if (data == null) return null;
      if (data is Map) {
        return Map<String, dynamic>.from(data as Map);
      }
      return null;
    } catch (e) {
      _logger.e('Error getting user: $e');
      return null;
    }
  }

  Future<void> deleteUser() async {
    await delete(userBoxName, 'current_user');
  }

  // Settings box operations
  Future<void> saveSetting(String key, dynamic value) async {
    await put(settingsBoxName, key, value);
  }

  dynamic getSetting(String key) {
    return get(settingsBoxName, key);
  }

  // Cache operations
  Future<void> cacheData(String key, dynamic data) async {
    await put(cacheBoxName, key, data);
  }

  dynamic getCachedData(String key) {
    return get(cacheBoxName, key);
  }

  Future<void> clearCache() async {
    await clear(cacheBoxName);
  }

  // Close all boxes (useful for testing or cleanup)
  Future<void> closeAll() async {
    try {
      if (Hive.isBoxOpen(userBoxName)) {
        await Hive.box(userBoxName).close();
      }
      if (Hive.isBoxOpen(settingsBoxName)) {
        await Hive.box(settingsBoxName).close();
      }
      if (Hive.isBoxOpen(cacheBoxName)) {
        await Hive.box(cacheBoxName).close();
      }
      _logger.i('All Hive boxes closed');
    } catch (e) {
      _logger.e('Error closing boxes: $e');
    }
  }
}