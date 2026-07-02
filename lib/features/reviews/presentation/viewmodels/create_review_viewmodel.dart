import 'package:flutter/material.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/create_review_params.dart';
import '../../domain/usecases/create_review_usecase.dart';

enum CreateReviewStatus { initial, loading, success, error }

class CreateReviewViewModel extends ChangeNotifier {
  final CreateReviewUseCase _useCase;

  CreateReviewStatus _status = CreateReviewStatus.initial;
  int _selectedRating = 5;
  String? _errorMessage;

  CreateReviewStatus get status => _status;
  int get selectedRating => _selectedRating;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == CreateReviewStatus.loading;

  CreateReviewViewModel(this._useCase);

  void setRating(int rating) {
    _selectedRating = rating;
    notifyListeners();
  }

  Future<void> submit(CreateReviewParams params) async {
    _setStatus(CreateReviewStatus.loading);
    final result = await _useCase(params);
    result.fold(_handleFailure, (_) => _handleSuccess());
  }

  void _handleSuccess() {
    _errorMessage = null;
    _setStatus(CreateReviewStatus.success);
  }

  void _handleFailure(Failure failure) {
    _errorMessage = failure.message;
    _setStatus(CreateReviewStatus.error);
  }

  void _setStatus(CreateReviewStatus s) {
    _status = s;
    notifyListeners();
  }
}
