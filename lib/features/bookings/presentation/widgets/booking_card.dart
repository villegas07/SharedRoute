import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../domain/entities/booking_entity.dart';

class BookingCard extends StatelessWidget {
  final BookingEntity booking;
  final VoidCallback onTap;

  const BookingCard({super.key, required this.booking, required this.onTap});

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reserva #${booking.id.substring(0, 8)}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  AppStatusChip(status: _mapStatus(booking.status)),
                ],
              ),
              const SizedBox(height: 8),
              _DetailRow(
                icon: Icons.event_seat,
                text:
                    '${booking.seatsReserved} ${AppStrings.seatsReserved}',
              ),
              const SizedBox(height: 4),
              _DetailRow(
                icon: Icons.monetization_on_outlined,
                text: _formatPrice(booking.totalPrice),
              ),
              const SizedBox(height: 4),
              _DetailRow(
                icon: Icons.calendar_today,
                text: _formatDate(booking.createdAt),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    return NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    ).format(price);
  }

  String _formatDate(String isoDate) {
    try {
      return DateFormat('dd MMM yyyy', 'es_CO')
          .format(DateTime.parse(isoDate));
    } catch (_) {
      return isoDate;
    }
  }

  AppChipStatus _mapStatus(BookingStatus status) => switch (status) {
        BookingStatus.pending => AppChipStatus.pending,
        BookingStatus.confirmed => AppChipStatus.confirmed,
        BookingStatus.cancelledByPassenger =>
          AppChipStatus.cancelledByPassenger,
        BookingStatus.cancelledByDriver => AppChipStatus.cancelledByDriver,
        BookingStatus.completed => AppChipStatus.completed,
      };
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DetailRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ],
      );
}
