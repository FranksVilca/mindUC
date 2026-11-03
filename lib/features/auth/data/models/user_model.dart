import '../../domain/entities/user_entity.dart';

/// DTO de usuario para persistencia en Firestore y Firebase Auth.
class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? department;
  final bool emailVerified;
  final int createdAtMillis;

  const UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.department,
    required this.emailVerified,
    required this.createdAtMillis,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> json, String id) {
    return UserModel(
      uid: id,
      email: json['email'] as String? ?? '',
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      department: json['department'] as String?,
      emailVerified: json['emailVerified'] as bool? ?? false,
      createdAtMillis: json['createdAt'] as int? ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'department': department,
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
      department: department,
      isEmailVerified: emailVerified,
      isAnonymous: false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMillis),
    );
  }

  factory UserModel.fromDomain(UserEntity entity) {
    return UserModel(
      uid: entity.id,
      email: entity.email,
      displayName: entity.displayName,
      photoUrl: entity.photoUrl,
      department: entity.department,
      emailVerified: entity.isEmailVerified,
      createdAtMillis: entity.createdAt.millisecondsSinceEpoch,
    );
  }
}

