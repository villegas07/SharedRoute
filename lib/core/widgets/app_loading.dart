import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppFullScreenLoading extends StatelessWidget {
  const AppFullScreenLoading({super.key});

  @override
  Widget build(BuildContext context) => const ColoredBox(
        color: Colors.black26,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
}

class AppInlineLoading extends StatelessWidget {
  const AppInlineLoading({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox(
        height: 48,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2.5,
          ),
        ),
      );
}
