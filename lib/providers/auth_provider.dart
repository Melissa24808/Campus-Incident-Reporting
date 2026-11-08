import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service;
  StreamSubscription<User?>? _sub;

  User? _firebaseUser;
  AppUser? _appUser;
  bool _initializing = true;
  bool _loading = false;
  String? _error;

  AuthProvider(this._service) {
    _sub = _service.authChanges.listen(_onAuthChanged);
  }

  User? get firebaseUser => _firebaseUser;
  AppUser? get appUser => _appUser;
  bool get initializing => _initializing;
  bool get loading => _loading;
  String? get error => _error;

  bool get isLoggedIn => _firebaseUser != null;
  bool get isStaff => _appUser?.isStaff ?? false;

  Future<void> _onAuthChanged(User? user) async {
    _firebaseUser = user;
    if (user == null) {
      _appUser = null;
    } else {
      await _loadAppUser(user);
    }
    _initializing = false;
    notifyListeners();
  }

  Future<void> _loadAppUser(User user) async {
    final storedUser = await _service.fetchAppUser(user.uid);
    final email = user.email ?? '';
    _appUser = AppUser(
      uid: user.uid,
      email: email,
      name: storedUser?.name ?? user.displayName ?? '',
      role: AllowedEmailDomains.roleFor(email) ?? UserRole.student,
    );
  }

  Future<bool> register(String name, String email, String password) async {
    final ok = await _run(
      () => _service.register(name: name, email: email, password: password),
    );
    if (ok && _service.currentUser != null) {
      await _loadAppUser(_service.currentUser!);
      notifyListeners();
    }
    return ok;
  }

  Future<bool> login(String email, String password) =>
      _run(() => _service.login(email, password));

  Future<void> logout() => _service.logout();

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<bool> _run(Future<void> Function() action) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await action();
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _friendlyMessage(e.code);
      return false;
    } catch (_) {
      _error = 'Something went wrong. Please try again.';
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  String _friendlyMessage(String code) {
    switch (code) {
      case 'invalid-domain':
        return 'Use an @${AllowedEmailDomains.student} or '
            '@${AllowedEmailDomains.staff} email address.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Incorrect email or password.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'network-request-failed':
        return 'No internet connection.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
