# Research: 002-auth-welcome Technical Architecture

## 1. Diseño Visual e Inspección de Figma

A partir del mockup oficial `mindUC - Bienvenida y Autenticación.png`:
- **Top Bar**:
  - Icono atrás `<` (para cuando se invoca como subruta)
  - Título centrado: `MINDUC - Bienvenida Y Autenticación`
  - Icono de perfil circular a la derecha.
- **Hero / Emblema Central**:
  - Emblema circular con fondo verde agua suave (`#EAF1ED` / `#D4E5DC`), conteniendo un icono botánico estilizado (árbol/brote sereno).
- **Badge Contextual**:
  - Píldora con fondo lavanda claro (`#EBE8F7`) y texto/icono morado suave (`#7B72B8`): `🌱 Espacio de Bienestar Estudiantil`.
- **Tipografía y Mensajes**:
  - Titular: "Encuentra tu centro en el ritmo universitario" (Plus Jakarta Sans Bold 24sp).
  - Subtitular: "Un espacio seguro y compasivo para cultivar tus hábitos, claridad mental y paz interior." (Plus Jakarta Sans Regular 14sp, color gris sereno).
- **Contenedor Principal de Autenticación**:
  - Tarjeta con fondo blanco o superficie sutil (`#FFFFFF`), bordes redondeados (radio 24 dp).
  - Selector segmentado animado con dos pestañas:
    - `[->] Iniciar sesión` (icono de login + texto)
    - `[User+] Registrarse` (icono de usuario + texto)
  - Campo 1: "Correo institucional o personal" con icono de sobre y placeholder `camila.soto@uc.cl`.
  - Campo 2: Fila de etiquetas con "Contraseña" a la izquierda y enlace "¿Olvidaste tu contraseña?" a la derecha. Campo con icono de candado, enmascarado y botón de ojo de visibilidad.
  - Campo adicional (en modo Registrarse): "Nombre y carrera" (ej. "Camila Soto · Psicología").
  - Botón primario: Píldora verde serena (`#A6BCB2` o `#718E81`) con icono de campana y texto "🔔 Ingresar a mi espacio" o "Crear mi cuenta".
- **Pie de Página (Tagline)**:
  - `• Ritmo guiado • Diario reflexivo • Calma activa •` (texto secundario con bullets de color verde).

---

## 2. Gestión de Estado con Riverpod

Se implementará un `AuthUiController` (`StateNotifier<AuthUiState>` o `Notifier<AuthUiState>`) que modele:
- `isLoginMode`: boolean (true = Iniciar sesión, false = Registrarse)
- `isPasswordVisible`: boolean (para el toggle de texto claro / oculto)
- `isLoading`: boolean (para mostrar `CircularProgressIndicator` en el botón)
- `errorMessage`: String? (para mostrar mensajes de error no invasivos y empáticos)
- `isResetEmailSent`: boolean (para el flujo de recuperación de clave)

---

## 3. Redirección de GoRouter (`redirect` Guard)

En `lib/core/router/app_router.dart`:
- Se agrega la ruta `AppRoutes.auth` (`/auth`).
- El enrutador GoRouter escucha los cambios de estado del usuario (`authStateChangesProvider` o un `Listenable` derivado).
- Si el usuario **no está autenticado** y la ruta actual es una ruta protegida del shell (`/home`, `/wellness`, `/agenda`, `/profile`), se redirige a `/auth`.
- Si el usuario **está autenticado** e intenta navegar a `/auth`, se le redirige automáticamente a `/home`.
