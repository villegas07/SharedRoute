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
