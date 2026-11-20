import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/datasources/local_community_datasource.dart';
import '../../data/repositories/community_repository_impl.dart';
import '../../domain/entities/community_avatar.dart';
import '../../domain/entities/community_comment.dart';
import '../../domain/entities/community_mood_category.dart';
import '../../domain/entities/community_post.dart';
import '../../domain/entities/community_state.dart';
import '../../domain/repositories/community_repository.dart';
import '../../domain/services/community_content_moderator.dart';

/// Proveedor del repositorio de la comunidad (Clean Architecture con soporte Cloud Firestore)
final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return CommunityRepositoryImpl();
});

/// Proveedor del controlador reactivo de la comunidad
final communityControllerProvider =
    StateNotifierProvider<CommunityNotifier, CommunityState>((ref) {
  final repository = ref.watch(communityRepositoryProvider);
  final user = ref.watch(currentUserProvider);

  return CommunityNotifier(
    repository: repository,
    currentUserId: user?.id ?? 'guest_user',
    currentUserName: user?.displayName ?? 'Estudiante UC',
    currentUserAvatarUrl: null,
  );
});

/// Interfaz del controlador del foro comunitario
abstract class ICommunityController {
  void selectFilter(CommunityMoodCategory filter);
  Future<void> toggleReaction(String postId, String reactionKey);
  Future<void> toggleEmojiReaction({
    required String postId,
    required String emoji,
    String? userId,
  });
  Future<void> addComment({
    required String postId,
    required String content,
    String? authorName,
    String? authorAvatarUrl,
    String? authorId,
  });
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
  CommunityNotifier({
    required this.repository,
    this.currentUserId = 'guest_user',
    this.currentUserName = 'Estudiante UC',
    this.currentUserAvatarUrl,
    CommunityState? initialState,
  }) : super(initialState ??
            CommunityState(
              isLoading: true,
              allPosts: LocalCommunityDataSource.mockInitialPosts,
            )) {
    _loadPosts();
  }

  final CommunityRepository repository;
  final String currentUserId;
  final String currentUserName;
  final String? currentUserAvatarUrl;

  Future<void> _loadPosts() async {
    final posts = await repository.getPosts(currentUserId: currentUserId);
    if (mounted) {
      state = state.copyWith(
        allPosts: posts,
        isLoading: false,
      );
    }
  }

  @override
  void selectFilter(CommunityMoodCategory filter) {
    state = state.copyWith(selectedFilter: filter);
  }

  @override
  Future<void> toggleReaction(String postId, String reactionKey) async {
    final emojiMap = {
      'support': '❤️',
      'calm': '🌿',
      'insight': '💡',
      'hug': '🫂',
    };
    final emoji = emojiMap[reactionKey] ?? reactionKey;
    await toggleEmojiReaction(postId: postId, emoji: emoji, userId: currentUserId);
  }

  @override
  Future<void> toggleEmojiReaction({
    required String postId,
    required String emoji,
    String? userId,
  }) async {
    final activeUserId = userId ?? currentUserId;

    // Actualización optimista instantánea en memoria (0 ms de latencia percibida)
    final updatedPosts = state.allPosts.map((post) {
      if (post.id != postId) return post;
      final currentUsers = Set<String>.from(post.emojiReactions[emoji] ?? {});
      final wasPresent = currentUsers.contains(activeUserId);
      if (wasPresent) {
        currentUsers.remove(activeUserId);
      } else {
        currentUsers.add(activeUserId);
      }
      final newEmojiMap = Map<String, Set<String>>.from(post.emojiReactions);
      if (currentUsers.isEmpty) {
        newEmojiMap.remove(emoji);
      } else {
        newEmojiMap[emoji] = currentUsers;
      }

      int support = post.supportCount;
      int calm = post.calmCount;
      int insight = post.insightCount;
      int hug = post.hugCount;

      if (emoji == '❤️' || emoji == '🤍') {
        support = wasPresent ? (support - 1).clamp(0, 99999) : support + 1;
      } else if (emoji == '🌿') {
        calm = wasPresent ? (calm - 1).clamp(0, 99999) : calm + 1;
      } else if (emoji == '💡') {
        insight = wasPresent ? (insight - 1).clamp(0, 99999) : insight + 1;
      } else if (emoji == '🫂') {
        hug = wasPresent ? (hug - 1).clamp(0, 99999) : hug + 1;
      }

      final newUserReactions = Set<String>.from(post.userReactions);
      final reactionKeyMap = {
        '❤️': 'support',
        '🤍': 'support',
        '🌿': 'calm',
        '💡': 'insight',
        '🫂': 'hug',
      };
      final key = reactionKeyMap[emoji];
      if (key != null) {
        if (wasPresent) {
          newUserReactions.remove(key);
        } else {
          newUserReactions.add(key);
        }
      }

      return post.copyWith(
        emojiReactions: newEmojiMap,
        supportCount: support,
        calmCount: calm,
        insightCount: insight,
        hugCount: hug,
        userReactions: newUserReactions,
      );
    }).toList();

    state = state.copyWith(allPosts: updatedPosts);

    // Sincronización en segundo plano con el backend
    try {
      await repository.toggleEmojiReaction(
        postId: postId,
        emoji: emoji,
        userId: activeUserId,
      );
    } catch (_) {
      // Revertir a la versión sincronizada si la red falló
      final posts = await repository.getPosts(currentUserId: activeUserId);
      if (mounted) {
        state = state.copyWith(allPosts: posts);
      }
    }
  }

  @override
  Future<void> addComment({
    required String postId,
    required String content,
    String? authorName,
    String? authorAvatarUrl,
    String? authorId,
  }) async {
    final cleanContent = content.trim();
    if (cleanContent.isEmpty || !CommunityContentModerator.isClean(cleanContent)) {
      return;
    }

    final newComment = CommunityComment(
      id: 'comment-${DateTime.now().millisecondsSinceEpoch}',
      postId: postId,
      authorId: authorId ?? currentUserId,
      authorName: authorName ?? 'Usuario anónimo',
      authorAvatarUrl: null,
      content: cleanContent,
      createdAt: DateTime.now(),
    );

    // Inserción optimista del comentario
    final updatedPosts = state.allPosts.map((post) {
      if (post.id != postId) return post;
      final updatedComments = List<CommunityComment>.from(post.comments)..add(newComment);
      return post.copyWith(
        comments: updatedComments,
        commentCount: post.commentCount + 1,
      );
    }).toList();
    state = state.copyWith(allPosts: updatedPosts);

    await repository.addComment(postId: postId, comment: newComment);
    final posts = await repository.getPosts();
    if (mounted) {
      state = state.copyWith(allPosts: posts);
    }
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
    if (!CommunityContentModerator.isClean(content)) return;

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

    // Inserción optimista en la cima
    state = state.copyWith(allPosts: [newPost, ...state.allPosts]);

    await repository.savePost(newPost);
    final posts = await repository.getPosts();
    if (mounted) {
      state = state.copyWith(allPosts: posts);
    }
  }
}
