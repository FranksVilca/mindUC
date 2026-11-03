import '../../domain/entities/community_post.dart';
import '../../domain/repositories/community_repository.dart';
import '../datasources/local_community_datasource.dart';

/// Implementación del repositorio de comunidad local (Principio V).
class LocalCommunityRepositoryImpl implements CommunityRepository {
  LocalCommunityRepositoryImpl({LocalCommunityDataSource? dataSource})
      : _dataSource = dataSource ?? LocalCommunityDataSource();

  final LocalCommunityDataSource _dataSource;

  @override
  Future<List<CommunityPost>> getPosts() => _dataSource.getPosts();

  @override
  Future<void> savePost(CommunityPost post) => _dataSource.savePost(post);

  @override
  Future<void> toggleReaction(String postId, String reactionKey) =>
      _dataSource.toggleReaction(postId, reactionKey);
}
