import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

/// Fuente de datos remota que interactúa con Firebase Authentication y Cloud Firestore.
/// Centraliza la autenticación, gestión de sesiones y persistencia del perfil de usuario.
class FirebaseAuthDataSource {
  final FirebaseAuth? _customAuth;
  final FirebaseFirestore? _customFirestore;

  FirebaseAuthDataSource({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _customAuth = firebaseAuth,
        _customFirestore = firestore;

  FirebaseAuth get _firebaseAuth => _customAuth ?? FirebaseAuth.instance;
  FirebaseFirestore get _firestore => _customFirestore ?? FirebaseFirestore.instance;

  /// Traduce los códigos de error estándar de Firebase Auth a mensajes comprensibles en español.
  static String mapAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No existe ninguna cuenta asociada a este correo electrónico.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Credenciales incorrectas. Verifica tu correo y contraseña.';
      case 'email-already-in-use':
        return 'Este correo electrónico ya está registrado.';
      case 'invalid-email':
        return 'El formato del correo electrónico no es válido.';
      case 'weak-password':
        return 'La contraseña debe tener al menos 6 caracteres.';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada por motivos de seguridad.';
      case 'too-many-requests':
        return 'Demasiados intentos de acceso fallidos. Por favor, espera unos minutos.';
      case 'network-request-failed':
        return 'Sin conexión a internet. Verifica tu red e intenta nuevamente.';
      default:
        return e.message ?? 'Ocurrió un error en el servicio de autenticación (${e.code}).';
    }
  }

  /// Stream reactivo de cambios en la sesión del usuario
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      return _fetchUserData(user.uid, user.email ?? '');
    });
  }

  /// Usuario actualmente autenticado
  UserModel? get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
      emailVerified: user.emailVerified,
      createdAtMillis: user.metadata.creationTime?.millisecondsSinceEpoch ??
          DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Recupera el perfil consolidado del usuario desde Cloud Firestore
  Future<UserModel> _fetchUserData(String uid, String fallbackEmail) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromFirestore(doc.data()!, uid);
      }
    } catch (_) {
      // Retorna datos base de Firebase Auth si Firestore está offline o en primer inicio
    }
    return UserModel(
      uid: uid,
      email: fallbackEmail,
      displayName: null,
      photoUrl: null,
      emailVerified: false,
      createdAtMillis: DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Registra un nuevo usuario en Firebase Authentication y crea su documento en Cloud Firestore
  Future<UserModel> signUp({
    required String email,
    required String password,
    String? displayName,
    String? department,
    String? photoUrl,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user!;
      if (displayName != null && displayName.trim().isNotEmpty) {
        await user.updateDisplayName(displayName.trim());
      }
      final effectiveAvatar =
          (photoUrl != null && photoUrl.trim().isNotEmpty) ? photoUrl.trim() : 'panda';
      try {
        await user.updatePhotoURL(effectiveAvatar);
      } catch (_) {}

      final now = DateTime.now().millisecondsSinceEpoch;
      final userModel = UserModel(
        uid: user.uid,
        email: email.trim(),
        displayName: displayName?.trim(),
        photoUrl: effectiveAvatar,
        department: department?.trim() ?? 'Pregrado UC',
        emailVerified: user.emailVerified,
        createdAtMillis: now,
      );

      // Persiste perfil inicial en Cloud Firestore sincronizando userProfile
      final firestoreData = userModel.toFirestore();
      firestoreData['userProfile'] = {
        'id': user.uid,
        'fullName': displayName?.trim() ?? 'Estudiante UC',
        'career': department?.trim() ?? 'Pregrado UC',
        'universityEmail': email.trim(),
        'avatarUrl': effectiveAvatar,
        'isMindfulActive': true,
      };

      await _firestore.collection('users').doc(user.uid).set(firestoreData);

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw Exception(mapAuthException(e));
    } catch (e) {
      throw Exception('Error al registrar usuario: $e');
    }
  }

  /// Inicia sesión con correo y contraseña en Firebase Authentication
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user!;
      return await _fetchUserData(user.uid, user.email ?? email);
    } on FirebaseAuthException catch (e) {
      throw Exception(mapAuthException(e));
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  /// Envía un correo de restablecimiento de contraseña mediante Firebase
  Future<void> sendPasswordReset(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw Exception(mapAuthException(e));
    } catch (e) {
      throw Exception('Error al enviar correo de recuperación: $e');
    }
  }

  /// Cierra la sesión activa en el dispositivo
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// Elimina la cuenta del usuario de Authentication y su documento en Firestore
  Future<void> deleteAccount() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      final uid = user.uid;
      try {
        await _firestore.collection('users').doc(uid).delete();
      } catch (_) {}
      await user.delete();
    }
  }
}
