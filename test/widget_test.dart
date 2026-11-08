import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campus_incident_app/utils/app_theme.dart';
import 'package:campus_incident_app/utils/constants.dart';
import 'package:campus_incident_app/utils/validators.dart';

void main() {
  group('App theme', () {
    test('uses the configured primary and secondary colors', () {
      expect(AppTheme.light.colorScheme.primary, const Color(0xFF7047F8));
      expect(AppTheme.light.colorScheme.secondary, const Color(0xFF182443));
      expect(AppTheme.light.colorScheme.onPrimary, Colors.white);
    });
  });

  group('Email validator', () {
    test('rejects empty email', () {
      expect(Validators.email(''), isNotNull);
    });

    test('rejects badly formatted email', () {
      expect(Validators.email('notanemail'), isNotNull);
    });

    test('rejects non-ALU email', () {
      expect(Validators.email('someone@gmail.com'), isNotNull);
    });

    test('accepts ALU student email', () {
      expect(Validators.email('maxime@alustudent.com'), isNull);
    });

    test('accepts staff email', () {
      expect(Validators.email('staff@alueducation.com'), isNull);
    });

    test('rejects the legacy ALU domain', () {
      expect(Validators.email('someone@alu.edu'), isNotNull);
    });
  });

  group('Email domain roles', () {
    test('maps student and staff domains to their roles', () {
      expect(
        AllowedEmailDomains.roleFor('student@alustudent.com'),
        UserRole.student,
      );
      expect(
        AllowedEmailDomains.roleFor('staff@alueducation.com'),
        UserRole.staff,
      );
    });

    test('rejects unknown domains', () {
      expect(AllowedEmailDomains.roleFor('person@example.com'), isNull);
    });
  });

  group('Password validator', () {
    test('rejects short password', () {
      expect(Validators.password('123'), isNotNull);
    });

    test('accepts valid password', () {
      expect(Validators.password('secret123'), isNull);
    });
  });

  group('Required validator', () {
    test('rejects blank text', () {
      expect(Validators.required('   ', 'Title'), 'Title is required');
    });
  });
}
