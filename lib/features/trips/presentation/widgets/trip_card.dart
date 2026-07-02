import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../domain/entities/trip_entity.dart';

class TripCard extends StatelessWidget {
  final TripEntity trip;
  final VoidCallback onTap;

  const TripCard({super.key, required this.trip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRoute(context),
              const SizedBox(height: 12),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoute(BuildContext context) {
    return Row(
      children: [
        const _RouteIndicator(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trip.originCity,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                trip.destinationCity,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
        AppStatusChip(status: _mapTripStatus(trip.status)),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    final departureDate = _formatDate(trip.departureAt);
    final price = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    ).format(trip.pricePerSeat);

    return Row(
      children: [
        const Icon(Icons.schedule, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(departureDate,
            style: Theme.of(context).textTheme.bodyMedium),
        const Spacer(),
        const Icon(Icons.event_seat, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          '${trip.availableSeats} ${AppStrings.availableSeats}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const Spacer(),
        Text(
          '$price/asiento',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate).toLocal();
      return DateFormat('dd MMM, HH:mm', 'es_CO').format(date);
    } catch (_) {
      return isoDate;
    }
  }

  AppChipStatus _mapTripStatus(TripStatus status) => switch (status) {
        TripStatus.draft => AppChipStatus.draft,
        TripStatus.published => AppChipStatus.published,
        TripStatus.inProgress => AppChipStatus.inProgress,
        TripStatus.completed => AppChipStatus.completed,
        TripStatus.cancelled => AppChipStatus.cancelled,
      };
}

class _RouteIndicator extends StatelessWidget {
  const _RouteIndicator();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.trip_origin, size: 16, color: AppColors.primary),
        Container(
          width: 2,
          height: 20,
          color: AppColors.primaryLight,
        ),
        const Icon(Icons.location_on, size: 16, color: AppColors.accentCoral),
      ],
    );
  }
}
