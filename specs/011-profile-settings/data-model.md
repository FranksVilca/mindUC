# Data Model: 011-profile-settings

## Domain Entities & Value Objects

### 1. `UserProfile` (Value Object / Domain Entity)

Representa la identidad institucional y académica del estudiante en mindUC.

```dart
class UserProfile {
  final String id;
  final String fullName;
  final String career;
  final String universityEmail;
  final String? avatarUrl;
  final bool isMindfulActive;

  const UserProfile({
    required this.id,
    required this.fullName,
    required this.career,
    required this.universityEmail,
    this.avatarUrl,
    this.isMindfulActive = true,
  });

  UserProfile copyWith({
    String? id,
    String? fullName,
    String? career,
    String? universityEmail,
    String? avatarUrl,
    bool? isMindfulActive,
  }) {
    return UserProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      career: career ?? this.career,
      universityEmail: universityEmail ?? this.universityEmail,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isMindfulActive: isMindfulActive ?? this.isMindfulActive,
    );
  }
}
```

---

### 2. `WellnessPreferences` (Value Object)

Encapsula la configuración personal de autocuidado consciente del estudiante.

```dart
class WellnessPreferences {
  final String defaultAmbientSound;
  final String favoriteBreathingTechnique;
  final bool consciousRemindersEnabled;
  final String reminderIntervalDescription;

  const WellnessPreferences({
    this.defaultAmbientSound = 'Lluvia suave en el bosque',
    this.favoriteBreathingTechnique = 'Caja 4–4–4',
    this.consciousRemindersEnabled = true,
    this.reminderIntervalDescription = 'Pausas cada 2 horas de estudio',
  });

  WellnessPreferences copyWith({
    String? defaultAmbientSound,
    String? favoriteBreathingTechnique,
    bool? consciousRemindersEnabled,
    String? reminderIntervalDescription,
  }) {
    return WellnessPreferences(
      defaultAmbientSound: defaultAmbientSound ?? this.defaultAmbientSound,
      favoriteBreathingTechnique: favoriteBreathingTechnique ?? this.favoriteBreathingTechnique,
      consciousRemindersEnabled: consciousRemindersEnabled ?? this.consciousRemindersEnabled,
      reminderIntervalDescription: reminderIntervalDescription ?? this.reminderIntervalDescription,
    );
  }
}
```

---

### 3. `InstitutionalSupportContact` (Value Object)

Modela el canal de contención psicológica universitaria confidencial.

```dart
class InstitutionalSupportContact {
  final String title;
  final String description;
  final String phoneNumber;
  final String extensionNumber;
  final String availability;
  final bool isConfidential;

  const InstitutionalSupportContact({
    required this.title,
    required this.description,
    required this.phoneNumber,
    required this.extensionNumber,
    this.availability = 'Atención 24/7 confidencial para estudiantes UC',
    this.isConfidential = true,
  });
}
```

---

### 4. `ProfileState` (Immutable State Model)

Agrupa el estado completo de la pantalla de perfil y configuración.

```dart
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
}
```

---

## Domain Repository Interface

```dart
abstract class ProfileRepository {
  Future<Result<ProfileState, Failure>> getProfileState();
  Future<Result<void, Failure>> updatePreferences(WellnessPreferences preferences);
  Future<Result<void, Failure>> logout();
}
```

---

## Data Layer Architecture

### `LocalProfileDataSource`
- Provee los datos estables de Camila Soto basados en el mockup de Figma.
- Mantiene en memoria las preferencias mutables para respuesta inmediata (<50 ms).

### `LocalProfileRepositoryImpl`
- Implementa `ProfileRepository` delegando en `LocalProfileDataSource`.
- Envuelve las operaciones en el mónada `Result<T, Failure>`.
