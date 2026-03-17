import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/auth_repository_impl.dart';
import '../../data/biometric_service.dart';

final authRepositoryProvider = Provider((ref) => AuthRepositoryImpl());
final biometricServiceProvider = Provider((ref) => BiometricService());

class AuthState {
  final bool isLoading;
  final String? error;

  AuthState({this.isLoading = false, this.error});
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepositoryImpl repository;
  final BiometricService biometricService;

  AuthNotifier(this.repository, this.biometricService) : super(AuthState());

  Future<bool> login(String username, String password) async {
    state = AuthState(isLoading: true);

    final success = await repository.login(username, password);

    if (success) {
      state = AuthState();
      return true;
    } else {
      state = AuthState(error: 'Invalid credentials');
      return false;
    }
  }

  Future<bool> loginWithBiometrics() async {
    state = AuthState(isLoading: true);

    final success = await biometricService.authenticate();

    if (success) {
      state = AuthState();
      return true;
    } else {
      state = AuthState(error: 'Biometric authentication failed');
      return false;
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.read(authRepositoryProvider),
    ref.read(biometricServiceProvider),
  );
});
