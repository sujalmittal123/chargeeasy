import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/settings_provider.dart';

/// Flag to control whether the intro walkthrough is shown on launches.
/// Can be overridden by the user checking "Don't show again".
// ignore: constant_identifier_names
const bool SHOW_INTRO_EVERY_LAUNCH = true;

class OnboardingScreen extends ConsumerStatefulWidget {
  final bool forced;

  const OnboardingScreen({super.key, this.forced = false});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _dontShowAgain = false;
  bool _redirectChecked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkRedirect();
    });
  }

  void _checkRedirect() {
    if (_redirectChecked) return;
    _redirectChecked = true;

    final settings = ref.read(settingsProvider).valueOrNull ?? const AppSettings();
    // If "Don't show again" is saved in settings, or if SHOW_INTRO_EVERY_LAUNCH is false (and not forced)
    if (!widget.forced && (settings.dontShowIntroAgain || !SHOW_INTRO_EVERY_LAUNCH)) {
      if (mounted) {
        context.go('/dashboard');
      }
    }
  }

  void _finishOnboarding() {
    if (_dontShowAgain) {
      ref.read(settingsProvider.notifier).setDontShowIntroAgain(true);
    }
    context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: _finishOnboarding,
            child: const Text('Skip', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  // Screen 1: Welcome & Real-time battery telemetry
                  _buildPage(
                    imageAsset: 'assets/images/logo.png',
                    title: 'Charge Tracker',
                    subtitle: 'Live mA current, voltage, temperature, and true wattage direct from device sensors with 1-second accuracy.',
                    color: const Color(0xFF00E5FF),
                  ),

                  // Screen 2: Protect battery lifespan (80% charge limit)
                  _buildPage(
                    icon: Icons.shield_outlined,
                    title: 'Protect Battery Lifespan',
                    subtitle: 'Smart notifications and alarms at 80% to protect lithium chemistry and double your phone\'s cycle lifespan.',
                    color: const Color(0xFF10B981),
                  ),

                  // Screen 3: Track charging history & health
                  _buildPage(
                    icon: Icons.favorite_outline,
                    title: 'Track History & Health',
                    subtitle: 'Automatic background session logging with accurate capacity diagnostics and zero fake telemetry.',
                    color: const Color(0xFFF59E0B),
                  ),
                ],
              ),
            ),

            // "Don't show again" Checkbox
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _dontShowAgain,
                    activeColor: const Color(0xFF00E5FF),
                    onChanged: (val) {
                      setState(() {
                        _dontShowAgain = val ?? false;
                      });
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _dontShowAgain = !_dontShowAgain;
                      });
                    },
                    child: Text(
                      "Don't show again",
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.grey.shade300 : const Color(0xFF334155),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Page Indicator & Next / Get Started Button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      3,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {
                      if (_currentPage == 2) {
                        _finishOnboarding();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Text(_currentPage == 2 ? 'Get Started' : 'Next'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    IconData? icon,
    String? imageAsset,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imageAsset != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Image.asset(
                imageAsset,
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 84, color: color),
            ),
          const SizedBox(height: 36),
          Text(
            title,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 15, color: Colors.grey, height: 1.4),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
