import 'institutional_support_contact.dart';
import 'user_profile.dart';
import 'wellness_preferences.dart';

/// Modelo de estado inmutable para la pantalla de Perfil y Configuración.
class ProfileState {
  final UserProfile user;
  final WellnessPreferences preferences;
  final InstitutionalSupportContact supportContact;
  final bool isLoading;
  final String? errorMessage;

  const ProfileState({
    required this.user,
    required this.preferences,
    required this.supportContact,
    this.isLoading = false,
    this.errorMessage,
  });

  ProfileState copyWith({
    UserProfile? user,
    WellnessPreferences? preferences,
    InstitutionalSupportContact? supportContact,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProfileState(
      user: user ?? this.user,
      preferences: preferences ?? this.preferences,
      supportContact: supportContact ?? this.supportContact,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileState &&
          runtimeType == other.runtimeType &&
          user == other.user &&
          preferences == other.preferences &&
          supportContact == other.supportContact &&
          isLoading == other.isLoading &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => Object.hash(
        user,
        preferences,
        supportContact,
        isLoading,
        errorMessage,
      );
}

