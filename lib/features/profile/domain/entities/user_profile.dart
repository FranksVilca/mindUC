/// Representa la identidad institucional y académica del estudiante en mindUC.
class UserProfile {
  final String id;
  final String fullName;
  final String career;
  final String universityEmail;
  final String? avatarUrl;
  final bool isMindfulActive;

  const UserProfile({
    required this.id,
    required this.fullName,
    required this.career,
    required this.universityEmail,
    this.avatarUrl,
    this.isMindfulActive = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'career': career,
        'universityEmail': universityEmail,
        'avatarUrl': avatarUrl,
        'isMindfulActive': isMindfulActive,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String? ?? 'student_uc_001',
      fullName: json['fullName'] as String? ?? 'Estudiante UC',
      career: json['career'] as String? ?? 'Pregrado UC',
      universityEmail: json['universityEmail'] as String? ?? 'estudiante@uc.cl',
      avatarUrl: json['avatarUrl'] as String?,
      isMindfulActive: json['isMindfulActive'] as bool? ?? true,
    );
  }

  UserProfile copyWith({
    String? id,
    String? fullName,
    String? career,
    String? universityEmail,
    String? avatarUrl,
    bool? isMindfulActive,
  }) {
    return UserProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      career: career ?? this.career,
      universityEmail: universityEmail ?? this.universityEmail,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isMindfulActive: isMindfulActive ?? this.isMindfulActive,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          fullName == other.fullName &&
          career == other.career &&
          universityEmail == other.universityEmail &&
          avatarUrl == other.avatarUrl &&
          isMindfulActive == other.isMindfulActive;

  @override
  int get hashCode => Object.hash(
        id,
        fullName,
        career,
        universityEmail,
        avatarUrl,
        isMindfulActive,
      );
}

