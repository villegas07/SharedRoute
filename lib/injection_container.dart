import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'core/network/dio_client.dart';
import 'core/services/token_service.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/check_auth_usecase.dart';
import 'features/auth/domain/usecases/forgot_password_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'features/auth/presentation/viewmodels/forgot_password_viewmodel.dart';
import 'features/auth/presentation/viewmodels/register_viewmodel.dart';
import 'features/bookings/data/datasources/booking_remote_datasource.dart';
import 'features/bookings/data/repositories/booking_repository_impl.dart';
import 'features/bookings/domain/repositories/booking_repository.dart';
import 'features/bookings/domain/usecases/cancel_booking_usecase.dart';
import 'features/bookings/domain/usecases/create_booking_usecase.dart';
import 'features/bookings/domain/usecases/get_my_bookings_usecase.dart';
import 'features/bookings/presentation/viewmodels/booking_viewmodel.dart';
import 'features/bookings/presentation/viewmodels/bookings_list_viewmodel.dart';
import 'features/geolocation/data/datasources/geolocation_remote_datasource.dart';
import 'features/geolocation/data/repositories/geolocation_repository_impl.dart';
import 'features/geolocation/domain/repositories/geolocation_repository.dart';
import 'features/geolocation/domain/usecases/get_place_details_usecase.dart';
import 'features/geolocation/domain/usecases/search_places_usecase.dart';
import 'features/geolocation/presentation/viewmodels/places_viewmodel.dart';
import 'features/profile/data/datasources/user_remote_datasource.dart';
import 'features/profile/data/repositories/user_repository_impl.dart';
import 'features/profile/domain/repositories/user_repository.dart';
import 'features/profile/domain/usecases/get_my_profile_usecase.dart';
import 'features/profile/domain/usecases/update_profile_usecase.dart';
import 'features/profile/presentation/viewmodels/profile_viewmodel.dart';
import 'features/reviews/data/datasources/review_remote_datasource.dart';
import 'features/reviews/data/repositories/review_repository_impl.dart';
import 'features/reviews/domain/repositories/review_repository.dart';
import 'features/reviews/domain/usecases/create_review_usecase.dart';
import 'features/reviews/domain/usecases/get_user_reviews_usecase.dart';
import 'features/reviews/presentation/viewmodels/create_review_viewmodel.dart';
import 'features/reviews/presentation/viewmodels/user_reviews_viewmodel.dart';
import 'features/sos/data/datasources/sos_remote_datasource.dart';
import 'features/sos/data/repositories/sos_repository_impl.dart';
import 'features/sos/domain/repositories/sos_repository.dart';
import 'features/sos/domain/usecases/add_emergency_contact_usecase.dart';
import 'features/sos/domain/usecases/delete_emergency_contact_usecase.dart';
import 'features/sos/domain/usecases/get_emergency_contacts_usecase.dart';
import 'features/sos/domain/usecases/trigger_sos_alert_usecase.dart';
import 'features/sos/presentation/viewmodels/add_contact_viewmodel.dart';
import 'features/sos/presentation/viewmodels/sos_viewmodel.dart';
import 'features/support/data/datasources/support_remote_datasource.dart';
import 'features/support/data/repositories/support_repository_impl.dart';
import 'features/support/domain/repositories/support_repository.dart';
import 'features/support/domain/usecases/create_ticket_usecase.dart';
import 'features/support/domain/usecases/get_my_tickets_usecase.dart';
import 'features/support/domain/usecases/get_ticket_detail_usecase.dart';
import 'features/support/presentation/viewmodels/create_ticket_viewmodel.dart';
import 'features/support/presentation/viewmodels/ticket_detail_viewmodel.dart';
import 'features/support/presentation/viewmodels/tickets_list_viewmodel.dart';
import 'features/trip_history/data/datasources/trip_history_remote_datasource.dart';
import 'features/trip_history/data/repositories/trip_history_repository_impl.dart';
import 'features/trip_history/domain/repositories/trip_history_repository.dart';
import 'features/trip_history/domain/usecases/get_trip_history_detail_usecase.dart';
import 'features/trip_history/domain/usecases/get_trip_history_usecase.dart';
import 'features/trip_history/presentation/viewmodels/trip_history_detail_viewmodel.dart';
import 'features/trip_history/presentation/viewmodels/trip_history_viewmodel.dart';
import 'features/trips/data/datasources/trip_remote_datasource.dart';
import 'features/trips/data/repositories/trip_repository_impl.dart';
import 'features/trips/domain/repositories/trip_repository.dart';
import 'features/trips/domain/usecases/get_trip_detail_usecase.dart';
import 'features/trips/domain/usecases/search_trips_usecase.dart';
import 'features/trips/presentation/viewmodels/trip_detail_viewmodel.dart';
import 'features/trips/presentation/viewmodels/trip_search_viewmodel.dart';

final GetIt sl = GetIt.instance;

