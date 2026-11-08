import 'constants.dart';

class Validators {
  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final email = value.trim().toLowerCase();
    final basicFormat = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!basicFormat.hasMatch(email)) return 'Enter a valid email address';
    if (AllowedEmailDomains.roleFor(email) == null) {
      return 'Use an @${AllowedEmailDomains.student} or '
          '@${AllowedEmailDomains.staff} email address';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? minLength(String? value, String fieldName, int min) {
    final base = required(value, fieldName);
    if (base != null) return base;
    if (value!.trim().length < min) {
      return '$fieldName must be at least $min characters';
    }
    return null;
  }
}
