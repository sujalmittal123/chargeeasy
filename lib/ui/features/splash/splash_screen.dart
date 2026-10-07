import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/settings_provider.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _pulseController;
  late final AnimationController _shimmerController;

  late final Animation<double> _logoScale;
  late final Animation<double> _contentFade;
  late final Animation<double> _trackingAnimation;
  late final Animation<double> _progressAnimation;

  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    // 1. Master boot entrance controller (2200ms)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    // 2. Continuous breathing energy pulse (2600ms)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();

    // 3. Diagonal specular light sweep across logo (1800ms)
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    // Staggered curves
    _logoScale = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
    );

    _contentFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.2, 0.65, curve: Curves.easeIn),
    );

    _trackingAnimation = Tween<double>(begin: 1.5, end: 4.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.25, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    _progressAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.15, 0.95, curve: Curves.easeInOutCubic),
    );

    _entranceController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToNextScreen();
      }
    });

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _navigateToNextScreen() {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;

    final settings = ref.read(settingsProvider).valueOrNull ?? const AppSettings();
    final skipIntro = settings.dontShowIntroAgain || !SHOW_INTRO_EVERY_LAUNCH;

    if (skipIntro) {
      context.go('/dashboard');
    } else {
      context.go('/onboarding');
    }
  }

  String _getBootStatusText(double progress) {
    if (progress < 0.28) {
      return 'INITIALIZING CURRENT SENSORS...';
    } else if (progress < 0.60) {
      return 'CONNECTING BATTERY KERNEL...';
    } else if (progress < 0.88) {
      return 'CALIBRATING COULOMB ENGINE...';
    } else {
      return 'HARDWARE TELEMETRY READY';
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryCyan = Color(0xFF00E5FF);
    const primaryEmerald = Color(0xFF00E676);

    return Scaffold(
      backgroundColor: const Color(0xFF050811),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _navigateToNextScreen,
        child: Stack(
          children: [
            // Ambient Radial Energy Backdrops
            Positioned(
              top: -80,
              left: -40,
              right: -40,
              height: 380,
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 0.85,
                      colors: [
                        primaryCyan.withValues(alpha: 0.16),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -60,
              left: 0,
              right: 0,
              height: 320,
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.bottomCenter,
                      radius: 0.9,
                      colors: [
                        primaryEmerald.withValues(alpha: 0.12),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Top Telemetry Header Badges
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTechCornerLabel('CHARGE_TRACKER // CORE'),
                    _buildTechCornerLabel('SECURE OFFLINE'),
                  ],
                ),
              ),
            ),

            // Main Content Area
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 3),

                    // Central Hero Logo with Radiant Energy Aura & Metallic Light Sweep
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 1. Concentric Animated Energy Radar Rings
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return CustomPaint(
                                size: const Size(260, 260),
                                painter: _EnergyRingsPainter(
                                  pulseValue: _pulseController.value,
                                  primaryColor: primaryCyan,
                                  secondaryColor: primaryEmerald,
                                ),
                              );
                            },
                          ),

                          // 2. Breathing Neon Halo Under-Glow
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              final glowScale = 1.0 + (math.sin(_pulseController.value * 2 * math.pi) * 0.06);
                              final glowAlpha = 0.28 + (math.sin(_pulseController.value * 2 * math.pi) * 0.10);

                              return Transform.scale(
                                scale: glowScale,
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryCyan.withValues(alpha: glowAlpha),
                                        blurRadius: 55,
                                        spreadRadius: 8,
                                      ),
                                      BoxShadow(
                                        color: primaryEmerald.withValues(alpha: glowAlpha * 0.6),
                                        blurRadius: 75,
                                        spreadRadius: 14,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          // 3. Logo Container with Entry Scale & Shimmer Glint Sweep
                          ScaleTransition(
                            scale: _logoScale,
                            child: Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(34),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF131D2E),
                                    Color(0xFF090E17),
                                  ],
                                ),
                                border: Border.all(
                                  color: primaryCyan.withValues(alpha: 0.45),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryCyan.withValues(alpha: 0.3),
                                    blurRadius: 28,
                                    offset: const Offset(0, 8),
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.7),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(32),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Base High-Res Logo Image
                                    Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Image.asset(
                                        'assets/images/logo.png',
                                        width: 104,
                                        height: 104,
                                        fit: BoxFit.contain,
                                      ),
                                    ),

                                    // Diagonal Specular Shimmer Sweep
                                    AnimatedBuilder(
                                      animation: _shimmerController,
                                      builder: (context, child) {
                                        final shimmerVal = _shimmerController.value;
                                        return ShaderMask(
                                          shaderCallback: (bounds) {
                                            return LinearGradient(
                                              begin: Alignment(-2.5 + (shimmerVal * 5.0), -1.2),
                                              end: Alignment(-1.5 + (shimmerVal * 5.0), 1.2),
                                              colors: [
                                                Colors.transparent,
                                                Colors.white.withValues(alpha: 0.15),
                                                primaryCyan.withValues(alpha: 0.75),
                                                Colors.white.withValues(alpha: 0.9),
                                                Colors.transparent,
                                              ],
                                              stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
                                            ).createShader(bounds);
                                          },
                                          blendMode: BlendMode.srcATop,
                                          child: Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: Image.asset(
                                              'assets/images/logo.png',
                                              width: 104,
                                              height: 104,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 36),

                    // App Title & Kinetic Typography Reveal
                    FadeTransition(
                      opacity: _contentFade,
                      child: Column(
                        children: [
                          AnimatedBuilder(
                            animation: _trackingAnimation,
                            builder: (context, child) {
                              return ShaderMask(
                                shaderCallback: (bounds) {
                                  return const LinearGradient(
                                    colors: [
                                      Color(0xFFE2F1FF),
                                      primaryCyan,
                                      Color(0xFFFFFFFF),
                                    ],
                                  ).createShader(bounds);
                                },
                                child: Text(
                                  'CHARGE TRACKER',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: _trackingAnimation.value,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 10),

                          // Futuristic Tech Pill Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A).withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: primaryCyan.withValues(alpha: 0.28),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryCyan.withValues(alpha: 0.1),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.bolt_rounded,
                                  color: primaryEmerald,
                                  size: 16,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  '100% OFFLINE TELEMETRY ENGINE',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(flex: 3),

                    // Cinematic HUD Battery Telemetry Progress Bar
                    FadeTransition(
                      opacity: _contentFade,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            final progress = _progressAnimation.value.clamp(0.0, 1.0);
                            final percentInt = (progress * 100).toInt();
                            final statusText = _getBootStatusText(progress);

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Status & Numeric Percentage Readout
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: percentInt == 100 ? primaryEmerald : primaryCyan,
                                            boxShadow: [
                                              BoxShadow(
                                                color: (percentInt == 100 ? primaryEmerald : primaryCyan)
                                                    .withValues(alpha: 0.8),
                                                blurRadius: 6,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          statusText,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.8,
                                            color: Color(0xFF94A3B8),
                                            fontFamily: 'monospace',
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '$percentInt%',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'monospace',
                                        color: percentInt == 100 ? primaryEmerald : primaryCyan,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                // Glowing Cyber Capsule Progress Track
                                Container(
                                  height: 6,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0F172A),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: primaryCyan.withValues(alpha: 0.2),
                                      width: 0.8,
                                    ),
                                  ),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      final fillWidth = constraints.maxWidth * progress;
                                      return Stack(
                                        children: [
                                          Container(
                                            width: fillWidth,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(4),
                                              gradient: const LinearGradient(
                                                colors: [
                                                  primaryCyan,
                                                  primaryEmerald,
                                                ],
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: primaryCyan.withValues(alpha: 0.6),
                                                  blurRadius: 8,
                                                  spreadRadius: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (progress > 0.05 && progress < 0.99)
                                            Positioned(
                                              left: (fillWidth - 8).clamp(0.0, constraints.maxWidth),
                                              top: 0,
                                              bottom: 0,
                                              child: Container(
                                                width: 8,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(4),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.white,
                                                      blurRadius: 6,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),

                    const Spacer(flex: 1),

                    // Tap to Skip Prompt
                    FadeTransition(
                      opacity: _contentFade,
                      child: const Text(
                        'Tap anywhere to skip',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF475569),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechCornerLabel(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: const Color(0xFF1E293B),
          width: 0.8,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
          color: Color(0xFF64748B),
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

/// Custom painter rendering expanding concentric radar telemetry energy rings
class _EnergyRingsPainter extends CustomPainter {
  final double pulseValue;
  final Color primaryColor;
  final Color secondaryColor;

  _EnergyRingsPainter({
    required this.pulseValue,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) * 0.48;

    for (int i = 0; i < 3; i++) {
      final ringProgress = (pulseValue + (i / 3.0)) % 1.0;
      final radius = 68.0 + (maxRadius - 68.0) * ringProgress;
      final opacity = (1.0 - ringProgress).clamp(0.0, 1.0) * 0.32;

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = Color.lerp(primaryColor, secondaryColor, ringProgress)!
            .withValues(alpha: opacity);

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _EnergyRingsPainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue;
  }
}
