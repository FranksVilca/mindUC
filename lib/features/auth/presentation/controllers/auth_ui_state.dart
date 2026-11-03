/// Estado reactivo del formulario de autenticación y bienvenida de mindUC.
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
    bool clearError = false,
  }) {
    return AuthUiState(
      isLoginMode: isLoginMode ?? this.isLoginMode,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isResetEmailSent: isResetEmailSent ?? this.isResetEmailSent,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthUiState &&
          runtimeType == other.runtimeType &&
          isLoginMode == other.isLoginMode &&
          isPasswordVisible == other.isPasswordVisible &&
          isLoading == other.isLoading &&
          errorMessage == other.errorMessage &&
          isResetEmailSent == other.isResetEmailSent;

  @override
  int get hashCode => Object.hash(
        isLoginMode,
        isPasswordVisible,
        isLoading,
        errorMessage,
        isResetEmailSent,
      );
}
