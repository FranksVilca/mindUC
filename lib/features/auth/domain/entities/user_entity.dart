/// Entidad pura de dominio que representa a un estudiante usuario en mindUC.
class UserEntity {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? department;
  final bool isEmailVerified;
  final bool isAnonymous;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.department,
    required this.isEmailVerified,
    required this.isAnonymous,
    required this.createdAt,
  });

  /// Determina si el correo pertenece al dominio institucional de la UC.
  bool get isInstitutional => email.toLowerCase().endsWith('@uc.cl');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode => Object.hash(id, email);

  @override
  String toString() => 'UserEntity(id: $id, email: $email, name: $displayName)';
}
