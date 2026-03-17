import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isSupported = await _auth.isDeviceSupported();

      if (!canCheck || !isSupported) {
        return false;
      }

      final isAuthenticated = await _auth.authenticate(
        localizedReason: 'Authenticate to login',
        biometricOnly: false,
      );

      return isAuthenticated;
    } catch (e) {
      return false;
    }
  }
}
