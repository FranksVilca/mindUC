# Research: 011-profile-settings

## Technical Context & Architectural Decisions

### 1. Principios Constitucionales Aplicables

- **Principio I (Clean Architecture Feature-First)**:
  - Todo el código residirá en `lib/features/profile/` estructurado en:
    - `domain/entities/`: `UserProfile`, `WellnessPreferences`, `InstitutionalSupportContact`, `ProfileState`.
    - `domain/repositories/`: `ProfileRepository` (interfaz abstracta pura, sin Flutter ni Firebase).
    - `data/datasources/`: `LocalProfileDataSource` (almacenamiento en memoria con valores de Figma).
    - `data/repositories/`: `ProfileRepositoryImpl` (implementación de repositorio retornando `Result<T, Failure>`).
    - `presentation/controllers/`: `ProfileNotifier` y `profileControllerProvider` (Riverpod `StateNotifier`).
    - `presentation/screens/`: `ProfileScreen`.
    - `presentation/widgets/`: `ProfileHeader`, `StudentIdentityCard`, `WellnessPreferencesCard`, `InstitutionalSupportCard`, `LogoutButton`, `SupportContactModal`, `PreferenceSelectionModal`.

- **Principio II (Spec-Driven & Test-First)**:
  - Cobertura completa de pruebas unitarias (`test/unit/features/profile/profile_controller_test.dart`) y de widgets (`test/widget/features/profile/profile_cards_test.dart`, `test/widget/features/profile/profile_screen_test.dart`).

- **Principio III (Fidelidad Visual Absoluta y Figma como Verdad Visual)**:
  - Réplica idéntica de `mindUC - Perfil y Configuracion.png`.
  - Uso estricto de `MindColors` y `MindTypography`. Bordes redondeados de 20-24dp, tarjetas con sombras suaves y paddings simétricos de 16-20dp.

- **Principio V (Privacidad por Diseño y Soporte en Crisis)**:
  - El botón "Llamar ↗" provee acceso directo al soporte confidencial sin solicitar permisos invasivos ni registrar datos del incidente en logs.
  - El cierre de sesión garantiza la limpieza segura del estado en memoria y la vuelta al flujo de login.

- **Principios VI y VII (Diferidos)**:
  - No se integran LLMs conversacionales externos ni bloqueos a nivel de sistema operativo en las preferencias.

---

### 2. Desglose Visual y Tokens de Diseño (Figma: `mindUC - Perfil y Configuracion.png`)

- **Cabecera (`ProfileHeader`)**:
  - Logotipo: `"mindUC"` en verde bosque (`Color(0xFF2C5E47)` / `MindColors.brandPrimary`, 20sp bold).
  - Título central: `"Perfil"` (17sp semi-bold, centrado).
  - Acciones derechas:
    - Icono de configuración (`Icons.settings_outlined`, 22dp, `MindColors.textSecondary`).
    - Avatar circular (`28x28`, fondo `Color(0xFF375E4D)`, icono de cuenta blanco).

- **Tarjeta de Identidad del Estudiante (`StudentIdentityCard`)**:
  - Contenedor blanco con bordes redondeados `24dp` y sombra sutil.
  - Avatar circular de gran escala (`radius: 54dp`):
    - Foto o ilustración con reborde sutil.
    - Indicador de estado de presencia consciente en la esquina inferior derecha: círculo verde (`Color(0xFF388E3C)` o `MindColors.primary`, diámetro `16dp`, con borde blanco de `2dp`).
  - Nombre completo: `"Camila Soto"` (22sp bold, `MindColors.textPrimary`).
  - Carrera: `"Psicología"` (14sp regular, `MindColors.textSecondary`).
  - Correo institucional: `"camila.soto@uc.cl"` (13sp regular, `MindColors.textTertiary`).

