import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Inicio de sesión con correo y contraseña.
  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Registro: crea el usuario y guarda el nombre con updateDisplayName.
  Future<void> register(String nombre, String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await cred.user?.updateDisplayName(nombre.trim());
    await cred.user?.reload();
  }

  /// Ventana emergente de Firebase (web). Devuelve false si se cierra.
  Future<bool> _popup(AuthProvider proveedor) async {
    try {
      await _auth.signInWithPopup(proveedor);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'popup-closed-by-user' ||
          e.code == 'cancelled-popup-request') {
        return false;
      }
      rethrow;
    }
  }

  /// Google. Devuelve false si la persona cancela.
  Future<bool> loginConGoogle() async {
    if (kIsWeb) return _popup(GoogleAuthProvider());
    final cuenta = await GoogleSignIn().signIn();
    if (cuenta == null) return false;
    final auth = await cuenta.authentication;
    final credencial = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    await _auth.signInWithCredential(credencial);
    return true;
  }

  /// Facebook. Devuelve false si la persona cancela.
  Future<bool> loginConFacebook() async {
    if (kIsWeb) return _popup(FacebookAuthProvider());
    final result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.cancelled) return false;
    if (result.status != LoginStatus.success || result.accessToken == null) {
      throw FirebaseAuthException(
        code: 'facebook-failed',
        message:
            'No se pudo iniciar sesión con Facebook. ${result.message ?? ''}',
      );
    }
    final credencial =
        FacebookAuthProvider.credential(result.accessToken!.tokenString);
    await _auth.signInWithCredential(credencial);
    return true;
  }

  /// Cierra sesión en Google, Facebook y Firebase.
  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
    try {
      await FacebookAuth.instance.logOut();
    } catch (_) {}
    await _auth.signOut();
  }

  /// Convierte errores de Firebase en mensajes claros en español.
  static String mensajeError(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
          return 'Correo o contraseña incorrectos.';
        case 'invalid-email':
          return 'El formato del correo no es válido.';
        case 'email-already-in-use':
          return 'Este correo ya está registrado.';
        case 'weak-password':
          return 'La contraseña es muy débil (mínimo 6 caracteres).';
        case 'user-disabled':
          return 'Esta cuenta está deshabilitada.';
        case 'too-many-requests':
          return 'Demasiados intentos. Intenta más tarde.';
        case 'network-request-failed':
          return 'Sin conexión a internet.';
        case 'account-exists-with-different-credential':
          return 'Ya existe una cuenta con ese correo usando otro método de inicio de sesión.';
        case 'operation-not-allowed':
          return 'Este método de inicio de sesión no está habilitado en Firebase.';
        default:
          return e.message ?? 'Ocurrió un error inesperado.';
      }
    }
    return 'Ocurrió un error inesperado. Intenta de nuevo.';
  }
}