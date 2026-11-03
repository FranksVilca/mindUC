# Feature Specification: 001-core-foundation

**Feature Name**: Cimientos de la Aplicación, Sistema de Diseño Figma/Material 3, Shell de Navegación GoRouter y Capa de Datos Firebase  
**Feature Branch**: `001-core-foundation`  
**Created**: 2026-11-02  
**Status**: Draft / Ready for Plan  
**Input**: "Configuración base de Flutter, sistema de diseño centralizado Material 3/Figma, navegación GoRouter de 4 pestañas y capa de datos Firebase"  

---

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Sistema de Diseño y Tema Visual Fiel a Figma (Priority: P1)

Como desarrollador y usuario de mindUC, deseo que la aplicación cuente con un sistema de diseño centralizado basado en Material Design 3 adaptado con fidelidad milimétrica a los 12 mockups oficiales de Figma, para que todas las pantallas mantengan una atmósfera serena, compasiva, consistente y armónica.

**Why this priority**: Es el pilar fundamental que define la identidad visual de bienestar estudiantil de mindUC (paleta de colores suaves, curvaturas de 16-24 dp, tipografías legibles y componentes atómicos reutilizables). Ninguna pantalla puede construirse correctamente sin este sistema.

**Independent Test**: Puede verificarse de forma independiente ejecutando la suite de widget tests de componentes visuales (`MindCard`, `MindButton`, `MindChip`, `MindInputField`) y una pantalla catálogo/showcase que renderiza todos los tokens de color, variantes de botones, estados (pressed, disabled, loading) y tarjetas.

**Acceptance Scenarios**:
1. **Given** la aplicación ejecutándose en modo claro (Light Theme), **When** se visualiza cualquier contenedor o tarjeta, **Then** el fondo general utiliza el tono crema relajante (`#FBF9F4` / `#F8F6F0`), con tarjetas en blanco o tintes suaves (`#FFFFFF`, `#EAF1ED`, `#EBE8F7`) con bordes redondeados de radio `20.0` a `24.0` dp y sombras sutiles sin estridencias.
2. **Given** un componente interactivo (`MindButton`), **When** se encuentra en estado primario, **Then** utiliza el color verde salvia sereno (`#8EA89D` o `#718E81`) con texto en contraste claro, y responde táctilmente con animaciones suaves de opacidad/elevación.
3. **Given** un componente de etiqueta o filtro (`MindChip`), **When** el usuario selecciona una categoría o estado emocional, **Then** cambia reactivamente su estado visual respetando el color de acento asignado a la categoría (Autocuidado, Estudio/UC, Descanso, Salud Mental).

---

### User Story 2 - Navegación Persistente de 4 Pestañas con GoRouter (Priority: P1)

Como estudiante universitario que usa mindUC, deseo una barra de navegación inferior de 4 pestañas (Inicio, Bienestar, Agenda, Perfil) que conserve el estado de cada vista al cambiar de pestaña y admita navegación jerárquica a modales y sub-flujos sin perder el contexto.

**Why this priority**: Proporciona el esqueleto estructural y de navegación de la aplicación validado en los mockups de Figma (`Inicio`, `Bienestar`, `Agenda`, `Perfil`), asegurando transiciones instantáneas y navegación declarativa robusta.

**Independent Test**: Puede verificarse navegando sucesivamente entre `Inicio`, `Bienestar`, `Agenda` y `Perfil`; alternar entre pestañas mantiene intacto el estado interno de cada una (StatefulShellRoute con IndexedStack) y permite navegar a subrutas modales y volver con el botón atrás del sistema o barra superior.

**Acceptance Scenarios**:
1. **Given** el usuario en la pantalla `Inicio`, **When** presiona el icono de `Bienestar` en la barra inferior, **Then** la vista cambia a la pantalla de Bienestar y el icono de la pestaña se resalta con el indicador activo sereno.
2. **Given** el usuario navegando en la pestaña `Agenda` habiendo seleccionado un día específico, **When** cambia a `Perfil` y regresa a `Agenda`, **Then** la vista de `Agenda` conserva exactamente el día y filtros previamente seleccionados sin reiniciarse.
3. **Given** el usuario en cualquier pestaña, **When** se invoca una ruta modal o subpantalla (ej. `/auth` o `/scheduler-modal`), **Then** la pantalla se abre sobre el shell o reemplaza la vista según la jerarquía definida, permitiendo regresar limpiamente a la pestaña de origen.

