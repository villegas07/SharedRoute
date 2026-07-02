import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/trip_entity.dart';

class TripCard extends StatelessWidget {
  final TripEntity trip;
  final VoidCallback? onTap;

  const TripCard({super.key, required this.trip, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                _TripHeader(trip: trip),
                const SizedBox(height: 16),
                _TripRoute(trip: trip),
                const SizedBox(height: 16),
                _TripFooter(trip: trip),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TripHeader extends StatelessWidget {
  final TripEntity trip;

  const _TripHeader({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _DriverAvatar(driverId: trip.driverId),
        const SizedBox(width: 12),
        Expanded(child: _HeaderInfo(trip: trip)),
        _PriceBadge(price: trip.pricePerSeat),
      ],
    );
  }
}

class _DriverAvatar extends StatelessWidget {
  final String driverId;

  const _DriverAvatar({required this.driverId});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
      child: Text(
        _initial(),
        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
      ),
    );
  }

  String _initial() {
    return driverId.isNotEmpty ? driverId[0].toUpperCase() : 'C';
  }
}

class _HeaderInfo extends StatelessWidget {
  final TripEntity trip;

  const _HeaderInfo({required this.trip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_driverLabel(), style: theme.titleMedium),
        Text(_formatDateTime(trip.departureAt), style: theme.bodySmall),
      ],
    );
  }

  String _driverLabel() {
    return trip.driverId.isNotEmpty ? 'Conductor #${trip.driverId.substring(0, 8)}' : 'Conductor';
  }

  String _formatDateTime(String value) {
    final date = DateTime.tryParse(value);
    if (date == null) return value;
    return DateFormat('EEE dd MMM, HH:mm', 'es').format(date);
  }
}

class _PriceBadge extends StatelessWidget {
  final double price;

  const _PriceBadge({required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '\$${price.toStringAsFixed(0)}',
        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _TripRoute extends StatelessWidget {
  final TripEntity trip;

  const _TripRoute({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.backgroundAlt,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const _TripDots(),
          const SizedBox(width: 14),
          Expanded(child: _LocationText(trip: trip)),
        ],
      ),
    );
  }
}

class _TripDots extends StatelessWidget {
  const _TripDots();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _Dot(color: AppColors.success),
        Container(width: 2, height: 22, color: AppColors.textDisabled.withValues(alpha: 0.3)),
        const _Dot(color: AppColors.accentCoral),
      ],
    );
  }
}

class _LocationText extends StatelessWidget {
  final TripEntity trip;

  const _LocationText({required this.trip});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_origin(), style: style, maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 10),
        Text(_destination(), style: style, maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }

  String _origin() => trip.originCity.isNotEmpty ? trip.originCity : 'Origen';

  String _destination() {
    return trip.destinationCity.isNotEmpty ? trip.destinationCity : 'Destino';
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

class _TripFooter extends StatelessWidget {
  final TripEntity trip;

  const _TripFooter({required this.trip});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall;
    return Row(
      children: [
        const Icon(Icons.airline_seat_recline_normal, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text('${trip.availableSeats} disponibles', style: style),
        const SizedBox(width: 16),
        const Icon(Icons.directions_car_rounded, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Expanded(child: Text(_vehicleInfo(), style: style, overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  String _vehicleInfo() {
    if (trip.vehicleId.isEmpty) return 'Vehículo por confirmar';
    return 'Vehículo #${trip.vehicleId.substring(0, 8)}';
  }
}
