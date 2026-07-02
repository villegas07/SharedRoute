import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

enum AppChipStatus {
  draft,
  published,
  inProgress,
  completed,
  cancelled,
  pending,
  confirmed,
  cancelledByPassenger,
  cancelledByDriver,
}

class AppStatusChip extends StatelessWidget {
  final AppChipStatus status;

  const AppStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _label,
        style: TextStyle(
          color: _textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String get _label => switch (status) {
        AppChipStatus.draft => 'Borrador',
        AppChipStatus.published => 'Publicado',
        AppChipStatus.inProgress => 'En curso',
        AppChipStatus.completed => 'Completado',
        AppChipStatus.cancelled => 'Cancelado',
        AppChipStatus.pending => 'Pendiente',
        AppChipStatus.confirmed => 'Confirmado',
        AppChipStatus.cancelledByPassenger => 'Cancelado',
        AppChipStatus.cancelledByDriver => 'Cancelado',
      };

  Color get _backgroundColor => switch (status) {
        AppChipStatus.published => AppColors.secondaryLight,
        AppChipStatus.inProgress => AppColors.accentAmberLight,
        AppChipStatus.completed => const Color(0xFFB8F0D4),
        AppChipStatus.cancelled ||
        AppChipStatus.cancelledByPassenger ||
        AppChipStatus.cancelledByDriver =>
          AppColors.accentCoralLight,
        AppChipStatus.confirmed => AppColors.secondaryLight,
        AppChipStatus.pending => AppColors.accentAmberLight,
        AppChipStatus.draft => AppColors.backgroundAlt,
      };

  Color get _textColor => switch (status) {
        AppChipStatus.published => AppColors.secondaryDark,
        AppChipStatus.inProgress => const Color(0xFF8B5A00),
        AppChipStatus.completed => AppColors.success,
        AppChipStatus.cancelled ||
        AppChipStatus.cancelledByPassenger ||
        AppChipStatus.cancelledByDriver =>
          AppColors.error,
        AppChipStatus.confirmed => AppColors.secondaryDark,
        AppChipStatus.pending => const Color(0xFF8B5A00),
        AppChipStatus.draft => AppColors.textSecondary,
      };
}
