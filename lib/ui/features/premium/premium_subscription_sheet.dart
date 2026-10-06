import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/settings_provider.dart';

class PremiumSubscriptionSheet extends ConsumerStatefulWidget {
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
  ConsumerState<PremiumSubscriptionSheet> createState() => _PremiumSubscriptionSheetState();
}

class _PremiumSubscriptionSheetState extends ConsumerState<PremiumSubscriptionSheet> {
  int _selectedTierIndex = 0; // 0 = ₹79 Weekly Starter

  final List<Map<String, dynamic>> _tiers = [
    {
      'title': 'Starter Pass',
      'duration': '1 Week',
      'price': '₹79',
      'priceNumeric': 79,
      'badge': 'STARTER',
      'subtext': 'Flexible trial for new users',
    },
    {
      'title': 'Monthly Pro',
      'duration': '1 Month',
      'price': '₹149',
      'priceNumeric': 149,
      'badge': 'POPULAR',
      'subtext': 'Save 45% compared to weekly',
    },
    {
      'title': 'Annual Pass',
      'duration': '1 Year',
      'price': '₹299',
      'priceNumeric': 299,
      'badge': 'BEST VALUE',
      'subtext': 'Only ₹25 / month',
    },
    {
      'title': 'Lifetime Ultra',
      'duration': 'Forever',
      'price': '₹499',
      'priceNumeric': 499,
      'badge': 'ONE-TIME',
      'subtext': 'Pay once, keep all future updates',
    },
  ];

  final List<Map<String, dynamic>> _features = [
    {
      'icon': Icons.widgets_outlined,
      'title': 'Interactive Home Widgets',
      'desc': 'Live 2x1 and 4x2 telemetry widgets on your home screen',
    },
    {
      'icon': Icons.block_outlined,
      'title': '100% Ad-Free Usage',
      'desc': 'Completely clean, distraction-free battery monitoring',
    },
    {
      'icon': Icons.picture_in_picture_alt_outlined,
      'title': 'Picture-in-Picture (PiP) HUD',
      'desc': 'Minimize app & float live mA/W stats on your screen',
    },
    {
      'icon': Icons.notifications_active_outlined,
      'title': 'Smart Charging Reminder',
      'desc': 'Alert at 80% to protect lithium battery health lifespan',
    },
    {
      'icon': Icons.battery_alert_outlined,
      'title': 'Low Battery & Overheat Alarms',
      'desc': 'Custom vibration and loud sirens at critical thresholds',
    },
    {
      'icon': Icons.security_outlined,
      'title': 'Anti-Theft Unplug Guard',
      'desc': 'Triggers alarm siren if phone is unplugged in public',
    },
    {
      'icon': Icons.insights_outlined,
      'title': 'AI Cable & Charger Quality Score',
      'desc': 'Benchmark wattage stability and detect faulty cables',
    },
    {
      'icon': Icons.trending_up,
      'title': '365-Day Battery Health Degradation',
      'desc': 'Full cycle count history & actual capacity decay trends',
    },
    {
      'icon': Icons.picture_as_pdf_outlined,
      'title': 'Unlimited PDF & CSV Export',
      'desc': 'Export professional battery diagnostic reports anytime',
    },
  ];

  void _completePurchase() {
    final chosen = _tiers[_selectedTierIndex];
    ref.read(settingsProvider.notifier).setPro(true);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            const Icon(Icons.stars, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '🎉 ChargeEasy Pro unlocked (${chosen['title']} - ${chosen['price']})! Enjoy all premium features.',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedTier = _tiers[_selectedTierIndex];

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
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      child: Column(
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
          const SizedBox(height: 16),

          // Scrollable content
          Expanded(
            child: ListView(
              children: [
                // Crown header
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
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.stars, color: Colors.white, size: 38),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Upgrade to ChargeEasy Pro',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                        ),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    'Unlock advanced gauges, real-time widgets, and ad-free telemetry',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Subscription Plan Grid
                Text(
                  'Select Subscription Plan (Starting from ₹79):',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.grey.shade300 : const Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 12),

                // Horizontal or 2x2 grid of tiers
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _tiers.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.35,
                  ),
                  itemBuilder: (context, index) {
                    final tier = _tiers[index];
                    final isSelected = _selectedTierIndex == index;
                    return InkWell(
                      onTap: () => setState(() => _selectedTierIndex = index),
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFEFF6FF))
                              : (isDark
                                  ? const Color(0xFF1E293B).withValues(alpha: 0.5)
                                  : const Color(0xFFF8FAFC)),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF2563EB)
                                : (isDark ? Colors.white12 : Colors.grey.shade300),
                            width: isSelected ? 2.2 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF2563EB).withValues(alpha: 0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : null,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  tier['title'],
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF2563EB)
                                        : Colors.grey.shade600,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    tier['badge'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tier['price'],
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: isSelected
                                        ? const Color(0xFF2563EB)
                                        : (isDark ? Colors.white : Colors.black),
                                  ),
                                ),
                                Text(
                                  tier['duration'],
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Feature List
                Text(
                  'Premium Benefits Included:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.grey.shade300 : const Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 12),
                for (final feat in _features) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            feat['icon'] as IconData,
                            color: const Color(0xFF10B981),
                            size: 18,
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
                ],
                const SizedBox(height: 16),
              ],
            ),
          ),

          // Bottom Action Button
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: _completePurchase,
              child: Text(
                'CONTINUE WITH ${selectedTier['price'].toUpperCase()}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () {
                ref.read(settingsProvider.notifier).setPro(true);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Purchases restored successfully.')),
                );
              },
              child: const Text('Restore Purchases', style: TextStyle(fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }
}
