import 'dart:async';
import '../models/user_model.dart';

/// Fuente de datos simulada en memoria para tests y desarrollo local offline.
class FakeAuthDataSource {
  final _controller = StreamController<UserModel?>.broadcast();
  UserModel? _currentUser;

  FakeAuthDataSource([UserModel? initialUser]) : _currentUser = initialUser {
    _controller.add(_currentUser);
  }

  Stream<UserModel?> get authStateChanges => _controller.stream;
  UserModel? get currentUser => _currentUser;

  Future<UserModel> signUp({
    required String email,
    required String password,
    String? displayName,
    String? department,
  }) async {
    final user = UserModel(
      uid: 'fake_uid_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: displayName ?? 'Estudiante UC',
      department: department ?? 'Psicología',
      emailVerified: true,
      createdAtMillis: DateTime.now().millisecondsSinceEpoch,
    );
    _currentUser = user;
    _controller.add(_currentUser);
    return user;
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    if (password == 'wrong') {
      throw Exception('Credenciales incorrectas');
    }

    final user = UserModel(
      uid: 'fake_uid_camila_soto',
      email: email,
      displayName: 'Camila Soto',
      department: 'Psicología',
      emailVerified: true,
      createdAtMillis: DateTime.now().millisecondsSinceEpoch,
    );
    _currentUser = user;
    _controller.add(_currentUser);
    return user;
  }

  Future<void> sendPasswordReset(String email) async {
    // Simula envío exitoso
  }

  Future<void> signOut() async {
    _currentUser = null;
    _controller.add(null);
  }

  Future<void> deleteAccount() async {
    _currentUser = null;
    _controller.add(null);
  }

  void dispose() {
    _controller.close();
  }
}
