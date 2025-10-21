import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../utils/constants.dart';

class DriverTripCard extends StatelessWidget {
  final String driverName;
  final double driverRating;
  final String vehicleInfo;
  final String origin;
  final String destination;
  final String departureTime;
  final String departureDate;
  final int availableSeats;
  final double price;
  final int offers;
  final String? driverImage;
  final VoidCallback? onManageTap;
  final VoidCallback? onCardTap;

  const DriverTripCard({
    super.key,
    required this.driverName,
    required this.driverRating,
    required this.vehicleInfo,
    required this.origin,
    required this.destination,
    required this.departureTime,
    required this.departureDate,
    required this.availableSeats,
    required this.price,
    required this.offers,
    this.driverImage,
    this.onManageTap,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
      child: GestureDetector(
        onTap: onCardTap,
        child: Container(
          padding: const EdgeInsets.all(AppConstants.paddingM),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: AppConstants.paddingM),
              const Divider(height: 1),
              const SizedBox(height: AppConstants.paddingM),
              _buildRoute(),
              const SizedBox(height: AppConstants.paddingM),
              _buildInfo(),
              const SizedBox(height: AppConstants.paddingM),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(
            driverImage ?? AppConstants.defaultAvatarUrl,
          ),
        ),
        const SizedBox(width: AppConstants.paddingS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                driverName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: Color(0xFFFFA726)),
                  const SizedBox(width: 4),
                  Text(
                    driverRating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      '· $vehicleInfo',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textGrey,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingS,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusXL),
          ),
          child: Text(
            '$offers ofertas',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.warning,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoute() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: AppColors.info,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 2,
              height: 40,
              color: AppColors.borderColor,
            ),
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        const SizedBox(width: AppConstants.paddingS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                origin,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                destination,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfo() {
    return Row(
      children: [
        const Icon(Icons.access_time, size: 18, color: AppColors.textGrey),
        const SizedBox(width: 6),
        Text(
          departureTime,
          style: const TextStyle(fontSize: 14, color: AppColors.textGrey),
        ),
        const SizedBox(width: 20),
        const Icon(Icons.calendar_today, size: 18, color: AppColors.textGrey),
        const SizedBox(width: 6),
        Text(
          departureDate,
          style: const TextStyle(fontSize: 14, color: AppColors.textGrey),
        ),
        const SizedBox(width: 20),
        const Icon(Icons.group, size: 18, color: AppColors.textGrey),
        const SizedBox(width: 6),
        Text(
          '$availableSeats asientos',
          style: const TextStyle(fontSize: 14, color: AppColors.textGrey),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '\$${price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const TextSpan(
                text: ' COP',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: onManageTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingL,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusS),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Gestionar',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