---

### User Story 3 - Capa de Datos, Abstracción de Repositorios y Conexión Firebase (Priority: P1)

Como arquitecto de software, deseo que la infraestructura de datos esté desacoplada en capas limpias y soporte Firebase (Firebase Auth y Cloud Firestore) bajo una arquitectura Offline-First y patrón repositorio, para que la persistencia remota sea confiable y la lógica de negocio permanezca 100% testeable sin depender de servicios externos en los tests.

**Why this priority**: Establece el contrato de persistencia oficial del proyecto (ratificado en la Constitución v1.1.0), permitiendo autenticación de estudiantes UC y sincronización reactiva en tiempo real y offline.

**Independent Test**: Pruebas unitarias de repositorios con fuentes de datos falsas (`MockDataSource`) validan la emisión reactiva de Streams, el mapeo de DTOs a Entidades de Dominio, y el manejo de fallos tipados (`Result<T, Failure>`).

**Acceptance Scenarios**:
1. **Given** una operación de acceso a datos sin conexión a internet, **When** el repositorio consulta o guarda información en Firestore, **Then** la capa de persistencia offline de Firestore almacena localmente los cambios y no bloquea ni crashea la interfaz.
2. **Given** una solicitud de autenticación o consulta de datos que falla por credenciales o timeout, **When** el repositorio procesa el error, **Then** retorna un `Failure` tipado (`AuthFailure`, `NetworkFailure`, `ServerFailure`) sin propagar excepciones crudas a la presentación.

---

### User Story 4 - Vistas Shell Base y Encabezados de Marca (Priority: P2)

Como usuario, deseo ver los encabezados contextuales en cada pestaña con el logotipo de `mindUC`, el indicador de sección, el acceso a notificaciones y el avatar de perfil, adaptado a los safe areas de dispositivos móviles modernos.

**Why this priority**: Completa la experiencia inicial de la aplicación, permitiendo a los desarrolladores contar con vistas funcionales verificables en las 4 secciones antes de montar la lógica específica de cada módulo.

**Independent Test**: Se ejecuta la aplicación en emulador o dispositivo (Android/iOS) y se verifica visualmente que las 4 pantallas muestran el Top Bar correcto con el espaciado adecuado bajo la barra de estado del sistema (notch / dynamic island).

**Acceptance Scenarios**:
1. **Given** la aplicación abierta en cualquier dispositivo móvil, **When** se visualiza la cabecera, **Then** el logotipo `mindUC` y el subtítulo de sección aparecen alineados con márgenes de 20 dp, con la campana de notificaciones y el avatar de usuario en el extremo derecho.
2. **Given** el usuario tocando el avatar de perfil o la campana, **When** se interactúa con estos botones, **Then** se desencadena la navegación o acción esperada sin desbordamientos de renderizado (Zero RenderFlex overflow).

---

### Edge Cases

- **Dispositivos con pantallas pequeñas (menores a 360dp de ancho)**: La barra de navegación inferior y los textos del Top Bar deben adaptarse mediante el uso de `SingleChildScrollView` o escalas tipográficas elásticas para evitar desbordamientos de píxeles (`A RenderFlex overflowed`).
- **Pérdida súbita de conectividad**: La inicialización de Firebase no debe bloquear el renderizado del primer frame de la aplicación ni dejar la pantalla en blanco; debe arrancar con caché local o modo sin conexión.
- **Tokens o configuraciones de Firebase no provistas en entornos de CI/Test**: La arquitectura debe permitir arrancar la aplicación en modo Mock / Development sin requerir un archivo `google-services.json` obligatorio para pruebas de widgets unitarias.
- **Navegación hacia atrás en Android (Back button físico/gestual)**: El botón atrás del sistema en pestañas secundarias debe retornar a la pestaña inicial (`Inicio`) antes de salir de la aplicación, conforme a las directrices de UX de Material 3 y GoRouter.

---

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: El sistema DEBE proveer un tema visual centralizado `AppTheme` con soporte completo para la paleta de colores de mindUC extraída de los mockups (Verde Salvia primario `#718E81` / `#8EA89D`, Fondo sereno `#FBF9F4`, Superficie `#FFFFFF`, Lavanda `#D7D3F3`, Menta suave `#EAF1ED`, Durazno `#FCE7E1`, Texto principal `#2D3748`).
- **FR-002**: El sistema DEBE implementar componentes reutilizables atómicos:
  - `MindButton`: Botón píldora con soporte para estados filled, outlined, loading, disabled y variantes de tamaño.
  - `MindCard`: Contenedor elevado o plano con radio de 20-24 dp, padding estándar y colores semánticos.
  - `MindChip`: Etiqueta seleccionable y filtrable con indicador de punto de color o icono.
  - `MindInputField`: Campo de texto con estilo minimalista, bordes redondeados y soporte para prefijos de icono y validación.
  - `MindBottomNavBar`: Barra inferior estilizada con 4 destinos persistentes e indicadores visuales de pestaña activa.
