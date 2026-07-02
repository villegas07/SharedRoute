import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../domain/entities/trip_entity.dart';
import '../viewmodels/trip_detail_viewmodel.dart';

class TripDetailView extends StatefulWidget {
  final String tripId;

  const TripDetailView({super.key, required this.tripId});

  @override
  State<TripDetailView> createState() => _TripDetailViewState();
}

class _TripDetailViewState extends State<TripDetailView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<TripDetailViewModel>().loadTrip(widget.tripId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<TripDetailViewModel>(
        builder: (context, vm, _) => switch (vm.status) {
          TripDetailStatus.loading ||
          TripDetailStatus.initial => const AppInlineLoading(),
          TripDetailStatus.error => AppErrorState(
            message: vm.errorMessage ?? AppStrings.errorOccurred,
            onRetry: () => vm.loadTrip(widget.tripId),
          ),
          TripDetailStatus.loaded => _DetailBody(trip: vm.trip!),
        },
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  final TripEntity trip;

  const _DetailBody({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _HeroSection(trip: trip),
                _DriverInfoCard(trip: trip),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: _DetailSections(trip: trip),
                ),
              ],
            ),
          ),
        ),
        _BottomCta(trip: trip),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  final TripEntity trip;

  const _HeroSection({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: _heroPadding(context),
      decoration: _heroDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _HeroBackButton(),
          const SizedBox(height: 18),
          _HeroIntro(trip: trip),
        ],
      ),
    );
  }

  EdgeInsets _heroPadding(BuildContext context) {
    final top = MediaQuery.of(context).padding.top + 8;
    return EdgeInsets.fromLTRB(20, top, 20, 34);
  }

  BoxDecoration _heroDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.primary, AppColors.secondary],
      ),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(32),
        bottomRight: Radius.circular(32),
      ),
    );
  }
}

class _HeroBackButton extends StatelessWidget {
  const _HeroBackButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: context.pop,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: _decoration(),
        child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
      ),
    );
  }

  BoxDecoration _decoration() {
    return BoxDecoration(
      color: Colors.white24,
      borderRadius: BorderRadius.circular(14),
    );
  }
}

class _HeroIntro extends StatelessWidget {
  final TripEntity trip;

  const _HeroIntro({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Detalle premium', style: _captionStyle(context)),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _HeroRouteIndicator(),
            const SizedBox(width: 16),
            Expanded(child: _HeroRouteText(trip: trip)),
          ],
        ),
      ],
    );
  }

  TextStyle? _captionStyle(BuildContext context) {
    return Theme.of(context).textTheme.labelLarge?.copyWith(
      color: Colors.white70,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.4,
    );
  }
}

class _HeroRouteIndicator extends StatelessWidget {
  const _HeroRouteIndicator();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HeroDot(color: Colors.white, ring: Colors.white30),
        Container(
          width: 2,
          height: 34,
          margin: const EdgeInsets.symmetric(vertical: 4),
          color: Colors.white38,
        ),
        const Icon(Icons.location_on_rounded, color: Colors.white, size: 18),
      ],
    );
  }
}

class _HeroDot extends StatelessWidget {
  final Color color;
  final Color ring;

  const _HeroDot({required this.color, required this.ring});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: ring, width: 3),
      ),
    );
  }
}

class _HeroRouteText extends StatelessWidget {
  final TripEntity trip;

  const _HeroRouteText({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HeroStop(city: trip.originCity, address: trip.originAddress),
        const SizedBox(height: 18),
        _HeroStop(city: trip.destinationCity, address: trip.destinationAddress),
      ],
    );
  }
}

class _HeroStop extends StatelessWidget {
  final String city;
  final String address;

  const _HeroStop({required this.city, required this.address});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          city,
          style: theme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          address,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.bodySmall?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}

class _DriverInfoCard extends StatelessWidget {
  final TripEntity trip;

  const _DriverInfoCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: _cardDecoration(),
          child: Row(
            children: [
              _DriverAvatar(driverId: trip.driverId),
              const SizedBox(width: 14),
              Expanded(child: _DriverMeta(trip: trip)),
              const _VerifiedBadge(),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return const BoxDecoration(
      color: AppColors.backgroundWhite,
      borderRadius: BorderRadius.all(Radius.circular(28)),
      boxShadow: [
        BoxShadow(
          color: Color(0x140E3140),
          blurRadius: 24,
          offset: Offset(0, 12),
        ),
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
      radius: 28,
      backgroundColor: AppColors.primary.withValues(alpha: 0.12),
      child: Text(_initial(), style: _textStyle()),
    );
  }

  String _initial() => driverId.isNotEmpty ? driverId[0].toUpperCase() : 'C';

  TextStyle _textStyle() {
    return const TextStyle(
      color: AppColors.primary,
      fontSize: 20,
      fontWeight: FontWeight.w800,
    );
  }
}

class _DriverMeta extends StatelessWidget {
  final TripEntity trip;

  const _DriverMeta({required this.trip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_driverLabel(trip.driverId), style: theme.titleMedium),
        const SizedBox(height: 4),
        Text(_vehicleLabel(trip.vehicleId), style: theme.bodyMedium),
        const SizedBox(height: 6),
        Text(_formatDetailDate(trip.departureAt), style: theme.bodySmall),
      ],
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_rounded, size: 16, color: AppColors.success),
          SizedBox(width: 6),
          Text('Verificado', style: TextStyle(color: AppColors.success)),
        ],
      ),
    );
  }
}