Future<void> setupDependencies() async {
  await _registerCore();
  _registerAuth();
  _registerTrips();
  _registerBookings();
  _registerGeolocation();
  _registerProfile();
  _registerTripHistory();
  _registerReviews();
  _registerSos();
  _registerSupport();
}

Future<void> _registerCore() async {
  const storage = FlutterSecureStorage();
  sl.registerLazySingleton<TokenService>(() => TokenServiceImpl(storage));
  sl.registerLazySingleton(() => DioClient(sl<TokenService>()));
}

void _registerAuth() {
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthUseCase(sl()));
  sl.registerFactory(
    () => AuthViewModel(sl<LoginUseCase>(), sl<LogoutUseCase>(),
        sl<CheckAuthUseCase>()),
  );
  sl.registerFactory(() => RegisterViewModel(sl()));
  sl.registerFactory(() => ForgotPasswordViewModel(sl()));
}

void _registerTrips() {
  sl.registerLazySingleton<TripRemoteDataSource>(
    () => TripRemoteDataSourceImpl(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<TripRepository>(
    () => TripRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => SearchTripsUseCase(sl()));
  sl.registerLazySingleton(() => GetTripDetailUseCase(sl()));
  sl.registerFactory(() => TripSearchViewModel(sl()));
  sl.registerFactory(() => TripDetailViewModel(sl()));
}

void _registerBookings() {
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => CreateBookingUseCase(sl()));
  sl.registerLazySingleton(() => GetMyBookingsUseCase(sl()));
  sl.registerLazySingleton(() => CancelBookingUseCase(sl()));
  sl.registerFactory(() => BookingViewModel(sl()));
  sl.registerFactory(
    () => BookingsListViewModel(sl<GetMyBookingsUseCase>(),
        sl<CancelBookingUseCase>()),
  );
}

void _registerGeolocation() {
  sl.registerLazySingleton<GeolocationRemoteDataSource>(
    () => GeolocationRemoteDataSourceImpl(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<GeolocationRepository>(
    () => GeolocationRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => SearchPlacesUseCase(sl()));
  sl.registerLazySingleton(() => GetPlaceDetailsUseCase(sl()));
  sl.registerFactory(
    () => PlacesViewModel(sl<SearchPlacesUseCase>(),
        sl<GetPlaceDetailsUseCase>()),
  );
}

void _registerProfile() {
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetMyProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerFactory(
    () => ProfileViewModel(sl<GetMyProfileUseCase>(),
        sl<UpdateProfileUseCase>()),
  );
}

void _registerTripHistory() {
  sl.registerLazySingleton<TripHistoryRemoteDataSource>(
    () => TripHistoryRemoteDataSourceImpl(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<TripHistoryRepository>(
    () => TripHistoryRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetTripHistoryUseCase(sl()));
  sl.registerLazySingleton(() => GetTripHistoryDetailUseCase(sl()));
  sl.registerFactory(() => TripHistoryViewModel(sl()));
  sl.registerFactory(() => TripHistoryDetailViewModel(sl()));
}

void _registerReviews() {
  sl.registerLazySingleton<ReviewRemoteDataSource>(
    () => ReviewRemoteDataSourceImpl(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<ReviewRepository>(
    () => ReviewRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => CreateReviewUseCase(sl()));
  sl.registerLazySingleton(() => GetUserReviewsUseCase(sl()));
  sl.registerFactory(() => CreateReviewViewModel(sl()));
  sl.registerFactory(() => UserReviewsViewModel(sl()));
}

void _registerSos() {
  sl.registerLazySingleton<SosRemoteDataSource>(
    () => SosRemoteDataSourceImpl(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<SosRepository>(
    () => SosRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => AddEmergencyContactUseCase(sl()));
  sl.registerLazySingleton(() => GetEmergencyContactsUseCase(sl()));
  sl.registerLazySingleton(() => DeleteEmergencyContactUseCase(sl()));
  sl.registerLazySingleton(() => TriggerSosAlertUseCase(sl()));
  sl.registerFactory(
    () => SosViewModel(sl<GetEmergencyContactsUseCase>(),
        sl<DeleteEmergencyContactUseCase>(), sl<TriggerSosAlertUseCase>()),
  );
  sl.registerFactory(() => AddContactViewModel(sl()));
}

void _registerSupport() {
  sl.registerLazySingleton<SupportRemoteDataSource>(
    () => SupportRemoteDataSourceImpl(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<SupportRepository>(
    () => SupportRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => CreateTicketUseCase(sl()));
  sl.registerLazySingleton(() => GetMyTicketsUseCase(sl()));
  sl.registerLazySingleton(() => GetTicketDetailUseCase(sl()));
  sl.registerFactory(() => TicketsListViewModel(sl()));
  sl.registerFactory(() => TicketDetailViewModel(sl()));
  sl.registerFactory(() => CreateTicketViewModel(sl()));
}

