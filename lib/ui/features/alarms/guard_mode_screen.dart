import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/settings_provider.dart';
import '../../../data/services/battery_service.dart';

class GuardModeScreen extends ConsumerStatefulWidget {
  const GuardModeScreen({super.key});

  @override
  ConsumerState<GuardModeScreen> createState() => _GuardModeScreenState();
}

class _GuardModeScreenState extends ConsumerState<GuardModeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
    final settings = ref.read(settingsProvider).valueOrNull ?? const AppSettings();
    isActive = settings.guardModeEnabled;
    if (isActive) {
      _pulseController.repeat(reverse: true);
    }
  }

  void _toggleGuard() async {
    final nextState = !isActive;
    setState(() {
      isActive = nextState;
      if (isActive) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    });
    await BatteryService().setGuardMode(nextState);
    await ref.read(settingsProvider.notifier).setGuardMode(nextState);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            nextState
                ? '🛡️ Guard Mode armed: Unplugging the charger will trigger a loud alarm!'
                : '🛡️ Guard Mode disarmed.',
          ),
          backgroundColor: nextState ? Colors.redAccent : Colors.grey.shade800,
        ),
      );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Anti-Theft Guard Mode')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? Colors.red.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.1),
                    border: Border.all(
                      color: isActive ? Colors.redAccent : Colors.grey.shade600,
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    Icons.shield,
                    size: 110,
                    color: isActive ? Colors.redAccent : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                isActive ? 'Guard Mode ARMED' : 'Guard Mode Disarmed',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.redAccent : null,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                isActive
                    ? 'Loud siren alarm will trigger immediately if anyone unplugs your charger or cuts power.'
                    : 'Arm Guard Mode when charging in cafes, libraries, airports or public stations.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: Icon(isActive ? Icons.lock_open : Icons.lock),
                  label: Text(isActive ? 'Disarm Guard Mode' : 'Arm Guard Mode Now'),
                  style: FilledButton.styleFrom(
                    backgroundColor: isActive ? Colors.redAccent : const Color(0xFF00E5FF),
                    foregroundColor: isActive ? Colors.white : Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _toggleGuard,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