- **FR-003**: El sistema DEBE configurar `GoRouter` con arquitectura `StatefulShellRoute.indexedStack` enlazando 4 ramas independientes:
  - `/home` (`InicioScreen`)
  - `/wellness` (`BienestarScreen`)
  - `/agenda` (`AgendaScreen`)
  - `/profile` (`PerfilScreen`)
- **FR-004**: El sistema DEBE estructurar el proyecto en capas limpias bajo convención `features/` y `core/`:
  - `core/theme/`: Definición de ThemeData, estilos de texto, colores y espaciados.
  - `core/design_system/`: Componentes atómicos de interfaz.
  - `core/router/`: Configuración declarativa de rutas y observadores.
  - `core/error/`: Clases base de excepciones, fallos (`Failure`) y tipo `Result<T, Failure>`.
  - `core/storage/`: Abstracciones de almacenamiento local seguro y caché.
  - `core/firebase/`: Módulo de inicialización segura de Firebase e inyección de servicios.
- **FR-005**: El sistema DEBE implementar interfaces de repositorio en `domain` para autenticación y persistencia, garantizando que ninguna vista consuma directamente el SDK de Firebase.
- **FR-006**: El sistema DEBE configurar Riverpod con `ProviderScope` en la raíz de la aplicación para gestión de estado reactivo y proveedores de dependencias.
- **FR-007**: El sistema DEBE compilar limpiamente bajo `flutter analyze` con cero advertencias y cero errores estáticos en modo `sound null safety`.

---

### Key Entities *(include if feature involves data)*

- **UserSession**: Representa la sesión del estudiante autenticado (`userId`, `email`, `displayName`, `photoUrl`, `isEmailVerified`, `isAnonymous`).
- **NavDestination**: Define un ítem de navegación del shell (`index`, `label`, `icon`, `selectedIcon`, `initialLocation`).
- **AppThemeTokens**: Modelo semántico de tokens de diseño (`primary`, `onPrimary`, `background`, `surface`, `wellnessGreen`, `calmPurple`, `focusPink`, `radii`, `spacings`).
- **Result<T, Failure>**: Tipo sumatorio (monádico funcional) para modelar éxito con datos `T` o fracaso tipado `Failure` sin excepciones descontroladas.

---

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: El proyecto Flutter compila y ejecuta exitosamente en simulador/dispositivo Android e iOS, mostrando el primer frame en menos de 1.5 segundos.
- **SC-002**: Las 4 pestañas de navegación (`Inicio`, `Bienestar`, `Agenda`, `Perfil`) alternan instantáneamente (< 16 ms / 60-120 fps) sin saltos visuales ni reinicio de estado.
- **SC-003**: 100% de los componentes visuales del sistema de diseño cuentan con pruebas de widget (`test/widget/`) aprobadas que verifican dimensiones, radios y temas.
- **SC-004**: El análisis estático (`flutter analyze`) reporta 0 advertencias, 0 errores y cumple con las directrices de Clean Architecture de la Constitución.
- **SC-005**: La interfaz base coincide visualmente en jerarquía, paleta, radios de curvatura y márgenes con los mockups oficiales de Figma sin desbordamientos de pantalla.

---

## Assumptions

- Se utiliza Flutter en versión 3.44+ y Dart 3.12+ instalados en el entorno de desarrollo.
- El proyecto se inicializará directamente en la raíz de `c:\Users\Usuario\Desktop\Code\mindUC` con organización `com.minduc` y nombre de proyecto `minduc`.
- La configuración de Firebase (`google-services.json` y `GoogleService-Info.plist`) se integrará de manera desacoplada con soporte para emuladores locales o inicialización condicional para permitir pruebas continuas sin bloquear el desarrollo UI.
- Los módulos de IA conversacional y Bloqueo nativo a nivel SO permanecen fuera del alcance de esta especificación conforme a la enmienda de la Constitución v1.1.0.
