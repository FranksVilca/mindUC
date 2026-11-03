/// Modela el canal de contención y soporte psicológico universitario confidencial.
class InstitutionalSupportContact {
  final String title;
  final String description;
  final String phoneNumber;
  final String extensionNumber;
  final String availability;
  final bool isConfidential;

  const InstitutionalSupportContact({
    this.title = 'Línea de Apoyo Psicológico',
    this.description = 'Anexo universitario confidencial',
    this.phoneNumber = '+56 9 1234 5678',
    this.extensionNumber = '*4000',
    this.availability = 'Atención 24/7 confidencial para la comunidad UC',
    this.isConfidential = true,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InstitutionalSupportContact &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          description == other.description &&
          phoneNumber == other.phoneNumber &&
          extensionNumber == other.extensionNumber &&
          availability == other.availability &&
          isConfidential == other.isConfidential;

  @override
  int get hashCode => Object.hash(
        title,
        description,
        phoneNumber,
        extensionNumber,
        availability,
        isConfidential,
      );
}

