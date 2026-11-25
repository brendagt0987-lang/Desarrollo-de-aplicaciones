import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/auth_service.dart';
import '../widgets/auth_shell.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirmar = TextEditingController();
  final _auth = AuthService();
  bool _cargando = false;
  bool _ocultar = true;

  @override
  void dispose() {
    _nombre.dispose();
    _email.dispose();
    _pass.dispose();
    _confirmar.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _cargando = true);
    try {
      await _auth.register(_nombre.text, _email.text, _pass.text);
      // La sesión queda iniciada y el redirect del router lleva al feed.
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

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      titulo: 'Crea tu cuenta',
      subtitulo: 'Solo toma un minuto',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nombre,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Nombre completo',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'El nombre es obligatorio'
                  : null,
            ),
            const SizedBox(height: 14),
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
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return 'La contraseña es obligatoria';
                }
                return v.length < 6 ? 'Mínimo 6 caracteres' : null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _confirmar,
              obscureText: _ocultar,
              decoration: const InputDecoration(
                labelText: 'Confirmar contraseña',
                prefixIcon: Icon(Icons.lock_reset_outlined),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Confirma la contraseña';
                return v != _pass.text ? 'Las contraseñas no coinciden' : null;
              },
            ),
            const SizedBox(height: 22),
            BotonDegradado(
              texto: 'Crear cuenta',
              cargando: _cargando,
              onPressed: _cargando ? null : _registrar,
            ),
            const SizedBox(height: 14),
            TextButton(
              onPressed: () => context.go('/login'),
              child: const Text('¿Ya tienes cuenta? Inicia sesión',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