- **Sección "PREFERENCIAS DE BIENESTAR" (`WellnessPreferencesCard`)**:
  - Encabezado: Texto en mayúsculas `"PREFERENCIAS DE BIENESTAR"` (11.5sp, bold, tracking sutil) con icono de controles deslizantes a la derecha (`Icons.tune_rounded`, 16dp).
  - Tarjeta contenedora blanca con 3 filas separadas por `Divider(height: 1, color: MindColors.divider)`:
    1. **Sonido ambiental predeterminado**:
       - Icono: Nube (`Icons.cloud_outlined`) en círculo verde pastel (`Color(0xFFE8F2EC)`), icono `Color(0xFF2C5E47)`.
       - Título: `"Sonido ambiental predeterminado"` (14sp semi-bold).
       - Subtítulo: `"Lluvia suave en el bosque"` (13sp, `MindColors.textSecondary`).
       - Trailing: Flecha derecha (`Icons.chevron_right_rounded`, `MindColors.textTertiary`).
       - Opciones seleccionables: *Lluvia suave en el bosque*, *Bosque al atardecer*, *Océano calmo*, *Viento de montaña*, *Café acogedor*.
    2. **Técnica de respiración favorita**:
       - Icono: Aire/viento (`Icons.air_rounded`) en círculo lila pastel (`Color(0xFFEDEBF7)`), icono `Color(0xFF6C63FF)` / violeta sereno.
       - Título: `"Técnica de respiración favorita"` (14sp semi-bold).
       - Subtítulo: `"Caja 4–4–4"` (13sp, `MindColors.textSecondary`).
       - Trailing: Flecha derecha (`Icons.chevron_right_rounded`, `MindColors.textTertiary`).
       - Opciones seleccionables: *Caja 4–4–4*, *Respiración 4–7–8*, *Respiración Abdominal*, *Respiración Energizante*.
    3. **Recordatorios conscientes**:
       - Icono: Campana (`Icons.notifications_none_rounded` / `Icons.notifications_active_outlined`) en círculo menta pastel (`Color(0xFFE2F4EB)`), icono `Color(0xFF2C5E47)`.
       - Título: `"Recordatorios conscientes"` (14sp semi-bold).
       - Subtítulo: `"Pausas cada 2 horas de estudio"` (13sp, `MindColors.textSecondary`).
       - Trailing: `Switch.adaptive` reactivo (verde bosque activo `Color(0xFF2C5E47)`).

- **Sección "SOPORTE INSTITUCIONAL" (`InstitutionalSupportCard`)**:
  - Encabezado: `"SOPORTE INSTITUCIONAL"` con icono de escudo protector verde a la derecha (`Icons.shield_outlined`, 16dp, `Color(0xFF2C5E47)`).
  - Tarjeta en verde salvia pastel (`Color(0xFFDEEBE2)` / `MindColors.autocuidado`):
    - Icono de teléfono blanco sobre círculo blanco con icono verde (`Icons.phone_in_talk_rounded`, `Color(0xFF2C5E47)`).
    - Título: `"Línea de Apoyo Psicológico"` (14.5sp semi-bold, `MindColors.textPrimary`).
    - Subtítulo: `"Anexo universitario confidencial"` (12.5sp, `MindColors.textSecondary`).
    - Botón píldora: `"Llamar ↗"` con fondo verde oscuro (`Color(0xFF395C4B)`), texto blanco (12sp semi-bold), bordes redondeados `20dp`.
    - Diálogo modal de llamada confidencial: Muestra el anexo universitario `*4000`, número directo `+56 9 1234 5678`, horario 24/7 y confirmación respetuosa.

- **Botón de Cierre de Sesión (`LogoutButton`)**:
  - Botón blanco con borde sutil (`BorderSide(color: Color(0xFFE5E5E5))`), bordes redondeados `16dp`, altura `50dp`.
  - Icono de salida/logout (`Icons.logout_rounded`, color salmón/neutro `Color(0xFFD9534F)` o `MindColors.textSecondary`).
  - Texto centrado: `"Cerrar sesión en este dispositivo"` (14sp semi-bold, `MindColors.textPrimary`).
  - Acción: Despliega diálogo de confirmación compasivo. Al confirmar, ejecuta `ProfileNotifier.logout()` y redirige mediante GoRouter a `/login`.

---

### 3. Integración con el Enrutador y Navegación GoRouter

- En `lib/core/router/app_router.dart`, la rama 3 de `StatefulShellRoute` (`_profileNavigatorKey`) ya apunta a `AppRoutes.profile` (`/profile`).
- Se sustituirá el scaffold estático previo por el nuevo `ProfileScreen` desacoplado, conectado a `profileControllerProvider`.

