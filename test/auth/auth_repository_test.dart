import 'package:flutter_test/flutter_test.dart';
import 'package:logiks_solutions/features/auth/data/auth_repository_impl.dart';

void main() {
  late AuthRepositoryImpl repository;

  setUp(() {
    repository = AuthRepositoryImpl();
  });

  group('AuthRepository Tests', () {
    test('should return true for correct credentials', () async {
      final result = await repository.login('test', 'test123');

      expect(result, true);
    });

    test('should return false for incorrect credentials', () async {
      final result = await repository.login('wrong', 'wrong');

      expect(result, false);
    });
  });
}
