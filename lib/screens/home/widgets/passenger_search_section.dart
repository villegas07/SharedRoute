import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';
import '../../../utils/constants.dart';

class PassengerSearchSection extends StatelessWidget {
  const PassengerSearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusL),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 10,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          children: [
            _buildLocationField(
              icon: Icons.location_on,
              iconColor: AppColors.info,
              backgroundColor: const Color(0xFFE3F2FD),
              label: 'Universidad Central',
            ),
            const SizedBox(height: AppConstants.paddingS),
            _buildLocationField(
              icon: Icons.location_on,
              iconColor: AppColors.success,
              backgroundColor: const Color(0xFFE8F5E9),
              label: '¿A dónde vas?',
              isPlaceholder: true,
            ),
            const SizedBox(height: AppConstants.paddingL),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Buscar viajes
                },
                child: const Text(
                  'Buscar viajes disponibles',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationField({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String label,
    bool isPlaceholder = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusM),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusS),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: AppConstants.paddingS),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: isPlaceholder ? AppColors.textDisabled : AppColors.textDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
