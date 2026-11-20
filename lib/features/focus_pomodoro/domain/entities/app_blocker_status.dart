/// Estados operativos del sistema de bloqueo de aplicaciones
/// para garantizar transparencia técnica con el usuario (sin simulaciones falsas).
enum BlockerPermissionStatus {
  /// Bloqueo desactivado manualmente por el usuario.
  inactive,

  /// Bloqueo activo y operativo en el sistema.
  active,

  /// Bloqueo encendido por el usuario, pero con permisos del SO pendientes (Usage Stats / Superposición).
  pendingPermissions,

  /// Entorno Web o sin soporte a nivel de SO para bloquear aplicaciones de terceros.
  webRestricted,
}

extension BlockerPermissionStatusX on BlockerPermissionStatus {
  String get label {
    switch (this) {
      case BlockerPermissionStatus.inactive:
        return 'Inactivo';
      case BlockerPermissionStatus.active:
        return 'Activo (Bloqueo en curso)';
      case BlockerPermissionStatus.pendingPermissions:
        return 'Pendiente de permisos';
      case BlockerPermissionStatus.webRestricted:
        return 'Restricción Web';
    }
  }

  String get description {
    switch (this) {
      case BlockerPermissionStatus.inactive:
        return 'El bloqueo no está operando en este momento.';
      case BlockerPermissionStatus.active:
        return 'Las aplicaciones seleccionadas se encuentran bloqueadas durante tu sesión de concentración.';
      case BlockerPermissionStatus.pendingPermissions:
        return 'Se requieren permisos del sistema ("Acceso a datos de uso" y "Superposición") para bloquear apps.';
      case BlockerPermissionStatus.webRestricted:
        return 'En navegador web, la política de seguridad del navegador no permite bloquear apps externas del dispositivo.';
    }
  }
}
