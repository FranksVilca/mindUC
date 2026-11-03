/// Categorías emocionales y de sentir para clasificar y filtrar hilos comunitarios.
enum CommunityMoodCategory {
  todo(displayName: 'Todo'),
  estresAcademico(displayName: 'Estrés académico'),
  desahogoCalma(displayName: 'Desahogo y calma'),
  habitoSaludable(displayName: 'Hábito saludable'),
  vulnerabilidad(displayName: 'Vulnerabilidad');

  final String displayName;
  const CommunityMoodCategory({required this.displayName});

  static CommunityMoodCategory fromString(String value) {
    for (final cat in CommunityMoodCategory.values) {
      if (cat.name.toLowerCase() == value.toLowerCase() ||
          cat.displayName.toLowerCase() == value.toLowerCase()) {
        return cat;
      }
    }
    return CommunityMoodCategory.todo;
  }
}
