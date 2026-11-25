class Validators {
  static final _emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'El correo es obligatorio';
    return _emailRe.hasMatch(v.trim()) ? null : 'Formato de correo no válido';
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'La contraseña es obligatoria';
    return v.length < 6 ? 'Mínimo 6 caracteres' : null;
  }

  static String? confirmPassword(String? v, String original) {
    if (v == null || v.isEmpty) return 'Confirma la contraseña';
    return v == original ? null : 'Las contraseñas no coinciden';
  }
}
