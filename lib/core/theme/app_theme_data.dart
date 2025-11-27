import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

enum AppThemeType {
  purple,
  blue,
  green,
  red;

  String get label {
    switch (this) {
      case AppThemeType.purple:
        return 'Purple';
      case AppThemeType.blue:
        return 'Blue';
      case AppThemeType.green:
        return 'Green';
      case AppThemeType.red:
        return 'Red';
    }
  }
}

class AppThemeData {
  static ThemeData getTheme({
    required Brightness brightness,
    required AppThemeType themeType,
  }) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = _getColorScheme(brightness, themeType);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        foregroundColor: isDark ? AppColors.white : AppColors.black,
        titleTextStyle: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.white : AppColors.black,
        ),
        iconTheme: IconThemeData(
          color: isDark ? AppColors.white : AppColors.black,
        ),
      ),

      // Text Theme
      textTheme: _getTextTheme(isDark),

      // Button Themes
      elevatedButtonTheme: _getElevatedButtonTheme(colorScheme),
      textButtonTheme: _getTextButtonTheme(colorScheme),
      outlinedButtonTheme: _getOutlinedButtonTheme(colorScheme),

      // Input Decoration Theme
      inputDecorationTheme: _getInputDecorationTheme(isDark, colorScheme),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        color: isDark ? AppColors.darkSurface : AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: isDark ? AppColors.grey : AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24.r),
          ),
        ),
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: isDark ? AppColors.white : AppColors.black,
        size: 24.sp,
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.greyDark : AppColors.greyLight,
        thickness: 1,
        space: 1,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.greyLight,
        selectedColor: colorScheme.primary.withOpacity(0.2),
        labelStyle: TextStyle(
          color: isDark ? AppColors.white : AppColors.black,
          fontSize: 14.sp,
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary;
          }
          return isDark ? AppColors.grey : AppColors.greyLight;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary.withOpacity(0.5);
          }
          return isDark ? AppColors.greyDark : AppColors.greyLight;
        }),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
      ),
    );
  }

  static ColorScheme _getColorScheme(
    Brightness brightness,
    AppThemeType themeType,
  ) {
    final isDark = brightness == Brightness.dark;

    Color primary;
    Color primaryVariant;
    Color secondary;
    Color secondaryVariant;

    switch (themeType) {
      case AppThemeType.purple:
        primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
        primaryVariant = isDark ? AppColors.darkPrimaryVariant : AppColors.lightPrimaryVariant;
        secondary = isDark ? AppColors.darkSecondary : AppColors.lightSecondary;
        secondaryVariant = isDark ? AppColors.darkSecondaryVariant : AppColors.lightSecondaryVariant;
        break;
      case AppThemeType.blue:
        primary = AppColors.bluePrimary;
        primaryVariant = AppColors.bluePrimaryVariant;
        secondary = AppColors.blueSecondary;
        secondaryVariant = AppColors.blueSecondaryVariant;
        break;
      case AppThemeType.green:
        primary = AppColors.greenPrimary;
        primaryVariant = AppColors.greenPrimaryVariant;
        secondary = AppColors.greenSecondary;
        secondaryVariant = AppColors.greenSecondaryVariant;
        break;
      case AppThemeType.red:
        primary = AppColors.redPrimary;
        primaryVariant = AppColors.redPrimaryVariant;
        secondary = AppColors.redSecondary;
        secondaryVariant = AppColors.redSecondaryVariant;
        break;
    }

    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: isDark ? AppColors.darkOnPrimary : AppColors.lightOnPrimary,
      secondary: secondary,
      onSecondary: isDark ? AppColors.darkOnSecondary : AppColors.lightOnSecondary,
      error: isDark ? AppColors.darkError : AppColors.lightError,
      onError: isDark ? AppColors.darkOnError : AppColors.lightOnError,
      surface: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      onSurface: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
    );
  }

  static TextTheme _getTextTheme(bool isDark) {
    final color = isDark ? AppColors.white : AppColors.black;
    final secondaryColor = isDark ? AppColors.white.withOpacity(0.7) : AppColors.textSecondary;

    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.bold,
        color: color,
      ),
      displayMedium: TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        color: color,
      ),
      displaySmall: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        color: color,
      ),
      headlineLarge: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      headlineMedium: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      headlineSmall: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      titleLarge: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      titleMedium: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      titleSmall: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      bodyLarge: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
        color: secondaryColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
        color: secondaryColor,
      ),
      bodySmall: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
        color: secondaryColor,
      ),
      labelLarge: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      labelMedium: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      labelSmall: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
      ),
    );
  }

  static ElevatedButtonThemeData _getElevatedButtonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 48.h),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        textStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        elevation: 2,
      ),
    );
  }

  static TextButtonThemeData _getTextButtonTheme(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        textStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _getOutlinedButtonTheme(ColorScheme colorScheme) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: Size(double.infinity, 48.h),
        foregroundColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.primary, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        textStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static InputDecorationTheme _getInputDecorationTheme(
    bool isDark,
    ColorScheme colorScheme,
  ) {
    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? AppColors.darkSurface : AppColors.greyLight.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: colorScheme.error, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: colorScheme.error, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      hintStyle: TextStyle(
        color: isDark ? AppColors.grey : AppColors.textHint,
        fontSize: 14.sp,
      ),
      labelStyle: TextStyle(
        color: isDark ? AppColors.grey : AppColors.textSecondary,
        fontSize: 14.sp,
      ),
    );
  }
}