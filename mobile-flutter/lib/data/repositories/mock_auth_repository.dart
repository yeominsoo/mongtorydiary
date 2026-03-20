import 'package:mongtory_diary/data/datasources/mock/mock_auth_datasource.dart';
import 'package:mongtory_diary/data/mappers/auth_mapper.dart';
import 'package:mongtory_diary/domain/models/auth_session.dart';
import 'package:mongtory_diary/domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  const MockAuthRepository(this._dataSource);

  final MockAuthDataSource _dataSource;

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    final dto = await _dataSource.signIn(email: email, password: password);
    return AuthMapper.toDomain(dto);
  }
}
