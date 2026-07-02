import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/typedef.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  const UserRepositoryImpl(this._remoteDataSource);

  @override
  ResultFuture<UserEntity> getMyProfile() async {
    try {
      final user = await _remoteDataSource.getMyProfile();
      return Right(user);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception {
      return Left(const ServerFailure('Error al cargar el perfil'));
    }
  }

  @override
  ResultFuture<UserEntity> updateProfile(String id, Map<String, dynamic> data) async {
    try {
      final user = await _remoteDataSource.updateProfile(id, data);
      return Right(user);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception {
      return Left(const ServerFailure('Error al actualizar el perfil'));
    }
  }
}
