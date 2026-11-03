import 'community_mood_category.dart';
import 'community_post.dart';

/// Estado inmutable para el controlador reactivo de la comunidad
class CommunityState {
  final CommunityMoodCategory selectedFilter;
  final List<CommunityPost> allPosts;
  final bool isLoading;

  const CommunityState({
    this.selectedFilter = CommunityMoodCategory.todo,
    this.allPosts = const [],
    this.isLoading = false,
  });

  /// Lista de publicaciones filtradas por la categoría activa
  List<CommunityPost> get filteredPosts {
    if (selectedFilter == CommunityMoodCategory.todo) {
      return allPosts;
    }
    return allPosts.where((p) => p.moodCategory == selectedFilter).toList();
  }

  /// Total de hilos activos en la comunidad
  int get activeThreadCount => allPosts.length;

  CommunityState copyWith({
    CommunityMoodCategory? selectedFilter,
    List<CommunityPost>? allPosts,
    bool? isLoading,
  }) {
    return CommunityState(
      selectedFilter: selectedFilter ?? this.selectedFilter,
      allPosts: allPosts ?? this.allPosts,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
