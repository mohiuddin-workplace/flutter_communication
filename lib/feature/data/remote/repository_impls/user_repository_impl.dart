import '../../../../core/common/data_sources/firebase_data_source.dart';
import '../../../../core/common/data_sources/keep_user_data_source.dart';
import '../../../../core/common/responses/response.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/repository.dart';

class UserRepositoryImpl extends Repository<UserEntity> {
  final LocalDataSource local;
  final FirebaseDataSource remote;

  UserRepositoryImpl({
    required this.local,
    required this.remote,
  });

  @override
  Future<Response> create(UserEntity entity) {
    return remote.insert(entity.uid ?? '', entity.map);
  }

  @override
  Future<Response> update(String id, Map<String, dynamic> map) {
    return remote.update(id, map);
  }

  @override
  Future<Response> delete(String id) {
    return remote.delete(id);
  }

  @override
  Future<Response> get(String id) {
    return remote.get(id);
  }

  @override
  Future<Response> gets() {
    return remote.gets();
  }

  @override
  Future<Response> setCache(UserEntity entity) {
    return local.insert(entity);
  }

  @override
  Future<Response> removeCache(String id) {
    return local.remove(id);
  }

  @override
  Future<Response> getCache(String id) {
    return local.get(id);
  }
}
