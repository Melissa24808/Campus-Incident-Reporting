import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';
import '../utils/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> get authChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final role = AllowedEmailDomains.roleFor(cleanEmail);
    if (role == null) {
      throw FirebaseAuthException(code: 'invalid-domain');
    }

    final cred = await _auth.createUserWithEmailAndPassword(
      email: cleanEmail,
      password: password,
    );
    final user = cred.user!;
    await user.updateDisplayName(name.trim());

    final appUser = AppUser(
      uid: user.uid,
      email: cleanEmail,
      name: name.trim(),
      role: role,
    );
    await _db.collection('users').doc(user.uid).set(appUser.toMap());
  }

  Future<void> login(String email, String password) async {
    final cleanEmail = email.trim().toLowerCase();
    if (AllowedEmailDomains.roleFor(cleanEmail) == null) {
      throw FirebaseAuthException(code: 'invalid-domain');
    }
    await _auth.signInWithEmailAndPassword(
      email: cleanEmail,
      password: password,
    );
  }

  Future<void> logout() => _auth.signOut();

  Future<AppUser?> fetchAppUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(uid, doc.data()!);
  }
}
