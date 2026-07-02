import 'package:flutter/material.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/rating_summary_entity.dart';
import '../../domain/usecases/get_user_reviews_usecase.dart';

enum UserReviewsStatus { initial, loading, loaded, empty, error }

class UserReviewsViewModel extends ChangeNotifier {
  final GetUserReviewsUseCase _useCase;

  UserReviewsStatus _status = UserReviewsStatus.initial;
  RatingSummaryEntity? _summary;
  String? _errorMessage;

  UserReviewsStatus get status => _status;
  RatingSummaryEntity? get summary => _summary;
  String? get errorMessage => _errorMessage;

  UserReviewsViewModel(this._useCase);

  Future<void> loadReviews(String userId) async {
    _setStatus(UserReviewsStatus.loading);
    final result = await _useCase(userId);
    result.fold(_handleFailure, _handleSuccess);
  }

  void _handleSuccess(RatingSummaryEntity data) {
    _summary = data;
    _errorMessage = null;
    _setStatus(data.totalReviews == 0
        ? UserReviewsStatus.empty
        : UserReviewsStatus.loaded);
  }

  void _handleFailure(Failure failure) {
    _errorMessage = failure.message;
    _setStatus(UserReviewsStatus.error);
  }

  void _setStatus(UserReviewsStatus s) {
    _status = s;
    notifyListeners();
  }
}
