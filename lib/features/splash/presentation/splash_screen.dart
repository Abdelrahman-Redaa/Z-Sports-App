import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:z_sports_booking/core/constants/app_strings.dart';
import 'package:z_sports_booking/core/router/app_router.dart';
import 'package:z_sports_booking/core/theme/app_colors.dart';
import 'package:z_sports_booking/core/widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _progressController;
  late final AnimationController _logoIntroController;
  late final AnimationController _logoPulseController;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoPulse;
  late final Animation<Offset> _logoSlide;
  late final Animation<double> _logoTurn;
  late final Animation<double> _logoGlow;

  @override
  void initState() {
    super.initState();
    _logoIntroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();

    _logoOpacity = CurvedAnimation(
      parent: _logoIntroController,
      curve: Curves.easeOutCubic,
    );
    _logoScale = Tween<double>(begin: 0.78, end: 1).animate(
      CurvedAnimation(parent: _logoIntroController, curve: Curves.elasticOut),
    );
    _logoSlide = Tween<Offset>(begin: const Offset(0, 0.24), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _logoIntroController,
            curve: Curves.easeOutBack,
          ),
        );
    _logoTurn = Tween<double>(begin: -0.035, end: 0).animate(
      CurvedAnimation(parent: _logoIntroController, curve: Curves.easeOutBack),
    );
    _logoPulse = Tween<double>(begin: 0.96, end: 1.08).animate(
      CurvedAnimation(parent: _logoPulseController, curve: Curves.easeInOut),
    );
    _logoGlow = Tween<double>(begin: 0.18, end: 0.56).animate(
      CurvedAnimation(parent: _logoPulseController, curve: Curves.easeInOut),
    );

    _logoIntroController.forward();
    _logoPulseController.repeat(reverse: true);

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        _navigateAfterSplash();
      }
    });
  }

  Future<void> _navigateAfterSplash() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (!mounted) return;

    if (token != null && token.trim().isNotEmpty) {
      context.go(AppRoutes.home);
    } else {
      context.go(AppRoutes.welcome);
    }
  }

  @override
  void dispose() {
    _logoIntroController.dispose();
    _logoPulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Spacer(flex: 3),
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _logoIntroController,
                    _logoPulseController,
                  ]),
                  builder: (context, child) {
                    return Opacity(
                      opacity: _logoOpacity.value,
                      child: SlideTransition(
                        position: _logoSlide,
                        child: Transform.rotate(
                          angle: _logoTurn.value,
                          child: Transform.scale(
                            scale: _logoScale.value * _logoPulse.value,
                            child: Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                      alpha: _logoGlow.value,
                                    ),
                                    blurRadius: 60,
                                    spreadRadius: 10,
                                  ),
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                      alpha: _logoGlow.value * 0.45,
                                    ),
                                    blurRadius: 120,
                                    spreadRadius: 24,
                                  ),
                                ],
                              ),
                              child: child,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: const AppLogo(height: 160),
                ),
                const Spacer(flex: 2),
                Text(
                  AppStrings.splashSlogan,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                    height: 1.6,
                  ),
                ),
                const Spacer(),
                AnimatedBuilder(
                  animation: _progressController,
                  builder: (_, _) {
                    final percent = (_progressController.value * 100).round();
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$percent%',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              '${AppStrings.loading}...',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _progressController.value,
                            minHeight: 3,
                            backgroundColor: AppColors.textPrimary.withValues(
                              alpha: 0.15,
                            ),
                            valueColor: const AlwaysStoppedAnimation(
                              AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
