import 'package:get_it/get_it.dart';

import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/presentation/viewmodels/auth_viewmodel.dart';

final GetIt sl = GetIt.instance;

void setupDependencies() {
  _registerDataSources();
  _registerRepositories();
  _registerUseCases();
  _registerViewModels();
}

void _registerDataSources() {
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
}

void _registerRepositories() {
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );
}

void _registerUseCases() {
  sl.registerLazySingleton(() => LoginUseCase(sl()));
}

void _registerViewModels() {
  sl.registerFactory(() => AuthViewModel(sl()));
}