class _DetailSections extends StatelessWidget {
  final TripEntity trip;

  const _DetailSections({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _RouteTimelineCard(trip: trip),
        const SizedBox(height: 16),
        _VehicleInfo(trip: trip),
        const SizedBox(height: 16),
        _TripInfoCard(trip: trip),
        if (_hasNotes(trip)) ...[
          const SizedBox(height: 16),
          _NotesCard(notes: trip.notes!),
        ],
      ],
    );
  }

  bool _hasNotes(TripEntity item) {
    final notes = item.notes;
    return notes != null && notes.isNotEmpty;
  }
}

class _RouteTimelineCard extends StatelessWidget {
  final TripEntity trip;

  const _RouteTimelineCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            title: 'Ruta del viaje',
            chip: _TimeChip(time: _timeOnly(trip.departureAt)),
          ),
          const SizedBox(height: 18),
          _TimelineStop(
            city: trip.originCity,
            address: trip.originAddress,
            isStart: true,
          ),
          const SizedBox(height: 14),
          const _TimelineConnector(),
          const SizedBox(height: 14),
          _TimelineStop(
            city: trip.destinationCity,
            address: trip.destinationAddress,
            isStart: false,
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return const BoxDecoration(
      color: AppColors.backgroundWhite,
      borderRadius: BorderRadius.all(Radius.circular(24)),
      boxShadow: [
        BoxShadow(
          color: Color(0x120E3140),
          blurRadius: 20,
          offset: Offset(0, 10),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget chip;

  const _SectionHeader({required this.title, required this.chip});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        chip,
      ],
    );
  }
}

class _TimeChip extends StatelessWidget {
  final String time;

  const _TimeChip({required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.schedule_rounded,
            size: 16,
            color: AppColors.secondary,
          ),
          const SizedBox(width: 6),
          Text(time, style: const TextStyle(color: AppColors.secondary)),
        ],
      ),
    );
  }
}

class _TimelineStop extends StatelessWidget {
  final String city;
  final String address;
  final bool isStart;

  const _TimelineStop({
    required this.city,
    required this.address,
    required this.isStart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TimelineDot(isStart: isStart),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                city,
                style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                address,
                style: theme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineDot extends StatelessWidget {
  final bool isStart;

  const _TimelineDot({required this.isStart});

  @override
  Widget build(BuildContext context) {
    final color = isStart ? AppColors.success : AppColors.accentCoral;
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2.5),
      ),
    );
  }
}

class _TimelineConnector extends StatelessWidget {
  const _TimelineConnector();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Container(width: 2, height: 22, color: AppColors.secondaryLight),
    );
  }
}

class _VehicleInfo extends StatelessWidget {
  final TripEntity trip;

  const _VehicleInfo({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Vehicle Info', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _InfoPill(
                icon: Icons.directions_car_rounded,
                label: _vehicleLabel(trip.vehicleId),
              ),
              _InfoPill(
                icon: Icons.event_seat_rounded,
                label: '${trip.availableSeats} asientos',
              ),
            ],
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.backgroundWhite,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.35)),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.backgroundAlt,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _TripInfoCard extends StatelessWidget {
  final TripEntity trip;

  const _TripInfoCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _decoration(),
      child: Column(
        children: [
          _InfoTile(
            data: _InfoSpec.departure(_formatDetailDate(trip.departureAt)),
          ),
          const SizedBox(height: 12),
          _InfoTile(
            data: _InfoSpec.seats('${trip.availableSeats} disponibles'),
          ),
          const SizedBox(height: 12),
          _InfoTile(
            data: _InfoSpec.price(_formatDetailPrice(trip.pricePerSeat)),
          ),
          const SizedBox(height: 12),
          _StatusTile(status: trip.status),
        ],
      ),
    );
  }

  BoxDecoration _decoration() {
    return const BoxDecoration(
      color: AppColors.backgroundWhite,
      borderRadius: BorderRadius.all(Radius.circular(24)),
      boxShadow: [
        BoxShadow(
          color: Color(0x120E3140),
          blurRadius: 20,
          offset: Offset(0, 10),
        ),
      ],
    );
  }
}

class _InfoSpec {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoSpec.departure(this.value)
    : icon = Icons.schedule_rounded,
      label = 'Salida',
      color = AppColors.secondary;

  const _InfoSpec.seats(this.value)
    : icon = Icons.airline_seat_recline_normal_rounded,
      label = 'Asientos disponibles',
      color = AppColors.success;

  const _InfoSpec.price(this.value)
    : icon = Icons.payments_rounded,
      label = AppStrings.pricePerSeat,
      color = AppColors.primary;
}

class _InfoTile extends StatelessWidget {
  final _InfoSpec data;

