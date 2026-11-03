import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

/// Fuente de datos remota que interactúa con Firebase Authentication y Cloud Firestore.
class FirebaseAuthDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthDataSource({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      return _fetchUserData(user.uid, user.email ?? '');
    });
  }

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

  Future<UserModel> _fetchUserData(String uid, String fallbackEmail) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromFirestore(doc.data()!, uid);
      }
    } catch (_) {
      // Retorna datos base de Firebase Auth si Firestore está offline
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

  Future<UserModel> signUp({
    required String email,
    required String password,
    String? displayName,
    String? department,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user!;
    if (displayName != null) {
      await user.updateDisplayName(displayName);
    }

    final userModel = UserModel(
      uid: user.uid,
      email: email,
      displayName: displayName,
      department: department ?? 'Pregrado UC',
      emailVerified: user.emailVerified,
      createdAtMillis: DateTime.now().millisecondsSinceEpoch,
    );

    // Persiste perfil en Cloud Firestore
    await _firestore.collection('users').doc(user.uid).set(userModel.toFirestore());

    return userModel;
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;
    return _fetchUserData(user.uid, user.email ?? email);
  }

  Future<void> sendPasswordReset(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> deleteAccount() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).delete();
      await user.delete();
    }
  }
}

