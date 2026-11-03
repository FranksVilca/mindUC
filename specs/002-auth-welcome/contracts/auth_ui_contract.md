# Contract: Auth UI Controller Interface

`lib/features/auth/presentation/controllers/auth_controller.dart`

```dart
abstract interface class AuthUiControllerContract {
  void toggleMode(); // Alterna entre Iniciar sesión y Registrarse
  void togglePasswordVisibility(); // Alterna ocultar / ver contraseña
  Future<bool> submit({
    required String email,
    required String password,
    String? displayName,
    String? department,
  });
  Future<bool> sendPasswordReset(String email);
  void clearError();
}
```
