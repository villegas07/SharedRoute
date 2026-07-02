import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/trip_history_entry.dart';

class TripHistoryCard extends StatelessWidget {
  final TripHistoryEntry entry;
  final VoidCallback onTap;

  const TripHistoryCard({super.key, required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: _TripCardShell(
        onTap: onTap,
        child: _TripCardContent(
          entry: entry,
          date: _formatDate(entry.departureAt),
          price: _formatPrice(entry.totalPrice),
        ),
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final date = DateTime.parse(iso).toLocal();
      return DateFormat('d MMM yyyy', 'es_CO').format(date);
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
}

class _TripCardShell extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const _TripCardShell({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _decoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(26),
          child: child,
        ),
      ),
    );
  }

  BoxDecoration get _decoration {
    return BoxDecoration(
      color: AppColors.backgroundWhite,
      borderRadius: BorderRadius.circular(26),
      border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.6)),
      boxShadow: [_shadow],
    );
  }

  BoxShadow get _shadow {
    return BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.08),
      blurRadius: 22,
      offset: const Offset(0, 10),
    );
  }
}

class _TripCardContent extends StatelessWidget {
  final TripHistoryEntry entry;
  final String date;
  final String price;

  const _TripCardContent({
    required this.entry,
    required this.date,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          _TripHeader(entry: entry, price: price),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.backgroundAlt),
          const SizedBox(height: 14),
          _TripFooter(entry: entry, date: date),
        ],
      ),
    );
  }
}

class _TripHeader extends StatelessWidget {
  final TripHistoryEntry entry;
  final String price;

  const _TripHeader({required this.entry, required this.price});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RoleIcon(role: entry.role),
        const SizedBox(width: 12),
        Expanded(child: _RouteDetails(entry: entry)),
        const SizedBox(width: 12),
        _PricePill(price: price),
      ],
    );
  }
}

class _RoleIcon extends StatelessWidget {
  final HistoryRole role;

  const _RoleIcon({required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: _accent.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(_icon, color: _accent, size: 24),
    );
  }

  Color get _accent =>
      role == HistoryRole.driver ? AppColors.accentAmber : AppColors.primary;

  IconData get _icon => role == HistoryRole.driver
      ? Icons.local_taxi_rounded
      : Icons.person_rounded;
}

class _RouteDetails extends StatelessWidget {
  final TripHistoryEntry entry;

  const _RouteDetails({required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_route, style: theme.titleMedium, maxLines: 1),
        const SizedBox(height: 6),
        _MetaPill(icon: Icons.badge_rounded, label: _roleLabel),
      ],
    );
  }

  String get _route => '${entry.originCity} → ${entry.destinationCity}';

  String get _roleLabel {
    return entry.role == HistoryRole.passenger ? 'Pasajero' : 'Conductor';
  }
}

class _PricePill extends StatelessWidget {
  final String price;

  const _PricePill({required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        price,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppColors.primaryDark,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _TripFooter extends StatelessWidget {
  final TripHistoryEntry entry;
  final String date;

  const _TripFooter({required this.entry, required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MetaPill(icon: Icons.schedule_rounded, label: date),
              _MetaPill(icon: Icons.route_rounded, label: _statusHint),
            ],
          ),
        ),
        const SizedBox(width: 10),
        _StatusBadge(status: entry.status),
      ],
    );
  }

  String get _statusHint {
    return entry.status.toUpperCase() == 'CANCELLED'
        ? 'Viaje detenido'
        : 'Ruta verificada';
  }
}

class _MetaPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.backgroundAlt,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _style.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _style.label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: _style.foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  _StatusStyle get _style {
    return switch (status.toUpperCase()) {
      'COMPLETED' => const _StatusStyle(
        'Completado',
        Color(0xFFDEF4E7),
        AppColors.success,
      ),
      'CANCELLED' => const _StatusStyle(
        'Cancelado',
        AppColors.accentCoralLight,
        AppColors.error,
      ),
      'IN_PROGRESS' => const _StatusStyle(
        'En curso',
        Color(0xFFFCE8C5),
        Color(0xFF8B5A00),
      ),
      _ => const _StatusStyle(
        'Activo',
        AppColors.secondaryLight,
        AppColors.secondary,
      ),
    };
  }
}

class _StatusStyle {
  final String label;
  final Color background;
  final Color foreground;

  const _StatusStyle(this.label, this.background, this.foreground);
}
