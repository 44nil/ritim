import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.borderRadius,
    this.blur = 24,
    this.opacity = 0.6,
    this.borderOpacity = 0.4,
    this.tintColor,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final double? borderRadius;
  final double blur;
  final double opacity;
  final double borderOpacity;
  final Color? tintColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final radius = borderRadius ?? AppConstants.radiusXL;

    // Light: beyaz + hafif pembe tint — buzlu cam hissi
    // Dark: koyu yarı-şeffaf
    final tint = tintColor ??
        (isDark
            ? const Color(0xFF2A2030).withValues(alpha: 0.65)
            : const Color(0xFFFFF5F8).withValues(alpha: opacity));

    final content = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding ?? const EdgeInsets.all(AppConstants.paddingM),
          decoration: BoxDecoration(
            color: tint,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: borderOpacity),
              width: isDark ? 0.5 : 1.2,
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: const Color(0xFFD4A0B0).withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: child,
        ),
      ),
    );

    if (onTap == null) return content;

    return GestureDetector(onTap: onTap, child: content);
  }
}
