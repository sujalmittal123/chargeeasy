import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/database/app_database.dart';
import '../data/repositories/settings_repository.dart';
import '../ui/core/app_theme.dart';

part 'settings_provider.g.dart';

// ── Singleton DB provider (overridden in main.dart) ──────────────────────────
@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref) => AppDatabase();

// ── Settings repository provider ─────────────────────────────────────────────
@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(SettingsRepositoryRef ref) {
  return SettingsRepository(ref.watch(appDatabaseProvider).settingsDao);
}

// ── App-wide settings model ──────────────────────────────────────────────────
class AppSettings {
  final ThemeMode themeMode;
  final AppThemeMode appThemeMode;
  final int chargeLimitPct;
  final double overheatThresholdC;
  final int lowBatteryPct;
  final bool chargeLimitEnabled;
  final bool lowBatteryEnabled;
  final bool guardModeEnabled;
  final bool foregroundServiceEnabled;
  final int designCapacityMah;
  final bool currentSignPositive;
  final bool onboardingComplete;
  final bool isPro;
  final bool dontShowIntroAgain;
  final bool premiumNotifyMe;

  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.appThemeMode = AppThemeMode.system,
    this.chargeLimitPct = 80,
    this.overheatThresholdC = 42.0,
    this.lowBatteryPct = 15,
    this.chargeLimitEnabled = true,
    this.lowBatteryEnabled = true,
    this.guardModeEnabled = false,
    this.foregroundServiceEnabled = true,
    this.designCapacityMah = 0,
    this.currentSignPositive = true,
    this.onboardingComplete = false,
    this.isPro = false,
    this.dontShowIntroAgain = false,
    this.premiumNotifyMe = false,
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    AppThemeMode? appThemeMode,
    int? chargeLimitPct,
    double? overheatThresholdC,
    int? lowBatteryPct,
    bool? chargeLimitEnabled,
    bool? lowBatteryEnabled,
    bool? guardModeEnabled,
    bool? foregroundServiceEnabled,
    int? designCapacityMah,
    bool? currentSignPositive,
    bool? onboardingComplete,
    bool? isPro,
    bool? dontShowIntroAgain,
    bool? premiumNotifyMe,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      appThemeMode: appThemeMode ?? this.appThemeMode,
      chargeLimitPct: chargeLimitPct ?? this.chargeLimitPct,
      overheatThresholdC: overheatThresholdC ?? this.overheatThresholdC,
      lowBatteryPct: lowBatteryPct ?? this.lowBatteryPct,
      chargeLimitEnabled: chargeLimitEnabled ?? this.chargeLimitEnabled,
      lowBatteryEnabled: lowBatteryEnabled ?? this.lowBatteryEnabled,
      guardModeEnabled: guardModeEnabled ?? this.guardModeEnabled,
      foregroundServiceEnabled: foregroundServiceEnabled ?? this.foregroundServiceEnabled,
      designCapacityMah: designCapacityMah ?? this.designCapacityMah,
      currentSignPositive: currentSignPositive ?? this.currentSignPositive,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      isPro: isPro ?? this.isPro,
      dontShowIntroAgain: dontShowIntroAgain ?? this.dontShowIntroAgain,
      premiumNotifyMe: premiumNotifyMe ?? this.premiumNotifyMe,
    );
  }
}

// ── Settings AsyncNotifier ────────────────────────────────────────────────────
@Riverpod(keepAlive: true)
class Settings extends _$Settings {
  @override
  Future<AppSettings> build() async {
    final repo = ref.watch(settingsRepositoryProvider);
    return _loadFromRepo(repo);
  }

  Future<AppSettings> _loadFromRepo(SettingsRepository repo) async {
    final themeStr         = await repo.get('theme_mode') ?? 'system';
    final chargeLimitStr   = await repo.get('charge_limit') ?? '80';
    final overheatStr      = await repo.get('overheat_threshold') ?? '42.0';
    final lowBattStr       = await repo.get('low_battery_pct') ?? '15';
    final designCapStr     = await repo.get('design_capacity_mah') ?? '0';
    final currentSignStr   = await repo.get('current_sign_positive') ?? 'true';
    final onboardingStr    = await repo.get('onboarding_complete') ?? 'false';
    final isProStr         = await repo.get('is_pro') ?? 'false';
    final dontShowIntroStr = await repo.get('dont_show_intro_again') ?? 'false';
    final notifyMeStr      = await repo.get('premium_notify_me') ?? 'false';
    final chargeLimEnabled = await repo.get('charge_limit_enabled') ?? 'true';
    final lowBattEnabled   = await repo.get('low_battery_enabled') ?? 'true';
    final guardModeStr     = await repo.get('guard_mode') ?? 'false';
    final fgServiceStr     = await repo.get('foreground_service') ?? 'true';

    AppThemeMode appThemeMode;
    ThemeMode themeMode;
    switch (themeStr) {
      case 'light':
        appThemeMode = AppThemeMode.light;
        themeMode = ThemeMode.light;
      case 'dark':
        appThemeMode = AppThemeMode.dark;
        themeMode = ThemeMode.dark;
      case 'amoled':
        appThemeMode = AppThemeMode.amoled;
        themeMode = ThemeMode.dark;
      default:
        appThemeMode = AppThemeMode.system;
        themeMode = ThemeMode.system;
    }

    return AppSettings(
      themeMode: themeMode,
      appThemeMode: appThemeMode,
      chargeLimitPct: int.tryParse(chargeLimitStr) ?? 80,
      overheatThresholdC: double.tryParse(overheatStr) ?? 42.0,
      lowBatteryPct: int.tryParse(lowBattStr) ?? 15,
      chargeLimitEnabled: chargeLimEnabled == 'true',
      lowBatteryEnabled: lowBattEnabled == 'true',
      guardModeEnabled: guardModeStr == 'true',
      foregroundServiceEnabled: fgServiceStr == 'true',
      designCapacityMah: int.tryParse(designCapStr) ?? 0,
      currentSignPositive: currentSignStr == 'true',
      onboardingComplete: onboardingStr == 'true',
      isPro: isProStr == 'true',
      dontShowIntroAgain: dontShowIntroStr == 'true',
      premiumNotifyMe: notifyMeStr == 'true',
    );
  }

