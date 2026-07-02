import 'package:flutter/material.dart';

import '../../domain/entities/geocoded_address_entity.dart';
import '../../domain/entities/place_prediction_entity.dart';
import '../../domain/usecases/get_place_details_usecase.dart';
import '../../domain/usecases/search_places_usecase.dart';

enum PlacesStatus { idle, searching, loaded, error }

class PlacesViewModel extends ChangeNotifier {
  final SearchPlacesUseCase _searchPlacesUseCase;
  final GetPlaceDetailsUseCase _getPlaceDetailsUseCase;

  PlacesViewModel(this._searchPlacesUseCase, this._getPlaceDetailsUseCase);

  PlacesStatus _status = PlacesStatus.idle;
  List<PlacePredictionEntity> _predictions = [];
  GeocodedAddressEntity? _selectedAddress;

  PlacesStatus get status => _status;
  List<PlacePredictionEntity> get predictions => _predictions;
  GeocodedAddressEntity? get selectedAddress => _selectedAddress;
  bool get isSearching => _status == PlacesStatus.searching;

  Future<void> searchPlaces(String query) async {
    if (query.length < 2) {
      clearPredictions();
      return;
    }
    _setStatus(PlacesStatus.searching);
    final result = await _searchPlacesUseCase(query);
    result.fold(
      (_) => _setStatus(PlacesStatus.error),
      (predictions) {
        _predictions = predictions;
        _setStatus(PlacesStatus.loaded);
      },
    );
  }

  Future<GeocodedAddressEntity?> selectPlace(String placeId) async {
    final result = await _getPlaceDetailsUseCase(placeId);
    return result.fold((_) => null, (address) {
      _selectedAddress = address;
      clearPredictions();
      return address;
    });
  }

  void clearPredictions() {
    _predictions = [];
    _setStatus(PlacesStatus.idle);
  }

  void _setStatus(PlacesStatus s) {
    _status = s;
    notifyListeners();
  }
}
