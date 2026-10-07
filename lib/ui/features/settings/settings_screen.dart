import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../providers/settings_provider.dart';
import '../../../providers/session_provider.dart';
import '../../../data/services/battery_service.dart';
import '../../../domain/use_cases/export_sessions.dart';
import '../../core/app_theme.dart';
import '../premium/premium_subscription_sheet.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final settings = settingsAsync.valueOrNull ?? const AppSettings();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          // 1. GET PREMIUM Banner (Matching Image 2)
          InkWell(
            onTap: () => PremiumSubscriptionSheet.show(context),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.stars, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          settings.isPro ? 'PRO ACTIVATED' : 'PREMIUM — COMING SOON',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          settings.isPro
                              ? 'All features & ad-free experience unlocked'
                              : 'View planned features & notify me',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey.shade400 : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          ),

          // 2. Profile Item (Matching Image 2)
          _buildActionCard(
            context,
            icon: Icons.account_circle,
            iconColor: const Color(0xFF3B82F6),
            title: 'Device Profile',
            subtitle: '100% offline device profile · All data stored on-device',
            onTap: () => context.push('/profile'),
          ),

          // 3. App Protection (Matching Image 2)
          _buildActionCard(
            context,
            icon: Icons.shield_outlined,
            iconColor: const Color(0xFF10B981),
            title: 'App protection',
            subtitle: 'Reduce disconnections to ensure proper working of charging and low battery reminders',
            onTap: () => BatteryService().requestIgnoreBatteryOptimizations(),
          ),

          // 4. Charging Reminder with Dual-Color Bar (Matching Image 2)
          _buildReminderCard(
            context,
            ref,
            icon: Icons.battery_charging_full,
            iconColor: const Color(0xFF10B981),
            title: 'Charging reminder',
            subtitle: 'You will receive a reminder to turn off the charger when your battery level reaches ${settings.chargeLimitPct}%',
            enabled: settings.chargeLimitEnabled,
            thresholdPct: settings.chargeLimitPct,
            fillColor: const Color(0xFF10B981),
            emptyColor: const Color(0xFFA7F3D0),
            onToggle: (val) {
              ref.read(settingsProvider.notifier).setChargeLimitEnabled(val);
              BatteryService().setAlarmThresholds({
                'charge_limit': settings.chargeLimitPct,
                'charge_limit_enabled': val,
                'max_temp': settings.overheatThresholdC,
                'low_battery_threshold': settings.lowBatteryPct,
                'low_battery_enabled': settings.lowBatteryEnabled,
              });
            },
            onSliderChanged: (val) {
              ref.read(settingsProvider.notifier).setChargeLimit(val.toInt());
              BatteryService().setAlarmThresholds({
                'charge_limit': val.toInt(),
                'charge_limit_enabled': settings.chargeLimitEnabled,
                'max_temp': settings.overheatThresholdC,
                'low_battery_threshold': settings.lowBatteryPct,
                'low_battery_enabled': settings.lowBatteryEnabled,
              });
            },
            min: 60,
            max: 100,
          ),

          // 5. Low Battery Reminder with Dual-Color Red Bar (Matching Image 2)
          _buildReminderCard(
            context,
            ref,
            icon: Icons.battery_alert,
            iconColor: const Color(0xFFEF4444),
            title: 'Low battery reminder',
            subtitle: 'You will receive a reminder to plug in the charger when your battery level reaches ${settings.lowBatteryPct}%',
            enabled: settings.lowBatteryEnabled,
            thresholdPct: settings.lowBatteryPct,
            fillColor: const Color(0xFFEF4444),
            emptyColor: const Color(0xFFFECACA),
            onToggle: (val) {
              ref.read(settingsProvider.notifier).setLowBatteryEnabled(val);
              BatteryService().setAlarmThresholds({
                'charge_limit': settings.chargeLimitPct,
                'charge_limit_enabled': settings.chargeLimitEnabled,
                'max_temp': settings.overheatThresholdC,
                'low_battery_threshold': settings.lowBatteryPct,
                'low_battery_enabled': val,
              });
            },
            onSliderChanged: (val) {
              ref.read(settingsProvider.notifier).setLowBatteryPct(val.toInt());
              BatteryService().setAlarmThresholds({
                'charge_limit': settings.chargeLimitPct,
                'charge_limit_enabled': settings.chargeLimitEnabled,
                'max_temp': settings.overheatThresholdC,
                'low_battery_threshold': val.toInt(),
                'low_battery_enabled': settings.lowBatteryEnabled,
              });
            },
            min: 5,
            max: 30,
          ),

          // 6. Enable Dark Mode / Theme Mode (Matching Image 2)
          _buildActionCard(
            context,
            icon: Icons.dark_mode_outlined,
            iconColor: const Color(0xFF6366F1),
            title: 'Enable dark mode',
            subtitle: switch (settings.appThemeMode) {
              AppThemeMode.amoled => 'AMOLED Black',
              AppThemeMode.dark => 'Dark Theme',
              AppThemeMode.light => 'Light Theme',
              AppThemeMode.system => 'Follow System',
            },
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => SimpleDialog(
                  title: const Text('Select Theme'),
                  children: [
                    for (final mode in [
                      (AppThemeMode.amoled, 'AMOLED Black (Pure #000000)', Icons.brightness_1),
                      (AppThemeMode.dark, 'Dark Mode', Icons.dark_mode),
                      (AppThemeMode.light, 'Light Mode', Icons.light_mode),
                      (AppThemeMode.system, 'Follow System', Icons.phone_android),
                    ])
                      ListTile(
                        leading: Icon(mode.$3),
                        title: Text(mode.$2),
                        trailing: settings.appThemeMode == mode.$1
                            ? const Icon(Icons.check, color: Color(0xFF00E5FF))
                            : null,
                        onTap: () {
                          ref.read(settingsProvider.notifier).setTheme(mode.$1);
                          Navigator.pop(ctx);
                        },
                      ),
                  ],
                ),
              );
            },
          ),

          // 7. Choose Language (Matching Image 2)
          _buildActionCard(
            context,
            icon: Icons.translate,
            iconColor: const Color(0xFF06B6D4),
            title: 'Choose language',
            subtitle: 'System default (English)',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Language set to System default (English).')),
              );
            },
          ),

          const SizedBox(height: 12),
          _buildSectionHeader('Hardware & Advanced Alarms', context),

          ListTile(
            leading: const Icon(Icons.thermostat_outlined),
            title: const Text('Overheat Protection Guard'),
            subtitle: Text('Threshold: ${settings.overheatThresholdC}°C (Auto siren)'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/alarms'),
          ),

          ListTile(
            leading: const Icon(Icons.straighten_outlined),
            title: const Text('Calibrate Current Sign & Capacity'),
            subtitle: const Text('Fix inverted ± sign & inspect design capacity'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/calibration'),
          ),

          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Brand-Specific Instructions'),
            subtitle: const Text('Xiaomi MIUI, Samsung OneUI, OnePlus OxygenOS, Oppo/Vivo'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showOemHelpDialog(context),
          ),

          const Divider(),
          _buildSectionHeader('Walkthrough & Onboarding', context),
          ListTile(
            leading: const Icon(Icons.slideshow_outlined),
            title: const Text('View Welcome Walkthrough'),
            subtitle: const Text('Replay the 3-screen introduction guide'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/onboarding'),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.visibility_off_outlined),
            title: const Text("Don't show intro on launch"),
            subtitle: const Text('Skip introduction walkthrough automatically'),
            value: settings.dontShowIntroAgain,
            onChanged: (val) {
              ref.read(settingsProvider.notifier).setDontShowIntroAgain(val);
            },
          ),

          const Divider(),
          _buildSectionHeader('Data & Privacy', context),
          ListTile(
            leading: const Icon(Icons.file_download_outlined),
            title: const Text('Export All Sessions (CSV / PDF)'),
            subtitle: const Text('Generate diagnostic telemetry reports'),
            onTap: () async {
              final sessions = await ref.read(sessionsProvider.future);
              if (sessions.isEmpty) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No sessions recorded yet to export.')),
                  );
                }
                return;
              }
              final path = await ExportSessionsUseCase().exportToCsv(sessions);
              await Share.shareXFiles([XFile(path)], text: 'Charge Tracker Battery Sessions CSV');
            },
          ),
          ListTile(
            leading: const Icon(Icons.verified_user_outlined),
            title: const Text('Privacy & Offline Policy'),
            subtitle: const Text('100% offline, zero internet permission, all analytics on-device'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationIcon: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 54,
                    height: 54,
                  ),
                ),
                applicationName: 'Charge Tracker',
                applicationVersion: '1.0.4 (Build 5)',
                applicationLegalese: '© 2026 Charge Tracker Team. Pure offline-first battery analytics.',
                children: [
                  const SizedBox(height: 12),
                  const Text('Charge Tracker does not request the INTERNET permission. No battery stats, usage stats, or charging metrics are ever transmitted outside your device.'),
                ],
              );
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  static Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  static Widget _buildReminderCard(
    BuildContext context,
    WidgetRef ref, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool enabled,
    required int thresholdPct,
    required Color fillColor,
    required Color emptyColor,
    required ValueChanged<bool> onToggle,
    required ValueChanged<double> onSliderChanged,
    required double min,
    required double max,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              Switch(
                value: enabled,
                activeThumbColor: fillColor,
                onChanged: onToggle,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey.shade400 : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 12),

          // Dual-Color Progress Bar with Threshold (Matching Image 2)
          Row(
            children: [
              Expanded(
                flex: thresholdPct,
                child: Container(
                  height: 14,
                  decoration: BoxDecoration(
                    color: fillColor,
                    borderRadius: BorderRadius.horizontal(
                      left: const Radius.circular(7),
                      right: thresholdPct >= 100 ? const Radius.circular(7) : Radius.zero,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Icon(icon, size: 14, color: iconColor),
              ),
              Expanded(
                flex: (100 - thresholdPct).clamp(1, 100),
                child: Container(
                  height: 14,
                  decoration: BoxDecoration(
                    color: emptyColor,
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(7),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Slider to adjust
          if (enabled)
            Row(
              children: [
                Text(
                  '${min.toInt()}%',
                  style: TextStyle(fontSize: 11, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                ),
                Expanded(
                  child: Slider(
                    value: thresholdPct.toDouble().clamp(min, max),
                    min: min,
                    max: max,
                    divisions: (max - min).toInt(),
                    activeColor: fillColor,
                    label: '$thresholdPct%',
                    onChanged: onSliderChanged,
                  ),
                ),
                Text(
                  '${max.toInt()}%',
                  style: TextStyle(fontSize: 11, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                ),
              ],
            ),
        ],
      ),
    );
  }

  static void _showOemHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('OEM Optimization Whitelist'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• Xiaomi / Poco / MIUI:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Security app → Manage Apps → Charge Tracker → Enable "Autostart" and set Battery Saver to "No restrictions".\n'),
              Text('• Samsung One UI:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Settings → Apps → Charge Tracker → Battery → Select "Unrestricted".\n'),
              Text('• OnePlus / Realme / Oppo:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Settings → Battery → More Battery Settings → App battery management → Allow background activity.\n'),
              Text('• Vivo / Funtouch OS:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Settings → Battery → High background power consumption → Enable Charge Tracker.'),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Done')),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, top: 12.0, bottom: 6.0),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
