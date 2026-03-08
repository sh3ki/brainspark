import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool lightText;

  const AppLogo({
    super.key,
    this.size = 48,
    this.showText = true,
    this.lightText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: AppTheme.heroGradient,
            borderRadius: BorderRadius.circular(size * 0.28),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withOpacity(0.4),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.psychology_rounded,
                color: Colors.white,
                size: size * 0.62,
              ),
              Positioned(
                bottom: size * 0.08,
                right: size * 0.08,
                child: Container(
                  width: size * 0.28,
                  height: size * 0.28,
                  decoration: BoxDecoration(
                    color: AppTheme.accent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Icon(
                    Icons.bolt_rounded,
                    color: Colors.white,
                    size: size * 0.18,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showText) ...[
          SizedBox(width: size * 0.2),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Brain',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: size * 0.46,
                    fontWeight: FontWeight.w900,
                    color: lightText ? Colors.white : AppTheme.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                TextSpan(
                  text: 'Spark',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: size * 0.46,
                    fontWeight: FontWeight.w500,
                    color: lightText ? Colors.white70 : AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
