import 'package:logiks_solutions/features/auth/domain/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<bool> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (username == 'test' && password == 'test123') {
      return true;
    } else {
      return false;
    }
  }
}
