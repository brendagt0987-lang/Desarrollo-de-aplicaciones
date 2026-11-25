import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import 'screens/feed_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

/// Avisa al router cada vez que la sesión cambia (login o logout),
/// para que vuelva a evaluar el redirect.
class _AuthNotifier extends ChangeNotifier {
  _AuthNotifier() {
    _sub = FirebaseAuth.instance
        .authStateChanges()
        .listen((_) => notifyListeners());
  }

  late final StreamSubscription<User?> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final GoRouter router = GoRouter(
  initialLocation: '/login',
  refreshListenable: _AuthNotifier(),
  redirect: (context, state) {
    final haySesion = FirebaseAuth.instance.currentUser != null;
    final ubicacion = state.matchedLocation;
    final enAuth = ubicacion == '/login' || ubicacion == '/registro';

    // Sin sesión: solo login y registro.
    if (!haySesion) return enAuth ? null : '/login';
    // Con sesión: se va al feed.
    if (enAuth) return '/feed';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
        path: '/registro', builder: (context, state) => const RegisterScreen()),
    GoRoute(path: '/feed', builder: (context, state) => const FeedScreen()),
  ],
);
