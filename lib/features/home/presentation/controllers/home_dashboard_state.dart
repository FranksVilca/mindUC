import '../../domain/entities/dashboard_summary.dart';
import '../../domain/entities/mood_type.dart';
import '../../domain/entities/quick_access_item.dart';

/// Estado inmutable de la pantalla de inicio mindUC.
class HomeDashboardState {
  final bool isLoading;
  final bool isSavingMood;
  final DashboardSummary summary;
  final MoodType? selectedMood;
  final List<QuickAccessItem> quickAccessItems;
  final String? errorMessage;

  const HomeDashboardState({
    this.isLoading = false,
    this.isSavingMood = false,
    required this.summary,
    this.selectedMood,
    this.quickAccessItems = const [],
    this.errorMessage,
  });

  HomeDashboardState copyWith({
    bool? isLoading,
    bool? isSavingMood,
    DashboardSummary? summary,
    MoodType? selectedMood,
    List<QuickAccessItem>? quickAccessItems,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HomeDashboardState(
      isLoading: isLoading ?? this.isLoading,
      isSavingMood: isSavingMood ?? this.isSavingMood,
      summary: summary ?? this.summary,
      selectedMood: selectedMood ?? this.selectedMood,
      quickAccessItems: quickAccessItems ?? this.quickAccessItems,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
