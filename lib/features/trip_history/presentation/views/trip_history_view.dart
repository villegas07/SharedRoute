import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/trip_history_entry.dart';
import '../viewmodels/trip_history_viewmodel.dart';
import '../widgets/trip_history_card.dart';

class TripHistoryView extends StatefulWidget {
  const TripHistoryView({super.key});

  @override
  State<TripHistoryView> createState() => _TripHistoryViewState();
}

class _TripHistoryViewState extends State<TripHistoryView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadHistory());
  }

  void _loadHistory() {
    if (!mounted) return;
    context.read<TripHistoryViewModel>().loadHistory();
  }

  bool _onScroll(ScrollNotification n, TripHistoryViewModel vm) {
    final shouldLoad = n.metrics.extentAfter < 240;
    if (shouldLoad && n is ScrollUpdateNotification) vm.loadMore();
    return false;
  }

  void _openDetail(String tripId) {
    final path = AppRoutes.tripHistoryDetail.replaceFirst(':tripId', tripId);
    context.push(path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text(AppStrings.tripHistory)),
      body: Consumer<TripHistoryViewModel>(
        builder: (context, vm, child) => _TripHistoryBody(
          vm: vm,
          onOpen: _openDetail,
          onScroll: _onScroll,
        ),
      ),
    );
  }
}

class _TripHistoryBody extends StatelessWidget {
  final TripHistoryViewModel vm;
  final ValueChanged<String> onOpen;
  final bool Function(ScrollNotification, TripHistoryViewModel) onScroll;

  const _TripHistoryBody({
    required this.vm,
    required this.onOpen,
    required this.onScroll,
  });

  @override
  Widget build(BuildContext context) {
    return switch (vm.status) {
      TripHistoryStatus.initial ||
      TripHistoryStatus.loading => const AppInlineLoading(),
      TripHistoryStatus.error => AppErrorState(
        message: vm.errorMessage ?? AppStrings.errorOccurred,
        onRetry: vm.loadHistory,
      ),
      TripHistoryStatus.empty => const _EmptyHistoryState(),
      TripHistoryStatus.loaded || TripHistoryStatus.loadingMore =>
        _LoadedHistoryState(vm: vm, onOpen: onOpen, onScroll: onScroll),
    };
  }
}

class _LoadedHistoryState extends StatelessWidget {
  final TripHistoryViewModel vm;
  final ValueChanged<String> onOpen;
  final bool Function(ScrollNotification, TripHistoryViewModel) onScroll;

  const _LoadedHistoryState({
    required this.vm,
    required this.onOpen,
    required this.onScroll,
  });

  @override
  Widget build(BuildContext context) {
    final showLoader = vm.status == TripHistoryStatus.loadingMore;
    return NotificationListener<ScrollNotification>(
      onNotification: (n) => onScroll(n, vm),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        itemCount: vm.entries.length + (showLoader ? 2 : 1),
        itemBuilder: (context, index) => _itemAt(context, index, showLoader),
      ),
    );
  }

  Widget _itemAt(BuildContext context, int index, bool showLoader) {
    if (index == 0) return _HistoryHero(entries: vm.entries);
    if (showLoader && index == vm.entries.length + 1) {
      return const _MoreLoader();
    }
    final entry = vm.entries[index - 1];
    return TripHistoryCard(entry: entry, onTap: () => onOpen(entry.tripId));
  }
}

class _HistoryHero extends StatelessWidget {
  final List<TripHistoryEntry> entries;

  const _HistoryHero({required this.entries});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: _decoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeroHeader(total: entries.length),
          const SizedBox(height: 18),
          Row(
            children: [
              _MetricTile(label: 'Como pasajero', value: '$passengerTrips'),
              const SizedBox(width: 12),
              _MetricTile(label: 'Como conductor', value: '$driverTrips'),
            ],
          ),
        ],
      ),
    );
  }

  BoxDecoration get _decoration {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [AppColors.primary, AppColors.secondary],
      ),
      borderRadius: BorderRadius.circular(28),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.18),
          blurRadius: 24,
          offset: const Offset(0, 14),
        ),
      ],
    );
  }

  int get passengerTrips {
    return entries.where((e) => e.role == HistoryRole.passenger).length;
  }

  int get driverTrips {
    return entries.where((e) => e.role == HistoryRole.driver).length;
  }
}

class _HeroHeader extends StatelessWidget {
  final int total;

  const _HeroHeader({required this.total});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tu historial en SharedRoute',
          style: textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Revisa viajes recientes, pagos y estados en un solo lugar.',
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.86),
          ),
        ),
        const SizedBox(height: 16),
        _MetricTile(label: 'Viajes registrados', value: '$total', dark: true),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final bool dark;

  const _MetricTile({
    required this.label,
    required this.value,
    this.dark = false,
  });

  @override
  Widget build(BuildContext context) {
    final background = dark
        ? Colors.white.withValues(alpha: 0.18)
        : AppColors.backgroundWhite;
    final foreground = dark ? Colors.white : AppColors.textPrimary;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: dark ? Colors.white70 : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyHistoryState extends StatelessWidget {
  const _EmptyHistoryState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.backgroundAlt,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.history_toggle_off_rounded,
                size: 50,
                color: AppColors.textDisabled,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              AppStrings.noTripHistory,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Cuando completes un viaje, aparecerá aquí con su estado y valor.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoreLoader extends StatelessWidget {
  const _MoreLoader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 18),
      child: AppInlineLoading(),
    );
  }
}
