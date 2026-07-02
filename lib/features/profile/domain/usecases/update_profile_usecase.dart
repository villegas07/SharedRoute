import '../../../../core/utils/typedef.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../repositories/user_repository.dart';

class UpdateProfileUseCase {
  final UserRepository _repository;

  const UpdateProfileUseCase(this._repository);

  ResultFuture<UserEntity> call(String id, Map<String, dynamic> data) =>
      _repository.updateProfile(id, data);
}
