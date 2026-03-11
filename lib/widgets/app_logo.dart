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
            color: lightText
                ? Colors.white.withOpacity(0.12)
                : AppTheme.primary,
            borderRadius: BorderRadius.circular(size * 0.24),
          ),
          child: Center(
            child: Icon(
              Icons.bolt_rounded,
              color: AppTheme.accent,
              size: size * 0.55,
            ),
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
                    fontSize: size * 0.42,
                    fontWeight: FontWeight.w900,
                    color: lightText ? Colors.white : AppTheme.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                TextSpan(
                  text: 'Spark',
                  style: TextStyle(
                    fontSize: size * 0.42,
                    fontWeight: FontWeight.w500,
                    color: lightText ? Colors.white70 : AppTheme.accent,
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
