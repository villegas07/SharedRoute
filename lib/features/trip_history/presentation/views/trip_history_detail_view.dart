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
import '../../domain/entities/trip_history_entry.dart';
import '../viewmodels/trip_history_detail_viewmodel.dart';

class TripHistoryDetailView extends StatefulWidget {
  final String tripId;

  const TripHistoryDetailView({super.key, required this.tripId});

  @override
  State<TripHistoryDetailView> createState() => _TripHistoryDetailViewState();
}

class _TripHistoryDetailViewState extends State<TripHistoryDetailView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<TripHistoryDetailViewModel>().loadDetail(widget.tripId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.tripHistory),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<TripHistoryDetailViewModel>(
        builder: (context, vm, _) => switch (vm.status) {
          TripHistoryDetailStatus.initial ||
          TripHistoryDetailStatus.loading =>
            const AppInlineLoading(),
          TripHistoryDetailStatus.error => AppErrorState(
              message: vm.errorMessage ?? AppStrings.errorOccurred,
              onRetry: () => vm.loadDetail(widget.tripId),
            ),
          TripHistoryDetailStatus.loaded => _DetailContent(
              entry: vm.entry!,
              tripId: widget.tripId,
            ),
        },
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  final TripHistoryEntry entry;
  final String tripId;

  const _DetailContent({required this.entry, required this.tripId});

  String _formatDate(String iso) {
    try {
      return DateFormat('EEEE, d MMMM yyyy - HH:mm', 'es_CO')
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _infoCard(context),
          const SizedBox(height: 16),
          if (entry.role == HistoryRole.passenger)
            _reviewButton(context),
        ],
      ),
    );
  }

  Widget _infoCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _row(context, Icons.trip_origin, AppColors.primary, 'Origen', entry.originCity),
            const Divider(),
            _row(context, Icons.location_on, AppColors.accentCoral, 'Destino', entry.destinationCity),
            const Divider(),
            _row(context, Icons.schedule, AppColors.textSecondary, 'Salida', _formatDate(entry.departureAt)),
            const Divider(),
            _row(context, Icons.person_outline, AppColors.textSecondary, 'Rol',
                entry.role == HistoryRole.passenger ? 'Pasajero' : 'Conductor'),
            const Divider(),
            _row(context, Icons.monetization_on_outlined, AppColors.textSecondary, 'Total', _formatPrice(entry.totalPrice)),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Estado'),
                AppStatusChip(status: _mapStatus(entry.status)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, IconData icon, Color color, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 12),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => context.push(
        AppRoutes.createReview.replaceFirst(':tripId', tripId),
      ),
      icon: const Icon(Icons.star_outline),
      label: const Text(AppStrings.leaveReview),
    );
  }

  AppChipStatus _mapStatus(String s) => switch (s) {
        'completed' => AppChipStatus.completed,
        'cancelled' => AppChipStatus.cancelled,
        'inProgress' => AppChipStatus.inProgress,
        _ => AppChipStatus.published,
      };
}
