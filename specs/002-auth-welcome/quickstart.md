# Quickstart: 002-auth-welcome

Guía para probar el módulo de Bienvenida y Autenticación con Firebase.

## Ejecución de Pruebas Automatizadas
```bash
# Probar la pantalla de bienvenida y autenticación
flutter test test/widget/features/auth/welcome_auth_screen_test.dart

# Probar la redirección de GoRouter según sesión
flutter test test/widget/core/router/auth_redirect_test.dart

# Ejecutar la suite completa de pruebas
flutter test
```

Verifica:
1. Renderizado exacto del mockup de Figma (Emblema botánico, píldora de Bienestar Estudiantil, selector segmentado, campos de texto, botón y tagline inferior).
2. Alternancia reactiva entre "Iniciar sesión" y "Registrarse".
3. Toggle de visibilidad de contraseña con icono de ojo.
4. Flujo de envío con loading indicator y navegación a `/home`.
5. Diálogo sereno de recuperación de contraseña.

