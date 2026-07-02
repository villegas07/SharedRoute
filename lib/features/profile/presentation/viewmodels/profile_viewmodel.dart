import 'package:flutter/material.dart';

import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/usecases/get_my_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';

enum ProfileStatus { initial, loading, loaded, saving, saved, error }

class ProfileViewModel extends ChangeNotifier {
  final GetMyProfileUseCase _getMyProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  ProfileViewModel(this._getMyProfileUseCase, this._updateProfileUseCase);

  ProfileStatus _status = ProfileStatus.initial;
  UserEntity? _user;
  String? _errorMessage;

  ProfileStatus get status => _status;
  UserEntity? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == ProfileStatus.loading;
  bool get isSaving => _status == ProfileStatus.saving;

  Future<void> loadProfile() async {
    _setStatus(ProfileStatus.loading);
    final result = await _getMyProfileUseCase();
    result.fold(_handleFailure, _handleLoadSuccess);
  }

  Future<void> updateProfile(String id, Map<String, dynamic> data) async {
    _setStatus(ProfileStatus.saving);
    final result = await _updateProfileUseCase(id, data);
    result.fold(_handleFailure, _handleSaveSuccess);
  }

  void _handleLoadSuccess(UserEntity user) {
    _user = user;
    _errorMessage = null;
    _setStatus(ProfileStatus.loaded);
  }

  void _handleSaveSuccess(UserEntity user) {
    _user = user;
    _errorMessage = null;
    _setStatus(ProfileStatus.saved);
  }

  void _handleFailure(Failure failure) {
    _errorMessage = failure.message;
    _setStatus(ProfileStatus.error);
  }

  void _setStatus(ProfileStatus s) {
    _status = s;
    notifyListeners();
  }
}
