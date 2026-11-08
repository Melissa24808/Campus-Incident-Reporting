import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/incident_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main_shell.dart';
import 'services/auth_service.dart';
import 'services/incident_service.dart';
import 'utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const CampusIncidentApp());
}

class CampusIncidentApp extends StatelessWidget {
  const CampusIncidentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(AuthService())),
        ChangeNotifierProxyProvider<AuthProvider, IncidentProvider>(
          create: (_) => IncidentProvider(IncidentService()),
          update: (_, auth, incidents) {
            incidents!.onAuthChanged(auth.isLoggedIn);
            return incidents;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Campus Incident Reporter',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const AuthGate(),
      ),
    );
  }
}

/// Decides which screen to show based on the authentication state.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.initializing) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (!auth.isLoggedIn) return const LoginScreen();
    return const MainShell();
  }
}
