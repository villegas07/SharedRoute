import '../../../../core/utils/typedef.dart';
import '../entities/create_review_params.dart';
import '../repositories/review_repository.dart';

class CreateReviewUseCase {
  final ReviewRepository _repository;

  const CreateReviewUseCase(this._repository);

  ResultVoid call(CreateReviewParams params) => _repository.createReview(params);
}
