import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _finishOnboarding(BuildContext context) {
    context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () => _finishOnboarding(context),
            child: const Text('Skip'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
              children: [
                _buildPage(
                  icon: Icons.battery_charging_full,
                  title: 'Welcome to ChargeEasy',
                  subtitle: 'The ultimate charging companion and battery analyzer.',
                  color: Colors.cyan,
                ),
                _buildPage(
                  icon: Icons.notifications_active,
                  title: 'Stay Informed',
                  subtitle: 'We need notification permissions to alert you when charge limits are reached.',
                  color: Colors.blue,
                ),
                _buildPage(
                  icon: Icons.settings_power,
                  title: 'Unrestricted Access',
                  subtitle: 'Please whitelist this app in your battery optimization settings for accurate background tracking.',
                  color: Colors.orange,
                ),
                _buildPage(
                  icon: Icons.design_services,
                  title: 'Design Capacity',
                  subtitle: 'Your battery design capacity is auto-detected. You can manually adjust it later in Settings.',
                  color: Colors.green,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(4, (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? Theme.of(context).colorScheme.primary : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),),
                ),
                FilledButton(
                  onPressed: () {
                    if (_currentPage == 3) {
                      _finishOnboarding(context);
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(_currentPage == 3 ? 'Get Started' : 'Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage({required IconData icon, required String title, required String subtitle, required Color color}) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 100, color: color),
          ),
          const SizedBox(height: 48),
          Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(subtitle, style: const TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
