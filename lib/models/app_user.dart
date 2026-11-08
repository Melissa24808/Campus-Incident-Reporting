import '../utils/constants.dart';

class AppUser {
  final String uid;
  final String email;
  final String name;
  final String role;

  const AppUser({
    required this.uid,
    required this.email,
    required this.name,
    this.role = UserRole.student,
  });

  bool get isStaff => role == UserRole.staff;

  factory AppUser.fromMap(String uid, Map<String, dynamic> map) {
    return AppUser(
      uid: uid,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? UserRole.student,
    );
  }

  Map<String, dynamic> toMap() => {
        'email': email,
        'name': name,
        'role': role,
      };
}