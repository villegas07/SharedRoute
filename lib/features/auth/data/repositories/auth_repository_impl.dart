import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/token_service.dart';
import '../../../../core/utils/typedef.dart';
import '../../domain/entities/register_params.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final TokenService _tokenService;

  const AuthRepositoryImpl(this._remoteDataSource, this._tokenService);

  @override
  ResultFuture<UserEntity> login(String email, String password) async {
    try {
      final response = await _remoteDataSource.login(email, password);
      final accessToken = response.accessToken;
      final refreshToken = response.refreshToken;
      if (accessToken != null && refreshToken != null) {
        await _tokenService.saveTokens(accessToken, refreshToken);
      }
      return Right(response.user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception {
      return Left(const ServerFailure('Error de servidor'));
    }
  }

  @override
  ResultFuture<UserEntity> register(RegisterParams params) async {
    try {
      final response = await _remoteDataSource.register(params);
      final accessToken = response.accessToken;
      final refreshToken = response.refreshToken;
      if (accessToken != null && refreshToken != null) {
        await _tokenService.saveTokens(accessToken, refreshToken);
      }
      return Right(response.user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception {
      return Left(const ServerFailure('Error de servidor'));
    }
  }

  @override
  ResultVoid logout() async {
    try {
      final token = await _tokenService.getRefreshToken();
      if (token != null) await _remoteDataSource.logout(token);
      await _tokenService.clearTokens();
      return const Right(null);
    } on Exception {
      return Left(const ServerFailure('Error al cerrar sesión'));
    }
  }

  @override
  ResultVoid forgotPassword(String email) async {
    try {
      await _remoteDataSource.forgotPassword(email);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception {
      return Left(const ServerFailure('Error de servidor'));
    }
  }
}
