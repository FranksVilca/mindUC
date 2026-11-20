import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'firebase_initializer.dart';

/// Servicio centralizado y reutilizable para la interacción con Firebase.
/// Provee acceso tipado a instancias de Authentication, Firestore y referencias
/// a las colecciones principales del ecosistema mindUC.
class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  /// Acceso seguro a la instancia de FirebaseAuth
  FirebaseAuth get auth => FirebaseAuth.instance;

  /// Acceso seguro a la instancia de FirebaseFirestore
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  /// Indica si la infraestructura Firebase está inicializada y lista
  bool get isReady => FirebaseInitializer.isInitialized;

  /// Usuario actualmente autenticado en Firebase
  User? get currentUser => isReady ? auth.currentUser : null;

  /// ID del usuario activo o cadena vacía si no hay sesión
  String get currentUserId => currentUser?.uid ?? '';

  /// Stream reactivo de cambios en el estado de autenticación
  Stream<User?> get authStateChanges =>
      isReady ? auth.authStateChanges() : Stream.value(null);

  // ===========================================================================
  // REFERENCIAS A COLECCIONES DE CLOUD FIRESTORE (CACHED ACCESSORS)
  // ===========================================================================

  CollectionReference<Map<String, dynamic>>? _cachedUsersCollection;
  CollectionReference<Map<String, dynamic>>? _cachedCommunityCollection;

  /// Colección raíz de usuarios y perfiles: `users/{userId}`
  CollectionReference<Map<String, dynamic>> get usersCollection =>
      _cachedUsersCollection ??= firestore.collection('users');

  /// Documento del perfil del usuario: `users/{userId}`
  DocumentReference<Map<String, dynamic>> userDoc(String userId) {
    final uid = userId.trim().isNotEmpty
        ? userId.trim()
        : (currentUserId.isNotEmpty ? currentUserId : 'anonymous');
    return usersCollection.doc(uid);
  }

  /// Subcolección de actividades de la Agenda: `users/{userId}/activities/{activityId}`
  CollectionReference<Map<String, dynamic>> agendaCollection(String userId) {
    return userDoc(userId).collection('activities');
  }

  /// Subcolección del Diario Personal íntimo: `users/{userId}/journal_entries/{entryId}`
  CollectionReference<Map<String, dynamic>> journalCollection(String userId) {
    return userDoc(userId).collection('journal_entries');
  }

  /// Colección raíz del Foro Comunitario: `community_posts/{postId}`
  CollectionReference<Map<String, dynamic>> get communityPostsCollection =>
      _cachedCommunityCollection ??= firestore.collection('community_posts');

  /// Subcolección de comentarios de un post: `community_posts/{postId}/comments/{commentId}`
  CollectionReference<Map<String, dynamic>> communityCommentsCollection(
          String postId) =>
      communityPostsCollection.doc(postId).collection('comments');

  /// Documento de progreso y gamificación: `users/{userId}/progress/summary`
  DocumentReference<Map<String, dynamic>> progressDoc(String userId) {
    return userDoc(userId).collection('progress').doc('summary');
  }

  /// Subcolección del pulso emocional diario: `users/{userId}/mood_entries/{dateString}`
  CollectionReference<Map<String, dynamic>> moodCollection(String userId) {
    return userDoc(userId).collection('mood_entries');
  }

  /// Subcolección del módulo de relajación: `users/{userId}/relaxation_progress/{activityId}`
  CollectionReference<Map<String, dynamic>> relaxationCollection(String userId) {
    return userDoc(userId).collection('relaxation_progress');
  }

  // ===========================================================================
  // GESTIÓN DE RED Y PERSISTENCIA OFFLINE
  // ===========================================================================

  /// Habilita sincronización con la nube
  Future<void> enableNetwork() async {
    try {
      await firestore.enableNetwork();
      debugPrint('[FirebaseService] Sincronización en la nube habilitada.');
    } catch (e) {
      debugPrint('[FirebaseService] Error al habilitar red: $e');
    }
  }

  /// Deshabilita red para operar exclusivamente en caché offline
  Future<void> disableNetwork() async {
    try {
      await firestore.disableNetwork();
      debugPrint('[FirebaseService] Modo offline activado.');
    } catch (e) {
      debugPrint('[FirebaseService] Error al deshabilitar red: $e');
    }
  }

  /// Limpia la persistencia en disco de Firestore (útil para pruebas o cierre de sesión)
  Future<void> clearPersistence() async {
    try {
      await firestore.clearPersistence();
      debugPrint('[FirebaseService] Caché persistente de Firestore limpiada.');
    } catch (e) {
      debugPrint('[FirebaseService] Aviso al limpiar caché: $e');
    }
  }
}
