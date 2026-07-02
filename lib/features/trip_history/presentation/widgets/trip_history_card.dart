import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../domain/entities/trip_history_entry.dart';

class TripHistoryCard extends StatelessWidget {
  final TripHistoryEntry entry;
  final VoidCallback onTap;

  const TripHistoryCard({super.key, required this.entry, required this.onTap});

  String _formatDate(String iso) {
    try {
      return DateFormat('d MMM yyyy', 'es_CO')
          .format(DateTime.parse(iso).toLocal());
    } catch (_) {
      return iso;
    }
  }

  String _formatPrice(double price) {
    return NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    ).format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${entry.originCity} → ${entry.destinationCity}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  AppStatusChip(status: _mapStatus(entry.status)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.schedule, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(entry.departureAt),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  const Icon(Icons.person_outline, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    entry.role == HistoryRole.passenger ? 'Pasajero' : 'Conductor',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _formatPrice(entry.totalPrice),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppChipStatus _mapStatus(String s) => switch (s) {
        'completed' => AppChipStatus.completed,
        'cancelled' => AppChipStatus.cancelled,
        'inProgress' => AppChipStatus.inProgress,
        _ => AppChipStatus.published,
      };
}
