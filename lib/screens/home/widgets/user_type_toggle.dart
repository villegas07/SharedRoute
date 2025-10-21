import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';
import '../../../utils/constants.dart';

class UserTypeToggle extends StatelessWidget {
  final bool isPassenger;
  final Function(bool) onToggle;

  const UserTypeToggle({
    super.key,
    required this.isPassenger,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildToggleButton(
              isActive: isPassenger,
              label: 'Pasajero',
              icon: Icons.person,
              onTap: () => onToggle(true),
            ),
            _buildToggleButton(
              isActive: !isPassenger,
              label: 'Conductor',
              icon: Icons.directions_car,
              onTap: () => onToggle(false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required bool isActive,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingL,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? AppColors.white : AppColors.textGrey,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.white : AppColors.textGrey,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
