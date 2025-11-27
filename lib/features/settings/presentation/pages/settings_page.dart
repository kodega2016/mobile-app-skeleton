import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme_data.dart';
import '../../../../core/theme/app_theme_mode.dart';
import '../../../../core/theme/cubit/theme_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // Theme Mode Section
          Text(
            'Appearance',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16.h),
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.brightness_6),
                      title: const Text('Theme Mode'),
                      trailing: DropdownButton<AppThemeMode>(
                        value: state.themeMode,
                        underline: const SizedBox(),
                        items: AppThemeMode.values.map((mode) {
                          return DropdownMenuItem(
                            value: mode,
                            child: Text(mode.label),
                          );
                        }).toList(),
                        onChanged: (mode) {
                          if (mode != null) {
                            context.read<ThemeCubit>().changeThemeMode(mode);
                          }
                        },
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.palette),
                      title: const Text('Color Theme'),
                      trailing: DropdownButton<AppThemeType>(
                        value: state.themeType,
                        underline: const SizedBox(),
                        items: AppThemeType.values.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 16.w,
                                  height: 16.w,
                                  decoration: BoxDecoration(
                                    color: _getThemeColor(type),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(type.label),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (type) {
                          if (type != null) {
                            context.read<ThemeCubit>().changeThemeType(type);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          SizedBox(height: 24.h),

          // Theme Preview
          Text(
            'Preview',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16.h),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Sample Text',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'This is how your text will look in the selected theme.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Primary Button'),
                  ),
                  SizedBox(height: 8.h),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('Outlined Button'),
                  ),
                  SizedBox(height: 8.h),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Text Button'),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 24.h),

          // Color Palette Preview
          Text(
            'Color Palette',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16.h),
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              final colorScheme = Theme.of(context).colorScheme;
              return Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: [
                  _ColorChip(
                    color: colorScheme.primary,
                    label: 'Primary',
                  ),
                  _ColorChip(
                    color: colorScheme.secondary,
                    label: 'Secondary',
                  ),
                  _ColorChip(
                    color: colorScheme.surface,
                    label: 'Surface',
                  ),
                  _ColorChip(
                    color: colorScheme.error,
                    label: 'Error',
                  ),
                ],
              );
            },
          ),

          SizedBox(height: 24.h),

          // Reset Theme
          ElevatedButton.icon(
            onPressed: () {
              context.read<ThemeCubit>().resetTheme();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Theme reset to default'),
                ),
              );
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Reset to Default Theme'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }

  Color _getThemeColor(AppThemeType type) {
    switch (type) {
      case AppThemeType.purple:
        return const Color(0xFF6200EE);
      case AppThemeType.blue:
        return const Color(0xFF2196F3);
      case AppThemeType.green:
        return const Color(0xFF4CAF50);
      case AppThemeType.red:
        return const Color(0xFFF44336);
    }
  }
}

class _ColorChip extends StatelessWidget {
  final Color color;
  final String label;

  const _ColorChip({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: _getContrastColor(color),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getContrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}