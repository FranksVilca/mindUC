# Feature Specification: 011-profile-settings

**Feature Branch**: `011-profile-settings`

**Created**: 2026-11-03

**Status**: Ready for Planning

**Input**: User description: "/speckit-specify 011-profile-settings"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Identidad del Estudiante y Cabecera de Perfil (Priority: P1) 🎯 MVP

Como estudiante de la universidad,
quiero ver mi información de perfil institucional (nombre, carrera, correo y estado sereno) y una cabecera armónica en la pestaña de Perfil,
para confirmar mi identidad y sentirme en un entorno seguro y personalizado.

**Why this priority**: Es la base visual y estructural de la pantalla de perfil. Permite a la estudiante reconocer su espacio personal dentro de la aplicación con la identidad institucional correcta.

**Independent Test**: Navegar a la pestaña "Perfil" (`/profile`) en la barra inferior persistente y comprobar que se renderiza la cabecera "mindUC" / "Perfil", el avatar con indicador de presencia serena, "Camila Soto", "Psicología" y "camila.soto@uc.cl".

**Acceptance Scenarios**:

1. **Given** un estudiante con sesión iniciada en la aplicación, **When** accede a la pestaña "Perfil" (`/profile`), **Then** visualiza la cabecera superior con "mindUC", el título centrado "Perfil", los iconos de ajustes y cuenta, y la tarjeta de perfil con su foto/avatar, nombre completo "Camila Soto", carrera "Psicología" y correo institucional "camila.soto@uc.cl".
2. **Given** la tarjeta de perfil renderizada, **When** se observa el avatar, **Then** se muestra un indicador circular verde en la esquina inferior derecha que simboliza el estado de presencia activa y bienestar consciente.

---

### User Story 2 - Preferencias de Bienestar y Configuración Consciente (Priority: P2)

Como estudiante que cuida su ritmo de vida y estudio,
quiero consultar y ajustar mis preferencias de bienestar (sonido ambiental favorito, técnica de respiración y recordatorios de pausas activas),
para adaptar las sesiones de concentración y relajación a mis necesidades personales.

**Why this priority**: Personaliza la experiencia del estudiante en los módulos de concentración (Pomodoro) y relajación (Respiración), y fomenta hábitos de autocuidado sin invasividad.

**Independent Test**: Interactuar con la tarjeta de "Preferencias de bienestar", modificar el interruptor de "Recordatorios conscientes" y verificar que el estado cambia reactivamente; abrir las opciones de sonido ambiental o técnica de respiración para verificar las alternativas disponibles.

**Acceptance Scenarios**:

1. **Given** la sección "PREFERENCIAS DE BIENESTAR", **When** se observa la lista de opciones, **Then** se muestran 3 preferencias: "Sonido ambiental predeterminado" ("Lluvia suave en el bosque"), "Técnica de respiración favorita" ("Caja 4–4–4"), y "Recordatorios conscientes" ("Pausas cada 2 horas de estudio").
2. **Given** el interruptor de "Recordatorios conscientes", **When** el usuario lo presiona para alternarlo, **Then** el switch cambia de estado reactivamente y la preferencia se almacena en el estado del perfil sin recargar la pantalla.
3. **Given** los ítems de "Sonido ambiental predeterminado" o "Técnica de respiración favorita", **When** el usuario toca uno de ellos, **Then** se despliega una hoja modal o selector compasivo que permite escoger entre los paisajes sonoros y técnicas de respiración oficiales de mindUC.

---

### User Story 3 - Acceso Inmediato a Soporte Institucional Confidencial (Priority: P3)

Como estudiante que experimenta sobrecarga o crisis emocional,
quiero tener acceso directo, visible y protegido a la Línea de Apoyo Psicológico confidencial de la universidad,
para recibir contención oportuna de profesionales de la salud mental sin barreras ni estigmas.

**Why this priority**: Cumple con el Principio V de la Constitución (Protección en Crisis y Soporte Institucional), garantizando que la ayuda profesional esté siempre a un toque de distancia desde el perfil.

