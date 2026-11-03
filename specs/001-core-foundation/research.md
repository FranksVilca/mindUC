# Research: 001-core-foundation Technical Architecture

## 1. Stack Tecnológico y Compatibilidad

### 1.1 Entorno de Ejecución
- **Flutter SDK**: `3.44.4 (stable)`
- **Dart SDK**: `3.12.2` con `sound null safety` estricto.
- **Plataformas Objetivo**: Android (minSdkVersion 21, targetSdkVersion 34) e iOS (iOS 14.0+).

### 1.2 Dependencias Principales y Versiones Compatibles
| Paquete | Versión Recomendada | Propósito |
| :--- | :--- | :--- |
| `flutter_riverpod` | `^2.6.1` | Gestión de estado reactivo, inyección de dependencias y desacoplamiento. |
| `go_router` | `^14.6.2` | Enrutamiento declarativo, soporte de `StatefulShellRoute.indexedStack`. |
| `firebase_core` | `^3.8.0` | Inicialización del SDK de Firebase. |
| `firebase_auth` | `^5.3.3` | Gestión de sesiones de usuario (registro institucional `@uc.cl`, login, password reset). |
| `cloud_firestore` | `^5.5.0` | Base de datos NoSQL reactiva con soporte Offline-First (`Settings(persistenceEnabled: true)`). |
| `google_fonts` | `^6.2.1` | Tipografía Plus Jakarta Sans / Nunito / Inter para reproducir Figma. |
| `flutter_svg` | `^2.0.16` | Renderizado de iconografía vectorial fiel a Figma. |
| `flutter_secure_storage`| `^9.2.2` | Almacenamiento seguro en Keychain (iOS) y Keystore (Android) para tokens y Diario. |
| `shared_preferences` | `^2.3.3` | Almacenamiento de preferencias ligeras de interfaz y modo oscuro/claro. |
| `flutter_animate` | `^4.5.2` | Micro-animaciones orgánicas y suaves (respiración, transiciones de pantalla). |
| `mocktail` | `^1.0.4` | Mocking en tests unitarios sin generación de código pesada. |
| `flutter_lints` | `^5.0.0` | Reglas oficiales de análisis estático recomendadas por el equipo de Flutter. |

---

## 2. Decisiones de Diseño y Extracción de Tokens desde Figma

A partir del análisis exhaustivo de los 12 mockups oficiales en `docs/mockups/`, se extraen los tokens del Sistema de Diseño:

### 2.1 Paleta de Colores Semántica
- **Fondo Primario de Aplicación (Background)**: `#FBF9F4` (Blanco hueso / crema suave sereno).
- **Superficie de Tarjetas (Surface)**: `#FFFFFF` con variantes tintadas según categoría:
  - Tinte Autocuidado / Respiración: `#EAF1ED` (Verde agua pastel).
  - Tinte Trabajo / Estudio UC: `#EBE8F7` (Lavanda suave).
  - Tinte Salud Mental / Desahogo: `#FCE7E1` (Melocotón / Durazno suave).
  - Tinte Descanso: `#E5F0F5` (Celeste tenue).
- **Color de Acento Primario (Primary Brand)**: `#718E81` (Verde Salvia Serena / Forest Whisper).
- **Contraste sobre Primario (On Primary)**: `#FFFFFF`.
- **Textos**:
  - Principal (Heading/Titles): `#222E28` o `#2D3748` (Gris oscuro carbón no estridente).
  - Secundario (Body/Subtitles): `#5C6B64` o `#718096`.
  - Terciario (Captions/Meta): `#8F9E96` o `#A0AEC0`.
- **Bordes y Divisores**: `#E5E0D5` / `#EDF2F7` (delgados, 1 dp o invisibles con elevación suave de 0 a 2 dp).

### 2.2 Geometría y Espaciados
- **Radios de Tarjetas (Card Radii)**: `20.0 dp` a `24.0 dp` (esquinas marcadamente redondeadas y amables).
- **Radios de Botones (Button Radii)**: `30.0 dp` (Pill buttons completos).
- **Radios de Chips**: `16.0 dp`.
- **Márgenes Laterales**: `20.0 dp` a `24.0 dp` en vistas principales; `16.0 dp` en paddings internos de tarjeta.

---

## 3. Arquitectura de Navegación con GoRouter

Los mockups validan 4 destinos persistentes en el `BottomNavigationBar`:
1. **Inicio** (`/home`): Dashboard de bienestar, selector de estado de ánimo ("¿Cómo te sientes en este momento?"), y accesos rápidos.
2. **Bienestar** (`/wellness`): Hub "Sanctuary Mode" con accesos a Respiración, Diario, Concentración.
3. **Agenda** (`/agenda`): Vista de "Mi Agenda Consciente" con calendario semanal, filtros y lista de tareas.
4. **Perfil** (`/profile`): Datos del estudiante UC, preferencias de bienestar y botón directo a Línea de Apoyo Psicológico.

### 3.1 Sub-Rutas y Modales
- `/auth`: Pantalla modal/raíz de Bienvenida y Autenticación con Firebase.
- `/scheduler-modal`: Agendador modal interactivo por voz desplegable desde el botón flotante de Agenda.
- `/breathing-session`: Sesión activa de respiración a pantalla completa.
- `/pomodoro-session`: Pantalla enfocada de Pomodoro y paisaje sonoro.
- `/journal/new`: Redacción de nueva entrada reflexiva.
- `/forum`: Comunidad UC consciente.

El uso de `StatefulShellRoute.indexedStack` garantiza que al alternar entre `Inicio`, `Bienestar`, `Agenda` y `Perfil`, no se pierda la posición de scroll ni los filtros seleccionados por el usuario.

---

## 4. Estrategia de Firebase y Desacoplamiento (Clean Architecture)

Para cumplir con la Constitución v1.1.0:
- Las clases de la capa `presentation` **NUNCA** importarán `cloud_firestore` ni `firebase_auth`.
- `features/auth/domain/` define la entidad `UserEntity` y la interfaz abstracta `AuthRepository`.
- `features/auth/data/` implementa `FirebaseAuthDataSource` y `AuthRepositoryImpl`.
- Para pruebas de widgets y unitarias, se provee `FakeAuthRepository` y `FakeFirestoreDataSource`, permitiendo probar toda la interfaz y flujos sin conexión a internet y sin requerir un proyecto real de Firebase activo en el entorno de desarrollo local.

