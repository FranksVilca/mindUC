# Quickstart: 011-profile-settings

## Automated Verification

### 1. Unit Tests
Ejecutar las pruebas del controlador y la capa de datos:

```bash
flutter test test/unit/features/profile/profile_controller_test.dart
```

Cubre:
- Carga inicial del perfil de Camila Soto con los datos de Figma.
- Alternancia del interruptor de recordatorios conscientes (`toggleConsciousReminders`).
- Selección de sonido ambiental predeterminado (`selectAmbientSound`).
- Selección de técnica de respiración favorita (`selectBreathingTechnique`).
- Cierre de sesión (`logout`).

### 2. Widget Tests
Ejecutar las pruebas de componentes visuales e integración de pantalla:

```bash
flutter test test/widget/features/profile/profile_cards_test.dart
flutter test test/widget/features/profile/profile_screen_test.dart
```

Cubre:
- Renderizado de la cabecera `ProfileHeader` con identidad "mindUC" y "Perfil".
- Renderizado de `StudentIdentityCard` con avatar, punto verde, carrera y correo.
- Interacción con `WellnessPreferencesCard` (cambio de switch y apertura de modales).
- Renderizado de `InstitutionalSupportCard` y apertura del modal de llamada con "Llamar ↗".
- Botón de cierre de sesión con diálogo de confirmación compasivo.

### 3. Suite Completa y Análisis Estático
```bash
flutter test
dart analyze
```

---

## Manual Verification (Figma Parity)

1. Abrir la aplicación y navegar a la pestaña **Perfil** en la barra de navegación inferior.
2. Comprobar que la tarjeta de identidad muestra:
   - Avatar con indicador circular verde.
   - "Camila Soto", "Psicología", "camila.soto@uc.cl".
3. Comprobar la sección "PREFERENCIAS DE BIENESTAR":
   - Tocar "Sonido ambiental predeterminado" y seleccionar "Bosque al atardecer".
   - Tocar "Técnica de respiración favorita" y seleccionar "Respiración 4–7–8".
   - Alternar el switch de "Recordatorios conscientes" y verificar que el estado cambia fluidamente sin parpadeos.
4. Comprobar la sección "SOPORTE INSTITUCIONAL":
   - Tocar "Llamar ↗" y verificar el diálogo con la línea confidencial UC (`*4000` / `+56 9 1234 5678`).
5. Comprobar "Cerrar sesión en este dispositivo":
   - Presionar el botón, confirmar el diálogo y verificar que redirige a `/login`.

