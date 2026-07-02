import 'package:flutter/material.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/trip_history_entry.dart';
import '../../domain/entities/trip_history_params.dart';
import '../../domain/usecases/get_trip_history_usecase.dart';

enum TripHistoryStatus { initial, loading, loadingMore, loaded, empty, error }

class TripHistoryViewModel extends ChangeNotifier {
  final GetTripHistoryUseCase _getHistoryUseCase;

  TripHistoryStatus _status = TripHistoryStatus.initial;
  List<TripHistoryEntry> _entries = [];
  String? _errorMessage;
  int _page = 1;
  bool _hasMore = true;
  TripHistoryParams _lastParams = const TripHistoryParams();

  TripHistoryStatus get status => _status;
  List<TripHistoryEntry> get entries => _entries;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  bool get isLoading => _status == TripHistoryStatus.loading;

  TripHistoryViewModel(this._getHistoryUseCase);

  Future<void> loadHistory([TripHistoryParams? params]) async {
    _page = 1;
    _hasMore = true;
    _entries = [];
    _lastParams = params ?? const TripHistoryParams();
    _setStatus(TripHistoryStatus.loading);
    await _fetchPage();
  }

  Future<void> loadMore() async {
    if (!_hasMore || _status == TripHistoryStatus.loadingMore) return;
    _page++;
    _setStatus(TripHistoryStatus.loadingMore);
    await _fetchPage();
  }

  Future<void> _fetchPage() async {
    final pageParams = _lastParams.copyWithPage(_page);
    final result = await _getHistoryUseCase(pageParams);
    result.fold(_handleFailure, _handleSuccess);
  }

  void _handleSuccess(List<TripHistoryEntry> data) {
    if (data.length < _lastParams.pageSize) _hasMore = false;
    _entries = [..._entries, ...data];
    _errorMessage = null;
    _setStatus(_entries.isEmpty ? TripHistoryStatus.empty : TripHistoryStatus.loaded);
  }

  void _handleFailure(Failure failure) {
    if (_page > 1) _page--;
    _errorMessage = failure.message;
    _setStatus(TripHistoryStatus.error);
  }

  void _setStatus(TripHistoryStatus s) {
    _status = s;
    notifyListeners();
  }
}
