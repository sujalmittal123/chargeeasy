import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/main_nav_shell.dart';
import '../features/splash/splash_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/session_detail/session_detail_screen.dart';
import '../features/history/history_screen.dart';
import '../features/charger_profiles/charger_profiles_screen.dart';
import '../features/health/health_screen.dart';
import '../features/discharge/discharge_screen.dart';
import '../features/alarms/alarms_screen.dart';
import '../features/alarms/guard_mode_screen.dart';
import '../features/reports/reports_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/calibration/calibration_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/premium/premium_subscription_sheet.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(forced: true),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainNavShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/dashboard',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const DashboardScreen(),
            transitionsBuilder: (context, anim, secAnim, child) => FadeTransition(opacity: anim, child: child),
          ),
        ),
        GoRoute(
          path: '/history',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const HistoryScreen(),
            transitionsBuilder: (context, anim, secAnim, child) => FadeTransition(opacity: anim, child: child),
          ),
        ),
        GoRoute(
          path: '/health',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const HealthScreen(),
            transitionsBuilder: (context, anim, secAnim, child) => FadeTransition(opacity: anim, child: child),
          ),
        ),
        GoRoute(
          path: '/reports',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const ReportsScreen(),
            transitionsBuilder: (context, anim, secAnim, child) => FadeTransition(opacity: anim, child: child),
          ),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const SettingsScreen(),
            transitionsBuilder: (context, anim, secAnim, child) => FadeTransition(opacity: anim, child: child),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/session/:id',
      builder: (context, state) => SessionDetailScreen(id: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/chargers',
      builder: (context, state) => const ChargerProfilesScreen(),
    ),
    GoRoute(
      path: '/discharge',
      builder: (context, state) => const DischargeScreen(),
    ),
    GoRoute(
      path: '/alarms',
      builder: (context, state) => const AlarmsScreen(),
    ),
    GoRoute(
      path: '/guard',
      builder: (context, state) => const GuardModeScreen(),
    ),
    GoRoute(
      path: '/calibration',
      builder: (context, state) => const CalibrationScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/premium',
      pageBuilder: (context, state) => const MaterialPage(
        fullscreenDialog: true,
        child: Scaffold(body: SafeArea(child: PremiumSubscriptionSheet())),
      ),
    ),
  ],
);
// Alias used by main.dart
final appRouter = goRouter;
