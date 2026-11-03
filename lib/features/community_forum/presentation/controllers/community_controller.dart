import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/local_community_repository_impl.dart';
import '../../domain/entities/community_avatar.dart';
import '../../domain/entities/community_mood_category.dart';
import '../../domain/entities/community_post.dart';
import '../../domain/entities/community_state.dart';
import '../../domain/repositories/community_repository.dart';

/// Proveedor del repositorio de la comunidad (Clean Architecture)
final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return LocalCommunityRepositoryImpl();
});

/// Proveedor del controlador reactivo de la comunidad
final communityControllerProvider =
    StateNotifierProvider<CommunityNotifier, CommunityState>((ref) {
  final repository = ref.watch(communityRepositoryProvider);
  return CommunityNotifier(repository: repository);
});

/// Interfaz del controlador del foro comunitario
abstract class ICommunityController {
  void selectFilter(CommunityMoodCategory filter);
  Future<void> toggleReaction(String postId, String reactionKey);
  Future<void> createPost({
    required String authorAlias,
    required String authorRole,
    required CommunityAvatar avatar,
    required String faculty,
    required String content,
    required List<String> tags,
    required CommunityMoodCategory moodCategory,
  });
}

/// Controlador reactivo StateNotifier para la comunidad consciente
class CommunityNotifier extends StateNotifier<CommunityState>
    implements ICommunityController {
  CommunityNotifier({required this.repository})
      : super(const CommunityState(isLoading: true)) {
    _loadPosts();
  }

  final CommunityRepository repository;

  Future<void> _loadPosts() async {
    final posts = await repository.getPosts();
    state = state.copyWith(
      allPosts: posts,
      isLoading: false,
    );
  }

  @override
  void selectFilter(CommunityMoodCategory filter) {
    state = state.copyWith(selectedFilter: filter);
  }

  @override
  Future<void> toggleReaction(String postId, String reactionKey) async {
    await repository.toggleReaction(postId, reactionKey);
    final posts = await repository.getPosts();
    state = state.copyWith(allPosts: posts);
  }

  @override
  Future<void> createPost({
    required String authorAlias,
    required String authorRole,
    required CommunityAvatar avatar,
    required String faculty,
    required String content,
    required List<String> tags,
    required CommunityMoodCategory moodCategory,
  }) async {
    final newPost = CommunityPost(
      id: 'post-${DateTime.now().millisecondsSinceEpoch}',
      authorAlias: authorAlias,
      authorRole: authorRole,
      avatar: avatar,
      faculty: faculty,
      timeAgo: 'Justo ahora',
      tags: tags,
      content: content,
      moodCategory: moodCategory,
      createdAt: DateTime.now(),
    );
    await repository.savePost(newPost);
    final posts = await repository.getPosts();
    state = state.copyWith(allPosts: posts);
  }
}
