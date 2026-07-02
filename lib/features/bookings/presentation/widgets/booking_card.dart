import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../domain/entities/booking_entity.dart';

class BookingCard extends StatelessWidget {
  final BookingEntity booking;
  final VoidCallback onTap;

  const BookingCard({super.key, required this.booking, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _CardHeader(booking: booking),
                const SizedBox(height: 14),
                _RouteIndicator(booking: booking),
                const SizedBox(height: 14),
                _CardFooter(booking: booking),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final BookingEntity booking;

  const _CardHeader({required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Row(
      children: [
        const _TicketIcon(),
        const SizedBox(width: 12),
        Expanded(child: _HeaderText(booking: booking, theme: theme)),
        AppStatusChip(status: _status(booking.status)),
      ],
    );
  }

  AppChipStatus _status(BookingStatus value) {
    return switch (value) {
      BookingStatus.pending => AppChipStatus.pending,
      BookingStatus.confirmed => AppChipStatus.confirmed,
      BookingStatus.cancelledByPassenger => AppChipStatus.cancelledByPassenger,
      BookingStatus.cancelledByDriver => AppChipStatus.cancelledByDriver,
      BookingStatus.completed => AppChipStatus.completed,
    };
  }
}

class _TicketIcon extends StatelessWidget {
  const _TicketIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.confirmation_number_rounded,
        color: AppColors.primary,
        size: 20,
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  final BookingEntity booking;
  final TextTheme theme;

  const _HeaderText({required this.booking, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reserva #${booking.id.substring(0, 8)}', style: theme.titleMedium),
        Text(_formatDate(booking.createdAt), style: theme.bodySmall),
      ],
    );
  }

  String _formatDate(String value) {
    final date = DateTime.tryParse(value);
    if (date == null) return value;
    return DateFormat('dd MMM yyyy', 'es').format(date);
  }
}

class _RouteIndicator extends StatelessWidget {
  final BookingEntity booking;

  const _RouteIndicator({required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.backgroundAlt,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const _RouteDots(),
          const SizedBox(width: 14),
          Expanded(child: _RouteText(booking: booking, theme: theme)),
        ],
      ),
    );
  }
}

class _RouteDots extends StatelessWidget {
  const _RouteDots();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _Dot(color: AppColors.success),
        Container(
          width: 2,
          height: 20,
          color: AppColors.textDisabled.withValues(alpha: 0.3),
        ),
        const _Dot(color: AppColors.accentCoral),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;

  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _RouteText extends StatelessWidget {
  final BookingEntity booking;
  final TextTheme theme;

  const _RouteText({required this.booking, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RouteLabel(label: 'Trayecto', value: _tripLabel()),
        const SizedBox(height: 8),
        _RouteLabel(label: 'Pasajero', value: _passengerLabel()),
      ],
    );
  }

  String _tripLabel() {
    return booking.tripId.isEmpty ? 'Viaje por confirmar' : 'Viaje #${booking.tripId.substring(0, 8)}';
  }

  String _passengerLabel() {
    if (booking.passengerId.isEmpty) return 'Perfil pendiente';
    return 'Usuario #${booking.passengerId.substring(0, 8)}';
  }
}

class _RouteLabel extends StatelessWidget {
  final String label;
  final String value;

  const _RouteLabel({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.bodySmall?.copyWith(color: AppColors.textSecondary)),
        Text(value, style: theme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }
}

class _CardFooter extends StatelessWidget {
  final BookingEntity booking;

  const _CardFooter({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.airline_seat_recline_normal_rounded,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 4),
        Text('${booking.seatsReserved} asiento(s)', style: Theme.of(context).textTheme.bodySmall),
        const Spacer(),
        if (booking.totalPrice > 0) _PriceText(price: booking.totalPrice),
      ],
    );
  }
}

class _PriceText extends StatelessWidget {
  final double price;

  const _PriceText({required this.price});

  @override
  Widget build(BuildContext context) {
    return Text(
      '\$${price.toStringAsFixed(0)}',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
    );
  }
}