  Future<void> setTheme(AppThemeMode mode) async {
    final repo = ref.read(settingsRepositoryProvider);
    await repo.set('theme_mode', mode.name);
    final current = state.valueOrNull ?? const AppSettings();
    state = AsyncData(current.copyWith(
      appThemeMode: mode,
      themeMode: mode == AppThemeMode.light
          ? ThemeMode.light
          : mode == AppThemeMode.system
              ? ThemeMode.system
              : ThemeMode.dark,
    ),);
  }

  Future<void> setChargeLimit(int pct) async {
    await ref.read(settingsRepositoryProvider).set('charge_limit', pct.toString());
    final current = state.valueOrNull ?? const AppSettings();
    state = AsyncData(current.copyWith(chargeLimitPct: pct));
  }

  Future<void> setChargeLimitEnabled(bool enabled) async {
    await ref.read(settingsRepositoryProvider).set('charge_limit_enabled', enabled.toString());
    final current = state.valueOrNull ?? const AppSettings();
    state = AsyncData(current.copyWith(chargeLimitEnabled: enabled));
  }

  Future<void> setLowBatteryEnabled(bool enabled) async {
    await ref.read(settingsRepositoryProvider).set('low_battery_enabled', enabled.toString());
    final current = state.valueOrNull ?? const AppSettings();
    state = AsyncData(current.copyWith(lowBatteryEnabled: enabled));
  }

  Future<void> setLowBatteryPct(int pct) async {
    await ref.read(settingsRepositoryProvider).set('low_battery_pct', pct.toString());
    final current = state.valueOrNull ?? const AppSettings();
    state = AsyncData(current.copyWith(lowBatteryPct: pct));
  }

  Future<void> setOverheatThreshold(double c) async {
    await ref.read(settingsRepositoryProvider).set('overheat_threshold', c.toString());
    final current = state.valueOrNull ?? const AppSettings();
    state = AsyncData(current.copyWith(overheatThresholdC: c));
  }

  Future<void> setDesignCapacity(int mah) async {
    await ref.read(settingsRepositoryProvider).set('design_capacity_mah', mah.toString());
    final current = state.valueOrNull ?? const AppSettings();
    state = AsyncData(current.copyWith(designCapacityMah: mah));
  }

  Future<void> setOnboardingComplete() async {
    await ref.read(settingsRepositoryProvider).set('onboarding_complete', 'true');
    final current = state.valueOrNull ?? const AppSettings();
    state = AsyncData(current.copyWith(onboardingComplete: true));
  }

  Future<void> setGuardMode(bool enabled) async {
    await ref.read(settingsRepositoryProvider).set('guard_mode', enabled.toString());
    final current = state.valueOrNull ?? const AppSettings();
    state = AsyncData(current.copyWith(guardModeEnabled: enabled));
  }

  Future<void> setPro(bool isPro) async {
    await ref.read(settingsRepositoryProvider).set('is_pro', isPro.toString());
    final current = state.valueOrNull ?? const AppSettings();
    state = AsyncData(current.copyWith(isPro: isPro));
  }

  Future<void> setDontShowIntroAgain(bool val) async {
    await ref.read(settingsRepositoryProvider).set('dont_show_intro_again', val.toString());
    final current = state.valueOrNull ?? const AppSettings();
    state = AsyncData(current.copyWith(dontShowIntroAgain: val));
  }

  Future<void> setPremiumNotifyMe(bool val) async {
    await ref.read(settingsRepositoryProvider).set('premium_notify_me', val.toString());
    final current = state.valueOrNull ?? const AppSettings();
    state = AsyncData(current.copyWith(premiumNotifyMe: val));
  }
}

// Convenience alias: watch settingsProvider to get AsyncValue<AppSettings>
// ref.watch(settingsProvider)  →  AsyncValue<AppSettings>
