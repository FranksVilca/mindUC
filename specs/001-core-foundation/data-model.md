# Data Model: 001-core-foundation

## 1. Domain Entities & Value Objects

### 1.1 `UserEntity` (Domain)
Representa al estudiante usuario dentro de mindUC.

```dart
class UserEntity {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final bool isEmailVerified;
  final bool isAnonymous;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.isEmailVerified,
    required this.isAnonymous,
    required this.createdAt,
  });

  bool get isInstitutional => email.endsWith('@uc.cl');
}
```

### 1.2 `Result<T, Failure>` (Core Error Handling)
Monada sumatoria funcional para desacoplar el manejo de excepciones.

```dart
sealed class Result<T, E> {
  const Result();
  bool get isSuccess => this is Success<T, E>;
  bool get isFailure => this is FailureResult<T, E>;
}

class Success<T, E> extends Result<T, E> {
  final T data;
  const Success(this.data);
}

class FailureResult<T, E> extends Result<T, E> {
  final E error;
  const FailureResult(this.error);
}
```

### 1.3 `AppFailure` (Domain Error Taxonomy)
```dart
sealed class AppFailure {
  final String message;
  const AppFailure(this.message);
}

class AuthFailure extends AppFailure {
  final String? code;
  const AuthFailure(super.message, {this.code});
}

class NetworkFailure extends AppFailure {
  const NetworkFailure(super.message);
}

class CacheFailure extends AppFailure {
  const CacheFailure(super.message);
}

class ServerFailure extends AppFailure {
  const ServerFailure(super.message);
}
```

### 1.4 `NavDestination` (Core Navigation)
```dart
enum NavTab {
  inicio(0, 'Inicio', '/home'),
  bienestar(1, 'Bienestar', '/wellness'),
  agenda(2, 'Agenda', '/agenda'),
  perfil(3, 'Perfil', '/profile');

  final int index;
  final String label;
  final String routePath;
  const NavTab(this.index, this.label, this.routePath);
}
```

---

## 2. DTOs & Mappers (Data Layer)

### 2.1 `UserModel` (Data / Firebase DTO)
Mapea el documento de Firestore en la colección `users/{userId}` y el objeto `User` de `firebase_auth`.

```dart
class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final bool emailVerified;
  final int createdAtMillis;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.emailVerified,
    required this.createdAtMillis,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> json, String id) {
    return UserModel(
      uid: id,
      email: json['email'] as String? ?? '',
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      emailVerified: json['emailVerified'] as bool? ?? false,
      createdAtMillis: json['createdAt'] as int? ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'emailVerified': emailVerified,
      'createdAt': createdAtMillis,
    };
  }

  UserEntity toDomain() {
    return UserEntity(
      id: uid,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      isEmailVerified: emailVerified,
      isAnonymous: false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMillis),
    );
  }
}
```

---

## 3. Esquema de Firestore (Colecciones Iniciales)

```
users/
└── {userId} (document)
    ├── email: "camila.soto@uc.cl" (string)
    ├── displayName: "Camila Soto" (string)
    ├── department: "Psicología" (string)
    ├── createdAt: Timestamp
    └── preferences/ (subcollection o map)
        ├── favoriteBreathingTechnique: "Caja 4-4-4"
        ├── defaultAmbientSound: "Lluvia campus"
        └── consciousRemindersEnabled: true
```

