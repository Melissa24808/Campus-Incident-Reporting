import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/validators.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.register(
      _nameCtrl.text,
      _emailCtrl.text,
      _passwordCtrl.text,
    );
    if (!mounted) return;
    if (ok) {
      // Return to the root screen, which now routes signed-in users directly.
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error ?? 'Registration failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<AuthProvider>().loading;

    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppTextField(
                      controller: _nameCtrl,
                      label: 'Full name',
                      icon: Icons.badge_outlined,
                      hintText: 'Enter your full name',
                      fillColor: Colors.white,
                      focusedBorderColor: AppTheme.primary,
                      prefixIconColor: AppTheme.secondary,
                      borderRadius: 18,
                      autofillHints: const [AutofillHints.name],
                      textInputAction: TextInputAction.next,
                      validator: (v) => Validators.minLength(v, 'Name', 2),
                    ),
                    const SizedBox(height: 16),
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
                      hintText: 'Create a password',
                      fillColor: Colors.white,
                      focusedBorderColor: AppTheme.primary,
                      prefixIconColor: AppTheme.secondary,
                      borderRadius: 18,
                      obscure: true,
                      autofillHints: const [AutofillHints.newPassword],
                      textInputAction: TextInputAction.next,
                      validator: Validators.password,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _confirmCtrl,
                      label: 'Confirm password',
                      icon: Icons.password_rounded,
                      hintText: 'Re-enter your password',
                      fillColor: Colors.white,
                      focusedBorderColor: AppTheme.primary,
                      prefixIconColor: AppTheme.secondary,
                      borderRadius: 18,
                      obscure: true,
                      autofillHints: const [AutofillHints.newPassword],
                      textInputAction: TextInputAction.done,
                      validator: (v) => v != _passwordCtrl.text
                          ? 'Passwords do not match'
                          : null,
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: 'Register',
                      onPressed: _submit,
                      loading: loading,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
