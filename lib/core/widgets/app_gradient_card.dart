import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppGradientCard extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final VoidCallback? onTap;

  const AppGradientCard({
    super.key,
    required this.child,
    this.colors,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = colors ?? _defaultColors;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [_shadow(gradient.first)],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: child,
        ),
      ),
    );
  }

  List<Color> get _defaultColors => const [
        AppColors.primary,
        AppColors.secondary,
      ];

  BoxShadow _shadow(Color color) => BoxShadow(
        color: color.withValues(alpha: 0.25),
        blurRadius: 20,
        offset: const Offset(0, 8),
      );
}
