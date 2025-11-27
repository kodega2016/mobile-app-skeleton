import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/core/services/hive_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../app_theme_data.dart';
import '../app_theme_mode.dart';

part 'theme_state.dart';
part 'theme_cubit.freezed.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final HiveService _hiveService;

  static const String _themeModeKey = 'theme_mode';
  static const String _themeTypeKey = 'theme_type';

  ThemeCubit(this._hiveService)
      : super(const ThemeState(
          themeMode: AppThemeMode.system,
          themeType: AppThemeType.purple,
        )) {
    _loadThemePreferences();
  }

  Future<void> _loadThemePreferences() async {
    final themeModeIndex = _hiveService.getSetting(_themeModeKey) as int?;
    final themeTypeIndex = _hiveService.getSetting(_themeTypeKey) as int?;

    final themeMode = themeModeIndex != null
        ? AppThemeMode.values[themeModeIndex]
        : AppThemeMode.system;

    final themeType = themeTypeIndex != null
        ? AppThemeType.values[themeTypeIndex]
        : AppThemeType.purple;

    emit(ThemeState(
      themeMode: themeMode,
      themeType: themeType,
    ));
  }

  Future<void> changeThemeMode(AppThemeMode mode) async {
    await _hiveService.saveSetting(_themeModeKey, mode.index);
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> changeThemeType(AppThemeType type) async {
    await _hiveService.saveSetting(_themeTypeKey, type.index);
    emit(state.copyWith(themeType: type));
  }

  Future<void> resetTheme() async {
    await _hiveService.saveSetting(_themeModeKey, AppThemeMode.system.index);
    await _hiveService.saveSetting(_themeTypeKey, AppThemeType.purple.index);
    emit(const ThemeState(
      themeMode: AppThemeMode.system,
      themeType: AppThemeType.purple,
    ));
  }
}