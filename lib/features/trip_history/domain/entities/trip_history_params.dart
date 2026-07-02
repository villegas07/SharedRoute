import 'package:equatable/equatable.dart';

import 'trip_history_entry.dart';

class TripHistoryParams extends Equatable {
  final HistoryRole? role;
  final int page;
  final int pageSize;
  final String? fromDate;
  final String? toDate;
  final String? status;

  const TripHistoryParams({
    this.role,
    this.page = 1,
    this.pageSize = 10,
    this.fromDate,
    this.toDate,
    this.status,
  });

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{
      'page': page,
      'pageSize': pageSize,
    };
    if (role != null) {
      params['role'] = const {
        HistoryRole.passenger: 'PASSENGER',
        HistoryRole.driver: 'DRIVER',
      }[role] ?? 'PASSENGER';
    }
    if (fromDate != null) params['fromDate'] = fromDate;
    if (toDate != null) params['toDate'] = toDate;
    if (status != null) params['status'] = status;
    return params;
  }

  TripHistoryParams copyWithPage(int newPage) => TripHistoryParams(
        role: role,
        page: newPage,
        pageSize: pageSize,
        fromDate: fromDate,
        toDate: toDate,
        status: status,
      );

  @override
  List<Object?> get props => [role, page, pageSize, fromDate, toDate, status];
}
