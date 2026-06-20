import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class BentoCard extends StatelessWidget {
  const BentoCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.color,
    this.gradient,
    this.border,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final Color? color;
  final Gradient? gradient;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveColor = color ??
        (isDark
            ? theme.colorScheme.surface
            : theme.colorScheme.surface);

    final decoration = BoxDecoration(
      color: gradient == null ? effectiveColor : null,
      gradient: gradient,
      borderRadius: BorderRadius.circular(AppConstants.radiusXL),
      border: border ??
          Border.all(
            color: theme.colorScheme.outline.withValues(alpha: isDark ? 0.12 : 0.08),
          ),
    );

    final content = Container(
      padding: padding ?? const EdgeInsets.all(AppConstants.paddingM),
      decoration: decoration,
      child: child,
    );

    if (onTap == null) return content;

    return GestureDetector(
      onTap: onTap,
      child: content,
    );
  }
}
