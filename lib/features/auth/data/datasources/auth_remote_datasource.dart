import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(String email, String password) async {
    // TODO: Replace with real HTTP call (e.g., Dio)
    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || password.isEmpty) {
      throw const AuthException('Credenciales incorrectas');
    }

    return UserModel(id: '1', name: 'Usuario Demo', email: email);
  }
}
