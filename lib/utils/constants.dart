import 'package:flutter/material.dart';

class UserRole {
  static const student = 'student';
  static const staff = 'staff';
}

class IncidentStatus {
  static const submitted = 'Submitted';
  static const inReview = 'In Review';
  static const inProgress = 'In Progress';
  static const resolved = 'Resolved';

  static const all = [submitted, inReview, inProgress, resolved];
}

class IncidentCategory {
  static const all = [
    'Water',
    'Electricity',
    'Furniture',
    'Sanitation',
    'Safety',
    'Facilities',
  ];

  static IconData iconFor(String category) {
    switch (category) {
      case 'Water':
        return Icons.water_drop_outlined;
      case 'Electricity':
        return Icons.electric_bolt_rounded;
      case 'Furniture':
        return Icons.chair_alt_rounded;
      case 'Sanitation':
        return Icons.delete_sweep_outlined;
      case 'Safety':
        return Icons.health_and_safety_outlined;
      default:
        return Icons.domain_rounded;
    }
  }

  static Color colorFor(String category) {
    switch (category) {
      case 'Water':
        return const Color(0xFF159BD7);
      case 'Electricity':
        return const Color(0xFFF59E0B);
      case 'Furniture':
        return const Color(0xFFB7791F);
      case 'Sanitation':
        return const Color(0xFF10A981);
      case 'Safety':
        return const Color(0xFFEF4B55);
      default:
        return const Color(0xFF6D63E8);
    }
  }
}

class AllowedEmailDomains {
  static const student = 'alustudent.com';
  static const staff = 'alueducation.com';
  static const all = [student, staff];

  static String? roleFor(String email) {
    final normalized = email.trim().toLowerCase();
    final separator = normalized.lastIndexOf('@');
    if (separator <= 0 || separator != normalized.indexOf('@')) return null;

    switch (normalized.substring(separator + 1)) {
      case student:
        return UserRole.student;
      case staff:
        return UserRole.staff;
      default:
        return null;
    }
  }
}

class CloudinaryConfig {
  static const cloudName = 'k89apvri';
  static const uploadPreset = 'campus-incident-maxime-2026';
}
