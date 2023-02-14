import '../../../../core/common/responses/response.dart';
import '../../repositories/repository.dart';

class UserGetUseCase {
  final Repository repository;

  UserGetUseCase({
    required this.repository,
  });

  Future<Response> call({
    required String uid,
  }) async {
    return repository.get(uid);
  }
}