**Independent Test**: Pulsar el botón "Llamar ↗" en la tarjeta de Soporte Institucional y verificar que se despliega el diálogo informativo de contención con el anexo y teléfono confidencial de la UC.

**Acceptance Scenarios**:

1. **Given** la sección "SOPORTE INSTITUCIONAL", **When** el estudiante visualiza la tarjeta verde pastel con icono de auricular telefónico, **Then** lee "Línea de Apoyo Psicológico", "Anexo universitario confidencial", y el botón destacado "Llamar ↗".
2. **Given** el botón "Llamar ↗", **When** el estudiante lo pulsa, **Then** el sistema presenta un modal o acción de confirmación respetuosa para contactar al anexo institucional confidencial (`+56 9 1234 5678` / anexo `*4000`), explicando que la llamada es 100% gratuita y privada.

---

### User Story 4 - Cierre de Sesión Seguro en el Dispositivo (Priority: P4)

Como estudiante que utiliza un dispositivo compartido o desea cerrar su sesión,
quiero poder cerrar sesión de manera explícita y segura con un solo toque,
para proteger mi privacidad y regresar a la pantalla de bienvenida/login.

**Why this priority**: Garantiza la soberanía del estudiante sobre su sesión y el cumplimiento del Principio I y V de Privacidad por Diseño.

**Independent Test**: Presionar el botón "Cerrar sesión en este dispositivo", confirmar la acción en el diálogo y comprobar la redirección hacia `/login` con la sesión terminada.

**Acceptance Scenarios**:

1. **Given** el botón "Cerrar sesión en este dispositivo" al final de la pantalla, **When** el estudiante lo pulsa, **Then** se presenta un diálogo de confirmación compasivo que asegura que las reflexiones y datos permanecen a salvo.
2. **Given** el diálogo de confirmación de cierre de sesión, **When** el usuario confirma la acción, **Then** el sistema limpia las credenciales activas mediante el controlador de autenticación y navega a la pantalla de autenticación (`/login`).
3. **Given** el diálogo de confirmación, **When** el usuario presiona "Cancelar", **Then** el diálogo se cierra y el estudiante permanece en su perfil sin cambios.

---

### Edge Cases

- **Ausencia de imagen de perfil remota**: Si no hay imagen cargada en red o en caché, el sistema muestra un avatar ilustrado sereno con las iniciales del estudiante o un icono de silueta armónico con la paleta de colores de mindUC.
- **Desactivación de recordatorios**: Si el usuario desactiva el switch de recordatorios conscientes, la interfaz refleja el estado inactivo de forma neutral, sin advertencias punitivas ni mensajes de culpabilidad (Principio III).
- **Dispositivo sin soporte telefónico nativo (tablets / simulador)**: Si el dispositivo no puede iniciar llamadas telefónicas directamente, el diálogo modal proporciona el número y el anexo en texto seleccionable con opción de copiar al portapapeles.
- **Cancelación de selección modal de preferencias**: Si el usuario abre el selector de sonido o técnica y lo cierra sin elegir, la preferencia seleccionada previamente se mantiene intacta.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: El sistema DEBE proveer la pantalla de Perfil (`ProfileScreen`) en la ruta `/profile`, integrada en la pestaña 3 del `StatefulShellRoute`.
- **FR-002**: La cabecera superior DEBE mostrar el logotipo/identidad "mindUC", el título centrado "Perfil", y los iconos de ajustes (`Icons.tune_rounded`) y de cuenta personal.
- **FR-003**: La tarjeta de perfil DEBE presentar la foto o avatar del estudiante con el indicador de estado sereno en verde (`MindColors.primary`), el nombre ("Camila Soto"), la carrera ("Psicología") y el correo institucional ("camila.soto@uc.cl").
- **FR-004**: La sección de Preferencias de Bienestar DEBE presentar los ítems "Sonido ambiental predeterminado", "Técnica de respiración favorita" y "Recordatorios conscientes".
- **FR-005**: El ítem de sonido ambiental predeterminado DEBE permitir seleccionar entre al menos 4 paisajes sonoros (*Lluvia suave en el bosque*, *Bosque al atardecer*, *Océano calmo*, *Viento de montaña*).
- **FR-006**: El ítem de técnica de respiración favorita DEBE permitir seleccionar entre al menos 3 técnicas reconocidas (*Caja 4–4–4*, *Respiración 4–7–8*, *Respiración Abdominal*).
- **FR-007**: El switch de "Recordatorios conscientes" DEBE alternar reactivamente el estado de notificaciones de pausas de estudio cada 2 horas y actualizar el estado en memoria/repositorio.
- **FR-008**: La tarjeta de Soporte Institucional DEBE destacar la "Línea de Apoyo Psicológico" con subtítulo "Anexo universitario confidencial" y botón de llamada `"Llamar ↗"`.
- **FR-009**: Al presionar `"Llamar ↗"`, el sistema DEBE mostrar el diálogo modal de contención institucional con el número de contacto confidencial y opción de llamada directa.
- **FR-010**: El botón "Cerrar sesión en este dispositivo" DEBE invocar el método de cierre de sesión en `AuthController` / `ProfileNotifier` y redirigir al usuario a `AppRoutes.login`.
- **FR-011**: Todos los componentes visuales DEBEN respetar los tokens de diseño de `MindColors` y `MindTypography`, sin colores hexadecimales directos en las vistas.

