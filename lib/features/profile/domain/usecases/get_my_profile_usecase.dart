import '../../../../core/utils/typedef.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetMyProfileUseCase {
  final UserRepository _repository;

  const GetMyProfileUseCase(this._repository);

  ResultFuture<UserEntity> call() => _repository.getMyProfile();
}
