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
    context.read<TripDetailViewModel>().loadTrip(widget.tripId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.tripDetail),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<TripDetailViewModel>(
        builder: (context, vm, _) => switch (vm.status) {
          TripDetailStatus.loading || TripDetailStatus.initial =>
            const AppInlineLoading(),
          TripDetailStatus.error => AppErrorState(
              message: vm.errorMessage ?? AppStrings.errorOccurred,
              onRetry: () => vm.loadTrip(widget.tripId),
            ),
          TripDetailStatus.loaded => _TripDetailContent(trip: vm.trip!),
        },
      ),
    );
  }
}

class _TripDetailContent extends StatelessWidget {
  final TripEntity trip;

  const _TripDetailContent({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _RouteCard(trip: trip),
                const SizedBox(height: 16),
                _TripInfoCard(trip: trip),
                if (trip.notes != null && trip.notes!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _NotesCard(notes: trip.notes!),
                ],
              ],
            ),
          ),
        ),
        _BookingFooter(trip: trip),
      ],
    );
  }
}

class _RouteCard extends StatelessWidget {
  final TripEntity trip;

  const _RouteCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RouteRow(
              icon: Icons.trip_origin,
              iconColor: AppColors.primary,
              label: 'Origen',
              address: trip.originAddress,
              city: trip.originCity,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: SizedBox(
                height: 20,
                child: VerticalDivider(color: AppColors.primaryLight, width: 2),
              ),
            ),
            _RouteRow(
              icon: Icons.location_on,
              iconColor: AppColors.accentCoral,
              label: 'Destino',
              address: trip.destinationAddress,
              city: trip.destinationCity,
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String address;
  final String city;

  const _RouteRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.address,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: Theme.of(context).textTheme.bodyMedium),
              Text(
                address,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TripInfoCard extends StatelessWidget {
  final TripEntity trip;

  const _TripInfoCard({required this.trip});

  String _formatDate(String isoDate) {
    try {
      return DateFormat('EEEE, d MMMM yyyy - HH:mm', 'es_CO')
          .format(DateTime.parse(isoDate).toLocal());
    } catch (_) {
      return isoDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final price = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    ).format(trip.pricePerSeat);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _InfoRow(
              icon: Icons.schedule,
              label: 'Salida',
              value: _formatDate(trip.departureAt),
            ),
            const Divider(),
            _InfoRow(
              icon: Icons.event_seat,
              label: AppStrings.availableSeats,
              value: trip.availableSeats.toString(),
            ),
            const Divider(),
            _InfoRow(
              icon: Icons.monetization_on_outlined,
              label: AppStrings.pricePerSeat,
              value: price,
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Estado'),
                AppStatusChip(status: _mapStatus(trip.status)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  AppChipStatus _mapStatus(TripStatus s) => switch (s) {
        TripStatus.draft => AppChipStatus.draft,
        TripStatus.published => AppChipStatus.published,
        TripStatus.inProgress => AppChipStatus.inProgress,
        TripStatus.completed => AppChipStatus.completed,
        TripStatus.cancelled => AppChipStatus.cancelled,
      };
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Text(label,
              style: Theme.of(context).textTheme.bodyMedium),
          const Spacer(),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _NotesCard extends StatelessWidget {
  final String notes;

  const _NotesCard({required this.notes});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline, color: AppColors.info),
            const SizedBox(width: 12),
            Expanded(
              child: Text(notes,
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingFooter extends StatelessWidget {
  final TripEntity trip;

  const _BookingFooter({required this.trip});

  @override
  Widget build(BuildContext context) {
    final canBook = trip.status == TripStatus.published && trip.availableSeats > 0;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: const BoxDecoration(
        color: AppColors.backgroundWhite,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: ElevatedButton(
        onPressed: canBook
            ? () => context.push(
                  AppRoutes.bookingDetail.replaceFirst(':id', trip.id),
                )
            : null,
        child: Text(canBook ? AppStrings.book : 'No disponible'),
      ),
    );
  }
}
