import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logiks_solutions/features/products/presentation/screens/products_screen.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),

            if (state.error != null)
              Text(state.error!, style: const TextStyle(color: Colors.red)),

            ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () async {
                      final success = await ref
                          .read(authProvider.notifier)
                          .login(
                            usernameController.text,
                            passwordController.text,
                          );

                      if (success && context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProductsScreen(),
                          ),
                        );
                      }
                    },
              child: state.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Login'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () async {
                      final success = await ref
                          .read(authProvider.notifier)
                          .loginWithBiometrics();

                      if (success && context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const Placeholder(),
                          ),
                        );
                      }
                    },
              child: const Text('Login with Biometrics'),
            ),
          ],
        ),
      ),
    );
  }
}
