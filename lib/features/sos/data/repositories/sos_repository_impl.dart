import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/typedef.dart';
import '../../domain/entities/add_contact_params.dart';
import '../../domain/entities/emergency_contact_entity.dart';
import '../../domain/repositories/sos_repository.dart';
import '../datasources/sos_remote_datasource.dart';

class SosRepositoryImpl implements SosRepository {
  final SosRemoteDataSource _remoteDataSource;

  const SosRepositoryImpl(this._remoteDataSource);

  @override
  ResultVoid addEmergencyContact(AddContactParams params) async {
    try {
      await _remoteDataSource.addEmergencyContact(params);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception {
      return Left(const ServerFailure('Error al agregar contacto'));
    }
  }

  @override
  ResultFuture<List<EmergencyContactEntity>> getEmergencyContacts() async {
    try {
      final contacts = await _remoteDataSource.getEmergencyContacts();
      return Right(contacts);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception {
      return Left(const ServerFailure('Error al cargar contactos'));
    }
  }

  @override
  ResultVoid deleteEmergencyContact(String id) async {
    try {
      await _remoteDataSource.deleteEmergencyContact(id);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception {
      return Left(const ServerFailure('Error al eliminar contacto'));
    }
  }

  @override
  ResultVoid triggerAlert() async {
    try {
      await _remoteDataSource.triggerAlert();
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception {
      return Left(const ServerFailure('Error al enviar alerta'));
    }
  }
}