  const _InfoTile({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _tileDecoration(data.color),
      child: Row(
        children: [
          _InfoIcon(data: data),
          const SizedBox(width: 14),
          Expanded(child: Text(data.label, style: theme.bodyMedium)),
          Text(data.value, style: _valueStyle(theme)),
        ],
      ),
    );
  }

  BoxDecoration _tileDecoration(Color color) {
    return BoxDecoration(
      color: color.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(18),
    );
  }

  TextStyle? _valueStyle(TextTheme theme) {
    return theme.titleMedium?.copyWith(fontWeight: FontWeight.w700);
  }
}

class _InfoIcon extends StatelessWidget {
  final _InfoSpec data;

  const _InfoIcon({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: data.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(data.icon, color: data.color, size: 20),
    );
  }
}

class _StatusTile extends StatelessWidget {
  final TripStatus status;

  const _StatusTile({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.backgroundAlt,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const _StatusIcon(),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Estado',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          AppStatusChip(status: _mapDetailStatus(status)),
        ],
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.accentAmber.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.flag_rounded,
        color: AppColors.accentAmber,
        size: 20,
      ),
    );
  }
}

class _NotesCard extends StatelessWidget {
  final String notes;

  const _NotesCard({required this.notes});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryLight.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(notes, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _BottomCta extends StatelessWidget {
  final TripEntity trip;

  const _BottomCta({required this.trip});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 18, 20, bottom + 18),
      decoration: _decoration(),
      child: Row(
        children: [
          _PriceSummary(price: _formatDetailPrice(trip.pricePerSeat)),
          const SizedBox(width: 18),
          Expanded(child: _BookButton(trip: trip)),
        ],
      ),
    );
  }

  BoxDecoration _decoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white,
          AppColors.secondaryLight.withValues(alpha: 0.18),
        ],
      ),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 18,
          offset: const Offset(0, -6),
        ),
      ],
    );
  }
}

class _PriceSummary extends StatelessWidget {
  final String price;

  const _PriceSummary({required this.price});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(price, style: _priceStyle(theme)),
        const SizedBox(height: 2),
        Text(
          '/asiento',
          style: theme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  TextStyle? _priceStyle(TextTheme theme) {
    return theme.headlineSmall?.copyWith(
      color: AppColors.primary,
      fontWeight: FontWeight.w800,
    );
  }
}

class _BookButton extends StatelessWidget {
  final TripEntity trip;

  const _BookButton({required this.trip});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _decoration(isEnabled),
      child: ElevatedButton(
        onPressed: isEnabled ? () => _openBooking(context) : null,
        style: _style(),
        child: Text(isEnabled ? AppStrings.book : 'No disponible'),
      ),
    );
  }

  bool get isEnabled {
    return trip.status == TripStatus.published && trip.availableSeats > 0;
  }

  void _openBooking(BuildContext context) {
    context.push(AppRoutes.bookingDetail.replaceFirst(':id', trip.id));
  }

  BoxDecoration _decoration(bool enabled) {
    final colors = enabled
        ? const [AppColors.primary, AppColors.secondary]
        : const [AppColors.textDisabled, AppColors.textDisabled];
    return BoxDecoration(
      gradient: LinearGradient(colors: colors),
      borderRadius: BorderRadius.circular(18),
      boxShadow: enabled ? _shadow() : const [],
    );
  }

  List<BoxShadow> _shadow() {
    return [
      BoxShadow(
        color: AppColors.primary.withValues(alpha: 0.28),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ];
  }

  ButtonStyle _style() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      disabledBackgroundColor: Colors.transparent,
      disabledForegroundColor: Colors.white,
      shadowColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 16),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    );
  }
}

String _formatDetailDate(String isoDate) {
  try {
    final date = DateTime.parse(isoDate).toLocal();
    return DateFormat('EEEE, d MMM yyyy • HH:mm', 'es_CO').format(date);
  } catch (_) {
    return isoDate;
  }
}

String _timeOnly(String isoDate) {
  try {
    final date = DateTime.parse(isoDate).toLocal();
    return DateFormat('HH:mm', 'es_CO').format(date);
  } catch (_) {
    return isoDate;
  }
}

String _formatDetailPrice(double price) {
  return NumberFormat.currency(
    locale: 'es_CO',
    symbol: r'$',
    decimalDigits: 0,
  ).format(price);
}

String _driverLabel(String driverId) {
  if (driverId.isEmpty) return 'Conductor asignado';
  final shortId = driverId.length > 8 ? driverId.substring(0, 8) : driverId;
  return 'Conductor #$shortId';
}

String _vehicleLabel(String vehicleId) {
  if (vehicleId.isEmpty) return 'Vehículo por confirmar';
  final shortId = vehicleId.length > 8 ? vehicleId.substring(0, 8) : vehicleId;
  return 'Vehículo #$shortId';
}

AppChipStatus _mapDetailStatus(TripStatus status) {
  return switch (status) {
    TripStatus.draft => AppChipStatus.draft,
    TripStatus.published => AppChipStatus.published,
    TripStatus.inProgress => AppChipStatus.inProgress,
    TripStatus.completed => AppChipStatus.completed,
    TripStatus.cancelled => AppChipStatus.cancelled,
  };
}
