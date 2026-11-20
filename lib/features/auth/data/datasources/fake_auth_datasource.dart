import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class _FakeAccount {
  final String email;
  final String password;
  final UserModel userModel;

  _FakeAccount({
    required this.email,
    required this.password,
    required this.userModel,
  });
}

/// Fuente de datos simulada y persistente en almacenamiento local para tests y desarrollo offline.
/// Mantiene las cuentas registradas de manera persistente en SharedPreferences para que
/// la sesión del usuario no se cierre al salir de la aplicación.
class FakeAuthDataSource {
  static const _prefKeyUid = 'fake_auth_user_uid';
  static const _prefKeyEmail = 'fake_auth_user_email';
  static const _prefKeyDisplayName = 'fake_auth_user_name';
  static const _prefKeyPhotoUrl = 'fake_auth_user_avatar';
  static const _prefKeyDepartment = 'fake_auth_user_dept';

  static final Map<String, _FakeAccount> _accounts = {};
  static UserModel? _cachedPersistedUser;

  final _controller = StreamController<UserModel?>.broadcast();
  final SharedPreferences? _preferences;
  UserModel? _currentUser;

  FakeAuthDataSource([UserModel? initialUser, SharedPreferences? preferences])
      : _preferences = preferences,
        _currentUser = initialUser ?? _cachedPersistedUser {
    if (_currentUser != null) {
      _accounts[_currentUser!.email.trim().toLowerCase()] = _FakeAccount(
        email: _currentUser!.email.trim().toLowerCase(),
        password: 'password',
        userModel: _currentUser!,
      );
    }
    _controller.add(_currentUser);
  }

  Stream<UserModel?> get authStateChanges => _controller.stream;
  UserModel? get currentUser => _currentUser;

  /// Restaura la sesión persistida desde SharedPreferences al iniciar la app.
  static Future<UserModel?> loadPersistedUser([SharedPreferences? preferences]) async {
    try {
      final prefs = preferences ?? await SharedPreferences.getInstance();
      final uid = prefs.getString(_prefKeyUid);
      final email = prefs.getString(_prefKeyEmail);

      if (uid != null && uid.isNotEmpty && email != null && email.isNotEmpty) {
        final name = prefs.getString(_prefKeyDisplayName);
        final photo = prefs.getString(_prefKeyPhotoUrl);
        final dept = prefs.getString(_prefKeyDepartment);

        final loaded = UserModel(
          uid: uid,
          email: email,
          displayName: name,
          photoUrl: photo,
          department: dept,
          emailVerified: true,
          createdAtMillis: DateTime.now().millisecondsSinceEpoch,
        );

        _cachedPersistedUser = loaded;
        _accounts[email.trim().toLowerCase()] = _FakeAccount(
          email: email.trim().toLowerCase(),
          password: 'password',
          userModel: loaded,
        );
        return loaded;
      }
    } catch (_) {}
    return null;
  }

  static void clearAccounts() {
    _accounts.clear();
    _cachedPersistedUser = null;
  }

  static String _deriveDisplayName(String email) {
    final prefix = email.split('@').first;
    final parts = prefix.split(RegExp(r'[._-]'));
    return parts.map((p) {
      if (p.isEmpty) return '';
      return p[0].toUpperCase() + p.substring(1).toLowerCase();
    }).join(' ').trim();
  }

  Future<void> _saveToPrefs(UserModel user) async {
    try {
      final prefs = _preferences ?? await SharedPreferences.getInstance();
      await prefs.setString(_prefKeyUid, user.uid);
      await prefs.setString(_prefKeyEmail, user.email);
      if (user.displayName != null) {
        await prefs.setString(_prefKeyDisplayName, user.displayName!);
      }
      if (user.photoUrl != null) {
        await prefs.setString(_prefKeyPhotoUrl, user.photoUrl!);
      }
      if (user.department != null) {
        await prefs.setString(_prefKeyDepartment, user.department!);
      }
    } catch (_) {}
  }

  Future<void> _clearFromPrefs() async {
    try {
      final prefs = _preferences ?? await SharedPreferences.getInstance();
      await prefs.remove(_prefKeyUid);
      await prefs.remove(_prefKeyEmail);
      await prefs.remove(_prefKeyDisplayName);
      await prefs.remove(_prefKeyPhotoUrl);
      await prefs.remove(_prefKeyDepartment);
    } catch (_) {}
  }

  Future<UserModel> signUp({
    required String email,
    required String password,
    String? displayName,
    String? department,
    String? photoUrl,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final cleanUid = 'user_${cleanEmail.replaceAll(RegExp(r'[^a-z0-9]'), '_')}';
    final resolvedName = (displayName != null && displayName.trim().isNotEmpty)
        ? displayName.trim()
        : _deriveDisplayName(cleanEmail);

    final user = UserModel(
      uid: cleanUid,
      email: cleanEmail,
      displayName: resolvedName.isNotEmpty ? resolvedName : 'Estudiante UC',
      photoUrl: (photoUrl != null && photoUrl.trim().isNotEmpty)
          ? photoUrl.trim()
          : 'panda',
      department: (department != null && department.trim().isNotEmpty)
          ? department.trim()
          : 'Pregrado UC',
      emailVerified: true,
      createdAtMillis: DateTime.now().millisecondsSinceEpoch,
    );

    _accounts[cleanEmail] = _FakeAccount(
      email: cleanEmail,
      password: password,
      userModel: user,
    );

    _currentUser = user;
    _cachedPersistedUser = user;
    _controller.add(_currentUser);
    await _saveToPrefs(user);
    return user;
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    if (password == 'wrong') {
      throw Exception('Credenciales incorrectas');
    }

    final cleanEmail = email.trim().toLowerCase();
    final existingAccount = _accounts[cleanEmail];

    final UserModel user;
    if (existingAccount != null) {
      user = existingAccount.userModel;
    } else {
      final cleanUid = 'user_${cleanEmail.replaceAll(RegExp(r'[^a-z0-9]'), '_')}';
      final resolvedName = _deriveDisplayName(cleanEmail);

      user = UserModel(
        uid: cleanUid,
        email: cleanEmail,
        displayName: resolvedName.isNotEmpty ? resolvedName : 'Estudiante UC',
        department: 'Pregrado UC',
        emailVerified: true,
        createdAtMillis: DateTime.now().millisecondsSinceEpoch,
      );

      _accounts[cleanEmail] = _FakeAccount(
        email: cleanEmail,
        password: password,
        userModel: user,
      );
    }

    _currentUser = user;
    _cachedPersistedUser = user;
    _controller.add(_currentUser);
    await _saveToPrefs(user);
    return user;
  }

  Future<void> sendPasswordReset(String email) async {
    // Simula envío exitoso
  }

  Future<void> signOut() async {
    _currentUser = null;
    _cachedPersistedUser = null;
    _controller.add(null);
    await _clearFromPrefs();
  }

  Future<void> deleteAccount() async {
    if (_currentUser != null) {
      _accounts.remove(_currentUser!.email.trim().toLowerCase());
      _currentUser = null;
      _cachedPersistedUser = null;
      _controller.add(null);
      await _clearFromPrefs();
    }
  }

  void dispose() {
    _controller.close();
  }
}
