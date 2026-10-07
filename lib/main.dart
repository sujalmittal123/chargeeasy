import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import 'data/database/app_database.dart';
import 'data/services/notification_service.dart';
import 'providers/settings_provider.dart';
import 'ui/core/app_router.dart';
import 'ui/core/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Edge-to-edge UI
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialise local DB
  final db = AppDatabase();

  // Initialise notification service (creates channels)
  final notificationService = NotificationService();
  await notificationService.initialize();

  // Request Android 13+ runtime notification permission
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  runApp(
    ProviderScope(
      overrides: [
        // Provide the singleton DB instance to all Riverpod providers
        appDatabaseProvider.overrideWithValue(db),
      ],
      child: const ChargeTrackerApp(),
    ),
  );
}

class ChargeTrackerApp extends ConsumerWidget {
  const ChargeTrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final appThemeMode = settingsAsync.valueOrNull?.appThemeMode ?? AppThemeMode.system;
    final themeMode = settingsAsync.valueOrNull?.themeMode ?? ThemeMode.system;

    return MaterialApp.router(
      title: 'Charge Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: appThemeMode == AppThemeMode.amoled
          ? AppTheme.amoled
          : AppTheme.dark,
      themeMode: appThemeMode == AppThemeMode.amoled ? ThemeMode.dark : themeMode,
      routerConfig: appRouter,
    );
  }
}
