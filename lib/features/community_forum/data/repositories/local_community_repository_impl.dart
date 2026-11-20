import '../../domain/entities/community_comment.dart';
import '../../domain/entities/community_post.dart';
import '../../domain/repositories/community_repository.dart';
import '../datasources/local_community_datasource.dart';

/// Implementación del repositorio de comunidad respaldado por LocalCommunityDataSource.
class LocalCommunityRepositoryImpl implements CommunityRepository {
  LocalCommunityRepositoryImpl({LocalCommunityDataSource? dataSource})
      : _dataSource = dataSource ?? LocalCommunityDataSource();

  final LocalCommunityDataSource _dataSource;

  @override
  Future<List<CommunityPost>> getPosts({String? currentUserId}) => _dataSource.getPosts();

  @override
  Future<void> savePost(CommunityPost post) => _dataSource.savePost(post);

  @override
  Future<void> toggleReaction(String postId, String reactionKey, {String? userId}) =>
      _dataSource.toggleReaction(postId, reactionKey, userId: userId);

  @override
  Future<void> addComment({
    required String postId,
    required CommunityComment comment,
  }) =>
      _dataSource.addComment(postId: postId, comment: comment);

  @override
  Future<void> toggleEmojiReaction({
    required String postId,
    required String emoji,
    required String userId,
  }) =>
      _dataSource.toggleEmojiReaction(
        postId: postId,
        emoji: emoji,
        userId: userId,
      );
}
