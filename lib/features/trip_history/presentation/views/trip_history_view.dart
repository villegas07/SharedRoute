import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<TripHistoryViewModel>().loadHistory();
    });
  }

  bool _onScroll(ScrollNotification n, TripHistoryViewModel vm) {
    if (n is ScrollEndNotification && n.metrics.extentAfter < 200) {
      vm.loadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.tripHistory)),
      body: Consumer<TripHistoryViewModel>(
        builder: (context, vm, _) => switch (vm.status) {
          TripHistoryStatus.initial ||
          TripHistoryStatus.loading =>
            const AppInlineLoading(),
          TripHistoryStatus.error => AppErrorState(
              message: vm.errorMessage ?? AppStrings.errorOccurred,
              onRetry: vm.loadHistory,
            ),
          TripHistoryStatus.empty => const Center(
              child: Text(AppStrings.noTripHistory),
            ),
          TripHistoryStatus.loaded ||
          TripHistoryStatus.loadingMore =>
            _buildList(vm),
        },
      ),
    );
  }

  Widget _buildList(TripHistoryViewModel vm) {
    return NotificationListener<ScrollNotification>(
      onNotification: (n) => _onScroll(n, vm),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: vm.entries.length + (vm.status == TripHistoryStatus.loadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == vm.entries.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: AppInlineLoading(),
            );
          }
          final entry = vm.entries[index];
          return TripHistoryCard(
            entry: entry,
            onTap: () => context.push(
              AppRoutes.tripHistoryDetail.replaceFirst(':tripId', entry.tripId),
            ),
          );
        },
      ),
    );
  }
}
