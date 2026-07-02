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
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [_shadow()],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BookingHeader(booking),
                const SizedBox(height: 16),
                _BookingMetrics(booking),
                const SizedBox(height: 16),
                _BookingFooter(_formatDate(booking.createdAt)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxShadow _shadow() {
    return BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.08),
      blurRadius: 22,
      offset: const Offset(0, 10),
    );
  }

  String _formatDate(String isoDate) {
    try {
      return DateFormat('dd MMM yyyy', 'es_CO').format(DateTime.parse(isoDate));
    } catch (_) {
      return isoDate;
    }
  }
}

class _BookingHeader extends StatelessWidget {
  final BookingEntity booking;

  const _BookingHeader(this.booking);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Row(
      children: [
        const _BookingIcon(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reserva premium',
                style: theme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 2),
              Text(
                '#${booking.id.substring(0, 8)}',
                style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        AppStatusChip(status: _mapStatus(booking.status)),
      ],
    );
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

class _BookingIcon extends StatelessWidget {
  const _BookingIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryLight, AppColors.secondaryLight],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(
        Icons.confirmation_number_outlined,
        size: 20,
        color: AppColors.primary,
      ),
    );
  }
}

class _BookingMetrics extends StatelessWidget {
  final BookingEntity booking;

  const _BookingMetrics(this.booking);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _MetricChip(Icons.event_seat_rounded, 'Asientos', '${booking.seatsReserved}'),
        _MetricChip(Icons.payments_outlined, 'Total', _formatPrice(booking.totalPrice)),
        _MetricChip(Icons.shield_outlined, 'Estado', _statusLabel(booking.status)),
      ],
    );
  }

  String _formatPrice(double price) {
    return NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    ).format(price);
  }

  String _statusLabel(BookingStatus status) {
    return switch (status) {
      BookingStatus.pending => 'Pendiente',
      BookingStatus.confirmed => 'Confirmada',
      BookingStatus.cancelledByPassenger => 'Cancelada',
      BookingStatus.cancelledByDriver => 'Cancelada',
      BookingStatus.completed => 'Completada',
    };
  }
}

class _MetricChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetricChip(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.backgroundAlt,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.bodySmall?.copyWith(color: AppColors.textSecondary)),
              Text(value, style: theme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}

class _BookingFooter extends StatelessWidget {
  final String date;

  const _BookingFooter(this.date);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Row(
      children: [
        Text(
          '${AppStrings.totalPrice} y detalles',
          style: theme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(date, style: theme.bodySmall?.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}
