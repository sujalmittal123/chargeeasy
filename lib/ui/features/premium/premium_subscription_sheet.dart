import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/settings_provider.dart';

class PremiumSubscriptionSheet extends ConsumerWidget {
  const PremiumSubscriptionSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PremiumSubscriptionSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settingsAsync = ref.watch(settingsProvider);
    final settings = settingsAsync.valueOrNull ?? const AppSettings();
    final isNotified = settings.premiumNotifyMe;

    final plannedFeatures = [
      {
        'icon': Icons.health_and_safety_outlined,
        'title': 'Advanced Battery Health Diagnostics',
        'desc': 'Deep degradation curves, estimated capacity calibration, and cycle tracking.',
      },
      {
        'icon': Icons.notifications_active_outlined,
        'title': 'Custom Charge Alarms & Sounds',
        'desc': 'Custom audio alarms for optimal 80% charge limits, overheating, and low battery.',
      },
      {
        'icon': Icons.picture_as_pdf_outlined,
        'title': 'Export Reports to PDF & CSV',
        'desc': 'Export detailed session logs and battery telemetry reports anytime.',
      },
      {
        'icon': Icons.block_outlined,
        'title': 'Ad-Free Experience',
        'desc': 'Completely clean, offline, distraction-free battery monitoring.',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Crown Header
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const RadialGradient(
                  colors: [Color(0xFFFBBF24), Color(0xFFD97706)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(Icons.stars, color: Colors.white, size: 36),
            ),
          ),
          const SizedBox(height: 14),

          Text(
            'Premium — Coming Soon',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'We are developing powerful pro tools for battery power users.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),

          // Planned Features
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Planned Premium Features:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.grey.shade300 : const Color(0xFF334155),
              ),
            ),
          ),
          const SizedBox(height: 12),

          for (final feat in plannedFeatures)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00E5FF).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      feat['icon'] as IconData,
                      color: const Color(0xFF00E5FF),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          feat['title'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          feat['desc'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 24),

          // Notify me action button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              icon: Icon(isNotified ? Icons.check_circle : Icons.notifications_active_outlined),
              style: FilledButton.styleFrom(
                backgroundColor: isNotified ? const Color(0xFF10B981) : const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                final newState = !isNotified;
                ref.read(settingsProvider.notifier).setPremiumNotifyMe(newState);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      newState
                          ? "You will be notified when Premium launches!"
                          : "Notification preference removed.",
                    ),
                  ),
                );
              },
              label: Text(
                isNotified ? 'You will be notified when available' : 'Notify me when available',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
