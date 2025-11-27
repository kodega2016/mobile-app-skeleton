import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/theme/cubit/theme_cubit.dart';
import '../../../settings/presentation/pages/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeTabView(),
    const ProfileTabView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Boilerplate'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: context.read<ThemeCubit>(),
                    child: const SettingsPage(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        // Welcome Card
        Card(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.waving_hand,
                        color: colorScheme.primary,
                        size: 30.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome Back!',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Ready to explore?',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 24.h),

        // Features Section
        Text(
          'Features',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 16.h),

        // Feature Grid
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12.w,
          crossAxisSpacing: 12.w,
          childAspectRatio: 1.1,  // Changed from 1.2 to 1.1 for more height
          children: [
            _FeatureCard(
              icon: Icons.storage,
              title: 'Offline First',
              description: 'Cache-first architecture',
              color: Colors.blue,
              onTap: () {
                _showFeatureDialog(
                  context,
                  'Offline First',
                  'Data is cached locally and synced when online. Works seamlessly without internet.',
                );
              },
            ),
            _FeatureCard(
              icon: Icons.cloud_sync,
              title: 'Auto Sync',
              description: 'Background data sync',
              color: Colors.green,
              onTap: () {
                _showFeatureDialog(
                  context,
                  'Auto Sync',
                  'Automatically syncs data in the background when connected to internet.',
                );
              },
            ),
            _FeatureCard(
              icon: Icons.notifications,
              title: 'Notifications',
              description: 'Local & push alerts',
              color: Colors.orange,
              onTap: () async {
                final notificationService = getIt<NotificationService>();
                await notificationService.showNotification(
                  id: DateTime.now().millisecondsSinceEpoch,
                  title: 'Test Notification',
                  body: 'This is a test notification from Flutter Boilerplate!',
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Test notification sent!')),
                  );
                }
              },
            ),
            _FeatureCard(
              icon: Icons.palette,
              title: 'Themes',
              description: '4 color themes',
              color: Colors.purple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: context.read<ThemeCubit>(),
                      child: const SettingsPage(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),

        SizedBox(height: 24.h),

        // Statistics Card
        Text(
          'Statistics',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 16.h),

        Card(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                _StatRow(
                  icon: Icons.code,
                  label: 'Clean Architecture',
                  value: 'Enabled',
                  color: colorScheme.primary,
                ),
                Divider(height: 24.h),
                _StatRow(
                  icon: Icons.security,
                  label: 'Secure Storage',
                  value: 'Active',
                  color: Colors.green,
                ),
                Divider(height: 24.h),
                _StatRow(
                  icon: Icons.speed,
                  label: 'Performance',
                  value: 'Optimized',
                  color: Colors.orange,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showFeatureDialog(BuildContext context, String title, String description) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class ProfileTabView extends StatelessWidget {
  const ProfileTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        // Profile Header
        Card(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50.r,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person,
                    size: 50.sp,
                    color: colorScheme.primary,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'John Doe',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 4.h),
                Text(
                  'john.doe@example.com',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 24.h),

        // Menu Items
        _MenuItem(
          icon: Icons.edit,
          title: 'Edit Profile',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Edit Profile coming soon!')),
            );
          },
        ),
        _MenuItem(
          icon: Icons.settings,
          title: 'Settings',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: context.read<ThemeCubit>(),
                  child: const SettingsPage(),
                ),
              ),
            );
          },
        ),
        _MenuItem(
          icon: Icons.help,
          title: 'Help & Support',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Help & Support coming soon!')),
            );
          },
        ),
        _MenuItem(
          icon: Icons.info,
          title: 'About',
          onTap: () {
            showAboutDialog(
              context: context,
              applicationName: 'Flutter Boilerplate',
              applicationVersion: '1.0.0',
              applicationIcon: Icon(
                Icons.flutter_dash,
                size: 48.sp,
                color: colorScheme.primary,
              ),
              children: [
                const Text(
                  'A production-ready Flutter boilerplate with Clean Architecture, Offline-First, and comprehensive testing.',
                ),
              ],
            );
          },
        ),
        SizedBox(height: 16.h),
        _MenuItem(
          icon: Icons.logout,
          title: 'Logout',
          iconColor: Colors.red,
          onTap: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to logout?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );

            if (confirmed == true && context.mounted) {
              final secureStorage = getIt<SecureStorageService>();
              await secureStorage.deleteAll();
              if (context.mounted) {
                context.go('/login');
              }
            }
          },
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(12.w),  // Changed from 16.w to 12.w
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48.w,  // Changed from 50.w to 48.w
                height: 48.w,  // Changed from 50.w to 48.w
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24.sp,  // Changed from 28.sp to 24.sp
                ),
              ),
              SizedBox(height: 8.h),  // Changed from 12.h to 8.h
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,  // Changed from titleMedium
                textAlign: TextAlign.center,
                maxLines: 1,  // Added maxLines
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.h),  // Changed from 4.h to 2.h
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 20.sp,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? iconColor;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}