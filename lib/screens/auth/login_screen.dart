import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../utils/validators.dart';
import '../../utils/app_theme.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(_emailCtrl.text, _passwordCtrl.text);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(auth.error ?? 'Login failed')));
    }
    // On success, AuthGate rebuilds automatically.
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<AuthProvider>().loading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Welcome back',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  const Text('Sign in to report and follow campus incidents'),
                  const SizedBox(height: 32),
                  AppTextField(
                    controller: _emailCtrl,
                    label: 'ALU email',
                    icon: Icons.alternate_email_rounded,
                    hintText: 'you@alustudent.com',
                    fillColor: Colors.white,
                    focusedBorderColor: AppTheme.primary,
                    prefixIconColor: AppTheme.secondary,
                    borderRadius: 18,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    textInputAction: TextInputAction.next,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _passwordCtrl,
                    label: 'Password',
                    icon: Icons.key_rounded,
                    hintText: 'Enter your password',
                    fillColor: Colors.white,
                    focusedBorderColor: AppTheme.primary,
                    prefixIconColor: AppTheme.secondary,
                    borderRadius: 18,
                    obscure: true,
                    autofillHints: const [AutofillHints.password],
                    textInputAction: TextInputAction.done,
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: 'Log in',
                    onPressed: _submit,
                    loading: loading,
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    ),
                    child: const Text("Don't have an account? Register"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
