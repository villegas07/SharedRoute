import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/api_constants.dart';

abstract class TokenService {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> saveTokens(String access, String refresh);
  Future<void> clearTokens();
  Future<bool> hasValidToken();
}

class TokenServiceImpl implements TokenService {
  final FlutterSecureStorage _storage;

  const TokenServiceImpl(this._storage);

  @override
  Future<String?> getAccessToken() =>
      _storage.read(key: StorageKeys.accessToken);

  @override
  Future<String?> getRefreshToken() =>
      _storage.read(key: StorageKeys.refreshToken);

  @override
  Future<void> saveTokens(String access, String refresh) async {
    await _storage.write(key: StorageKeys.accessToken, value: access);
    await _storage.write(key: StorageKeys.refreshToken, value: refresh);
  }

  @override
  Future<void> clearTokens() async {
    await _storage.delete(key: StorageKeys.accessToken);
    await _storage.delete(key: StorageKeys.refreshToken);
  }

  @override
  Future<bool> hasValidToken() async {
    final token = await getAccessToken();
    return token != null;
  }
}
