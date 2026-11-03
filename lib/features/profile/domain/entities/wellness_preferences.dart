/// Encapsula las preferencias de autocuidado consciente del estudiante.
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WellnessPreferences &&
          runtimeType == other.runtimeType &&
          defaultAmbientSound == other.defaultAmbientSound &&
          favoriteBreathingTechnique == other.favoriteBreathingTechnique &&
          consciousRemindersEnabled == other.consciousRemindersEnabled &&
          reminderIntervalDescription == other.reminderIntervalDescription;

  @override
  int get hashCode => Object.hash(
        defaultAmbientSound,
        favoriteBreathingTechnique,
        consciousRemindersEnabled,
        reminderIntervalDescription,
      );
}

