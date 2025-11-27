import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/services/hive_service.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme_data.dart';
import 'core/theme/app_theme_mode.dart';
import 'core/theme/cubit/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  
  // Initialize dependency injection
  await configureDependencies();

  // Initialize notifications
  await getIt<NotificationService>().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(getIt<HiveService>()),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              // Determine theme mode
              ThemeMode themeMode;
              switch (themeState.themeMode) {
                case AppThemeMode.light:
                  themeMode = ThemeMode.light;
                  break;
                case AppThemeMode.dark:
                  themeMode = ThemeMode.dark;
                  break;
                case AppThemeMode.system:
                  themeMode = ThemeMode.system;
                  break;
              }

              return MaterialApp.router(
                title: 'Flutter Boilerplate',
                debugShowCheckedModeBanner: false,
                
                // Light Theme
                theme: AppThemeData.getTheme(
                  brightness: Brightness.light,
                  themeType: themeState.themeType,
                ),
                
                // Dark Theme
                darkTheme: AppThemeData.getTheme(
                  brightness: Brightness.dark,
                  themeType: themeState.themeType,
                ),
                
                themeMode: themeMode,
                routerConfig: getIt<AppRouter>().router,
              );
            },
          );
        },
      ),
    );
  }
}