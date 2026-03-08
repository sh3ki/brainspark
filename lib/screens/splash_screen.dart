import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import 'main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoCtrl;
  late AnimationController _textCtrl;
  late AnimationController _pulseCtrl;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _textOpacity;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    _logoCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _textCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat(reverse: true);

    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut));
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _logoCtrl, curve: const Interval(0.0, 0.4)));
    _textSlide =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
            .animate(CurvedAnimation(
                parent: _textCtrl, curve: Curves.easeOutCubic));
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeIn));
    _pulse = Tween<double>(begin: 0.95, end: 1.05).animate(
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _runSequence();
  }

  Future<void> _runSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    _textCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 1800));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const MainNavigation(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.heroGradient),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              ScaleTransition(
                scale: _logoScale,
                child: FadeTransition(
                  opacity: _logoOpacity,
                  child: ScaleTransition(
                    scale: _pulse,
                    child: const AppLogo(size: 80, lightText: true),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SlideTransition(
                position: _textSlide,
                child: FadeTransition(
                  opacity: _textOpacity,
                  child: Column(
                    children: [
                      const Text(
                        'Learn Smarter. Not Harder.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Flashcards • Quizzes • Progress Tracking',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 2),
              FadeTransition(
                opacity: _textOpacity,
                child: Column(
                  children: [
                    _buildFeatureRow(Icons.style_rounded, '6 Decks Ready'),
                    const SizedBox(height: 10),
                    _buildFeatureRow(Icons.quiz_rounded, 'Quiz Mode'),
                    const SizedBox(height: 10),
                    _buildFeatureRow(Icons.insights_rounded, 'Progress Charts'),
                  ],
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 8),
        Text(label,
            style:
                const TextStyle(color: Colors.white70, fontSize: 13)),
      ],
    );
  }
}
