# Data Model: 002-auth-welcome

## 1. Domain & UI State Models

### 1.1 `AuthUiState` (Presentation Model)
Encapsula el estado reactivo del formulario de bienvenida y autenticación.

```dart
class AuthUiState {
  final bool isLoginMode;
  final bool isPasswordVisible;
  final bool isLoading;
  final String? errorMessage;
  final bool isResetEmailSent;

  const AuthUiState({
    this.isLoginMode = true,
    this.isPasswordVisible = false,
    this.isLoading = false,
    this.errorMessage,
    this.isResetEmailSent = false,
  });

  AuthUiState copyWith({
    bool? isLoginMode,
    bool? isPasswordVisible,
    bool? isLoading,
    String? errorMessage,
    bool? isResetEmailSent,
  }) {
    return AuthUiState(
      isLoginMode: isLoginMode ?? this.isLoginMode,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isResetEmailSent: isResetEmailSent ?? this.isResetEmailSent,
    );
  }
}
```

### 1.2 `UserEntity` (Domain)
Reutilizado de `lib/features/auth/domain/entities/user_entity.dart`.
- `id`: String único de Firebase Auth.
- `email`: String (ej. `camila.soto@uc.cl`).
- `displayName`: String? (ej. `Camila Soto`).
- `department`: String? (ej. `Psicología`).
- `isInstitutional`: getter boolean si termina en `@uc.cl`.
- `isEmailVerified`: boolean.
- `createdAt`: DateTime.
