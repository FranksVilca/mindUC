# UI Contract: 011-profile-settings

## Controller Interface Contract

```dart
abstract class IProfileController {
  ProfileState get state;
  Future<void> loadProfile();
  Future<void> toggleConsciousReminders(bool enabled);
  Future<void> selectAmbientSound(String sound);
  Future<void> selectBreathingTechnique(String technique);
  Future<bool> logout();
}
```

---

## Widget Component Contracts

### 1. `ProfileHeader`
- **Props**:
  - `VoidCallback? onSettingsTap` (opcional: muestra diálogo de ajustes adicionales)
  - `VoidCallback? onAccountTap` (opcional)
- **Render**: Logotipo "mindUC", título centrado "Perfil", y dos iconos de acción a la derecha (`Icons.settings_outlined`, avatar oscuro `Icons.account_circle`).

### 2. `StudentIdentityCard`
- **Props**:
  - `required UserProfile user`
- **Render**: Tarjeta blanca con borde de 24dp, avatar circular de gran escala con punto verde de presencia serena en la esquina inferior derecha, "Camila Soto", "Psicología", y "camila.soto@uc.cl".

### 3. `WellnessPreferencesCard`
- **Props**:
  - `required WellnessPreferences preferences`
  - `required VoidCallback onSoundTap`
  - `required VoidCallback onTechniqueTap`
  - `required ValueChanged<bool> onRemindersChanged`
- **Render**:
  - Encabezado "PREFERENCIAS DE BIENESTAR" con icono `Icons.tune_rounded`.
  - Ítem 1: Sonido ambiental predeterminado (nube verde pastel, flecha chevron).
  - Ítem 2: Técnica de respiración favorita (aire lila pastel, flecha chevron).
  - Ítem 3: Recordatorios conscientes (campana menta pastel, `Switch.adaptive` activo/inactivo).

### 4. `InstitutionalSupportCard`
- **Props**:
  - `required InstitutionalSupportContact contact`
  - `required VoidCallback onCallTap`
- **Render**: Tarjeta en verde salvia pastel (`MindColors.autocuidado`), icono telefónico en círculo blanco, título "Línea de Apoyo Psicológico", subtítulo "Anexo universitario confidencial", y botón píldora "Llamar ↗".

### 5. `LogoutButton`
- **Props**:
  - `required VoidCallback onPressed`
  - `bool isLoading` (default false)
- **Render**: Botón de contorno blanco con icono de logout `Icons.logout_rounded` y texto "Cerrar sesión en este dispositivo".

### 6. Modales Auxiliares
- **`SupportContactModal`**: Diálogo modal respetuoso con el anexo `*4000`, número `+56 9 1234 5678`, botón "Llamar ahora" y botón "Copiar anexo".
- **`PreferenceSelectionModal`**: Hoja inferior (`showModalBottomSheet`) serena para seleccionar paisaje sonoro o técnica de respiración entre las opciones disponibles de mindUC.

