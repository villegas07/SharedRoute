import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/typedef.dart';
import '../../domain/entities/create_ticket_params.dart';
import '../../domain/entities/support_ticket_entity.dart';
import '../../domain/repositories/support_repository.dart';
import '../datasources/support_remote_datasource.dart';

class SupportRepositoryImpl implements SupportRepository {
  final SupportRemoteDataSource _remoteDataSource;

  const SupportRepositoryImpl(this._remoteDataSource);

  @override
  ResultVoid createTicket(CreateTicketParams params) async {
    try {
      await _remoteDataSource.createTicket(params);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception {
      return Left(const ServerFailure('Error al crear el ticket'));
    }
  }

  @override
  ResultFuture<List<SupportTicketEntity>> getMyTickets() async {
    try {
      final tickets = await _remoteDataSource.getMyTickets();
      return Right(tickets);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception {
      return Left(const ServerFailure('Error al cargar tickets'));
    }
  }

  @override
  ResultFuture<SupportTicketEntity> getTicketById(String id) async {
    try {
      final ticket = await _remoteDataSource.getTicketById(id);
      return Right(ticket);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception {
      return Left(const ServerFailure('Error al cargar el ticket'));
    }
  }
}
