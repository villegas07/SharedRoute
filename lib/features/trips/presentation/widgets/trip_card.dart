import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../domain/entities/trip_entity.dart';

class TripCard extends StatelessWidget {
  final TripEntity trip;
  final VoidCallback onTap;

  const TripCard({super.key, required this.trip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: _cardDecoration(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                _CardHeader(trip: trip),
                const SizedBox(height: 16),
                _CardFooter(trip: trip),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.backgroundWhite,
      borderRadius: BorderRadius.circular(24),
      boxShadow: const [
        BoxShadow(
          color: Color(0x120E3140),
          blurRadius: 20,
          offset: Offset(0, 10),
        ),
      ],
    );
  }
}

class _CardHeader extends StatelessWidget {
  final TripEntity trip;

  const _CardHeader({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _RouteIndicator(),
        const SizedBox(width: 14),
        Expanded(child: _RouteSummary(trip: trip)),
        const SizedBox(width: 12),
        _PriceBadge(price: _formatTripPrice(trip.pricePerSeat)),
      ],
    );
  }
}

class _RouteSummary extends StatelessWidget {
  final TripEntity trip;

  const _RouteSummary({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ruta compartida', style: _eyebrowStyle(context)),
        const SizedBox(height: 10),
        _StopText(
          city: trip.originCity,
          label: 'Salida',
          color: AppColors.primary,
        ),
        const SizedBox(height: 14),
        _StopText(
          city: trip.destinationCity,
          label: 'Destino',
          color: AppColors.accentCoral,
        ),
      ],
    );
  }

  TextStyle? _eyebrowStyle(BuildContext context) {
    return Theme.of(context).textTheme.labelMedium?.copyWith(
      color: AppColors.textSecondary,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.4,
    );
  }
}

class _StopText extends StatelessWidget {
  final String city;
  final String label;
  final Color color;

  const _StopText({
    required this.city,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.bodySmall?.copyWith(color: color)),
        const SizedBox(height: 2),
        Text(
          city,
          style: theme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _PriceBadge extends StatelessWidget {
  final String price;

  const _PriceBadge({required this.price});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: _decoration(),
      child: Column(
        children: [
          Text(
            price,
            style: theme.titleMedium?.copyWith(color: AppColors.primaryDark),
          ),
          Text(
            '/asiento',
            style: theme.bodySmall?.copyWith(color: AppColors.primaryDark),
          ),
        ],
      ),
    );
  }

  BoxDecoration _decoration() {
    return BoxDecoration(
      color: AppColors.primaryLight,
      borderRadius: BorderRadius.circular(16),
    );
  }
}

class _CardFooter extends StatelessWidget {
  final TripEntity trip;

  const _CardFooter({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MetaChip(data: _dateChip(trip.departureAt)),
        const SizedBox(width: 8),
        _MetaChip(data: _seatChip(trip.availableSeats)),
        const Spacer(),
        AppStatusChip(status: _mapTripStatus(trip.status)),
      ],
    );
  }
}

class _RouteIndicator extends StatelessWidget {
  const _RouteIndicator();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _IndicatorDot(color: AppColors.primary, ring: AppColors.primaryLight),
        Container(
          width: 2,
          height: 30,
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primary, AppColors.accentCoral],
            ),
          ),
        ),
        _IndicatorDot(
          color: AppColors.accentCoral,
          ring: AppColors.accentCoralLight,
        ),
      ],
    );
  }
}

class _IndicatorDot extends StatelessWidget {
  final Color color;
  final Color ring;

  const _IndicatorDot({required this.color, required this.ring});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: ring, width: 2),
      ),
    );
  }
}

class _MetaChipData {
  final IconData icon;
  final String text;
  final Color tint;

  const _MetaChipData({
    required this.icon,
    required this.text,
    required this.tint,
  });
}

class _MetaChip extends StatelessWidget {
  final _MetaChipData data;

  const _MetaChip({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: _decoration(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(data.icon, size: 14, color: data.tint),
          const SizedBox(width: 5),
          Text(
            data.text,
            style: theme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  BoxDecoration _decoration() {
    return BoxDecoration(
      color: AppColors.backgroundAlt,
      borderRadius: BorderRadius.circular(12),
    );
  }
}

_MetaChipData _dateChip(String isoDate) {
  return _MetaChipData(
    icon: Icons.schedule_rounded,
    text: _formatTripDate(isoDate),
    tint: AppColors.secondary,
  );
}

_MetaChipData _seatChip(int seats) {
  return _MetaChipData(
    icon: Icons.airline_seat_recline_normal_rounded,
    text: '$seats disp.',
    tint: AppColors.success,
  );
}

String _formatTripPrice(double price) {
  return NumberFormat.currency(
    locale: 'es_CO',
    symbol: '\$',
    decimalDigits: 0,
  ).format(price);
}

String _formatTripDate(String isoDate) {
  try {
    final date = DateTime.parse(isoDate).toLocal();
    return DateFormat('dd MMM, HH:mm', 'es_CO').format(date);
  } catch (_) {
    return isoDate;
  }
}

AppChipStatus _mapTripStatus(TripStatus status) {
  return switch (status) {
    TripStatus.draft => AppChipStatus.draft,
    TripStatus.published => AppChipStatus.published,
    TripStatus.inProgress => AppChipStatus.inProgress,
    TripStatus.completed => AppChipStatus.completed,
    TripStatus.cancelled => AppChipStatus.cancelled,
  };
}