### Key Entities *(include if feature involves data)*

- **UserProfile**: Entidad inmutable que representa la identidad del estudiante: `id`, `fullName`, `career`, `universityEmail`, `avatarUrl`, y `isActive`.
- **WellnessPreferences**: Value Object que agrupa las preferencias conscientes del estudiante: `defaultAmbientSound` (nombre del paisaje sonoro), `favoriteBreathingTechnique` (nombre de la técnica), y `consciousRemindersEnabled` (booleano).
- **InstitutionalSupportContact**: Value Object que modela el canal de contención universitaria: `title`, `description`, `phoneNumber`, `extensionNumber`, y `isConfidential`.
- **ProfileState**: Estado inmutable que encapsula el perfil del usuario, sus preferencias de bienestar, la información de contacto de soporte institucional y el estado de carga/error.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: La pantalla de Perfil carga y renderiza todos sus elementos (cabecera, perfil, preferencias, soporte y botón de salida) en menos de 100 ms tras pulsar la pestaña de Perfil.
- **SC-002**: El cambio en el interruptor de recordatorios conscientes o la selección de sonido/técnica se refleja inmediatamente en la interfaz (< 50 ms) sin saltos visuales ni parpadeos.
- **SC-003**: El flujo de cierre de sesión redirige de manera determinista a `/login` en el 100% de las pruebas automatizadas de integración.
- **SC-004**: Cobertura de pruebas del 100% en las capas de dominio, datos locales y presentación de la característica (pruebas unitarias y de widget).
- **SC-005**: 0 advertencias o errores en `dart analyze` y total conformidad con los principios I, II, III y V de la Constitución de mindUC.

## Assumptions

- Se utiliza el usuario institucional predeterminado "Camila Soto" (`camila.soto@uc.cl`, carrera "Psicología") conforme al mockup oficial de Figma.
- Las preferencias de bienestar se gestionan inicialmente mediante persistencia local reactiva (Clean Architecture con `LocalProfileDataSource` y `ProfileRepository`), lista para enlazar con Firestore en etapas posteriores.
- La acción de llamada a la línea psicológica despliega un modal amigable con la información oficial confidencial de la UC, protegiendo al estudiante y garantizando compatibilidad multiplataforma sin depender de hardware de telefonía en entornos de prueba.
- El cierre de sesión limpia el estado de autenticación y devuelve al flujo público de la aplicación.

