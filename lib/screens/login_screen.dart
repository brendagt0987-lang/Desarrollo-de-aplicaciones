import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/auth_service.dart';
import '../widgets/auth_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _auth = AuthService();
  bool _cargando = false;
  bool _ocultar = true;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _ejecutar(Future<void> Function() accion) async {
    setState(() => _cargando = true);
    try {
      await accion();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AuthService.mensajeError(e))),
        );
      }
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  void _loginCorreo() {
    if (!_formKey.currentState!.validate()) return;
    _ejecutar(() => _auth.login(_email.text, _pass.text));
  }

  Widget _social(IconData icono, String texto, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF1B1035),
          side: const BorderSide(color: Color(0xFFE0DCE8)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: _cargando ? null : onTap,
        icon: Icon(icono, size: 24),
        label: Text(texto,
            style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      titulo: 'Bienvenida de nuevo',
      subtitulo: 'Inicia sesión para ver los videos',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'El correo es obligatorio';
                }
                final ok =
                    RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
                return ok ? null : 'Formato de correo no válido';
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _pass,
              obscureText: _ocultar,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                      _ocultar ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _ocultar = !_ocultar),
                ),
              ),
              validator: (v) => (v == null || v.isEmpty)
                  ? 'La contraseña es obligatoria'
                  : null,
            ),
            const SizedBox(height: 22),
            BotonDegradado(
              texto: 'Ingresar',
              cargando: _cargando,
              onPressed: _cargando ? null : _loginCorreo,
            ),
            const SizedBox(height: 20),
            const Row(children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text('o continúa con',
                    style: TextStyle(color: Colors.black45, fontSize: 13)),
              ),
              Expanded(child: Divider()),
            ]),
            const SizedBox(height: 16),
            _social(Icons.g_mobiledata, 'Continuar con Google',
                () => _ejecutar(() => _auth.loginConGoogle())),
            const SizedBox(height: 10),
            _social(Icons.facebook, 'Continuar con Facebook',
                () => _ejecutar(() => _auth.loginConFacebook())),
            const SizedBox(height: 14),
            TextButton(
              onPressed: () => context.go('/registro'),
              child: const Text('¿No tienes cuenta? Regístrate',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
