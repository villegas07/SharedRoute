import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/rating_summary_entity.dart';
import '../viewmodels/user_reviews_viewmodel.dart';
import '../widgets/star_rating_widget.dart';

class UserReviewsView extends StatefulWidget {
  final String userId;

  const UserReviewsView({super.key, required this.userId});

  @override
  State<UserReviewsView> createState() => _UserReviewsViewState();
}

class _UserReviewsViewState extends State<UserReviewsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<UserReviewsViewModel>().loadReviews(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.myReviews)),
      body: Consumer<UserReviewsViewModel>(
        builder: (context, vm, _) => switch (vm.status) {
          UserReviewsStatus.initial ||
          UserReviewsStatus.loading =>
            const AppInlineLoading(),
          UserReviewsStatus.error => AppErrorState(
              message: vm.errorMessage ?? AppStrings.errorOccurred,
              onRetry: () => vm.loadReviews(widget.userId),
            ),
          UserReviewsStatus.empty => const Center(
              child: Text('Sin reseñas aún'),
            ),
          UserReviewsStatus.loaded => _SummaryContent(summary: vm.summary!),
        },
      ),
    );
  }
}

class _SummaryContent extends StatelessWidget {
  final RatingSummaryEntity summary;

  const _SummaryContent({required this.summary});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SummaryCard(summary: summary),
          const SizedBox(height: 16),
          _BreakdownCard(breakdown: summary.breakdown),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final RatingSummaryEntity summary;

  const _SummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              summary.averageRating.toStringAsFixed(1),
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            StarRatingWidget(
              rating: summary.averageRating.round(),
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              '${summary.totalReviews} reseñas',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  final Map<int, int> breakdown;

  const _BreakdownCard({required this.breakdown});

  @override
  Widget build(BuildContext context) {
    final total = breakdown.values.fold(0, (a, b) => a + b);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: List.generate(5, (i) {
            final star = 5 - i;
            final count = breakdown[star] ?? 0;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Text('$star', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(width: 4),
                  const Icon(Icons.star, size: 14),
                  const SizedBox(width: 8),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: total > 0 ? count / total : 0,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('$count', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
