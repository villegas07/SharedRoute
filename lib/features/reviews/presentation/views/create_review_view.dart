import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/create_review_params.dart';
import '../viewmodels/create_review_viewmodel.dart';
import '../widgets/star_rating_widget.dart';

class CreateReviewView extends StatefulWidget {
  final String tripId;

  const CreateReviewView({super.key, required this.tripId});

  @override
  State<CreateReviewView> createState() => _CreateReviewViewState();
}

class _CreateReviewViewState extends State<CreateReviewView> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.leaveReview),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<CreateReviewViewModel>(
        builder: (context, vm, _) {
          if (vm.status == CreateReviewStatus.success) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text(AppStrings.reviewSent)),
              );
              context.pop();
            });
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppStrings.rating,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                Center(
                  child: StarRatingWidget(
                    rating: vm.selectedRating,
                    size: 48,
                    onChanged: vm.setRating,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.reviewComment,
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                if (vm.errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    vm.errorMessage!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.red),
                  ),
                ],
                const Spacer(),
                AppButton(
                  label: AppStrings.leaveReview,
                  isLoading: vm.isLoading,
                  onPressed: () => _submit(vm),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _submit(CreateReviewViewModel vm) {
    final comment = _commentController.text.trim();
    vm.submit(CreateReviewParams(
      tripId: widget.tripId,
      driverId: '',
      rating: vm.selectedRating,
      comment: comment.isEmpty ? null : comment,
    ));
  }
}
