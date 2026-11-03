# Feature Specification: 002-auth-welcome

**Feature Name**: Bienvenida y Autenticación con Firebase  
**Feature Branch**: `002-auth-welcome`  
**Created**: 2026-11-02  
**Status**: Draft / Ready for Plan  
**Input**: "Bienvenida y Autenticación con Firebase: selector Iniciar sesión / Registrarse, validación de correo institucional @uc.cl o personal, recuperación de contraseña, diseño fiel a Figma y persistencia de sesión"  

---

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Inicio de Sesión Sereno y Acceso al Espacio Personal (Priority: P1) 🎯 MVP

Como estudiante de la UC o usuario de mindUC, deseo iniciar sesión con mi correo institucional (`@uc.cl`) o personal y contraseña en una interfaz visualmente tranquila y empática que refleje exactamente el mockup oficial de Figma, para acceder a mi espacio protegido de bienestar.

**Why this priority**: Es la puerta de entrada obligatoria para resguardar la privacidad de los datos personales del estudiante, el diario reflexivo y la agenda personal.

**Independent Test**: En la pantalla de autenticación, el usuario ingresa su correo y contraseña en la pestaña "Iniciar sesión", presiona el botón "Ingresar a mi espacio" y el sistema valida credenciales mediante `AuthRepository`, navegando automáticamente al shell principal (`/home`).

**Acceptance Scenarios**:
1. **Given** un estudiante registrado con correo `camila.soto@uc.cl` y contraseña válida, **When** ingresa sus datos y presiona "Ingresar a mi espacio", **Then** el botón muestra estado de carga (`isLoading`), se autentica exitosamente y es redirigido a `/home`.
2. **Given** un usuario que introduce una contraseña errónea o un correo no registrado, **When** presiona el botón de acceso, **Then** el sistema despliega un mensaje compasivo en el campo correspondiente (ej. "No pudimos encontrar una cuenta con esas credenciales") sin crashear la aplicación.
3. **Given** el campo de contraseña, **When** el usuario presiona el icono de ojo (`visibility`), **Then** la contraseña alterna suavemente entre texto oculto (`••••••`) y texto visible.

---

### User Story 2 - Selector Segmentado y Registro de Nuevos Estudiantes (Priority: P1)

Como nuevo estudiante universitario, deseo poder alternar con un toque entre "Iniciar sesión" y "Registrarse" en el mismo contenedor para crear mi cuenta ingresando mi correo (`@uc.cl` o personal), nombre y contraseña.

**Why this priority**: Permite la incorporación fluida de nuevos estudiantes a la comunidad sin fricciones ni formularios externos complicados.

**Independent Test**: Al pulsar la opción "Registrarse" en el selector segmentado, el contenedor transmuta sus campos mostrando un campo adicional para el nombre/carrera y el botón principal cambia su texto a "Crear mi cuenta", registrando al usuario en Firebase y creando su documento inicial en Cloud Firestore.

**Acceptance Scenarios**:
1. **Given** el usuario en la pantalla de bienvenida, **When** pulsa la pestaña "Registrarse", **Then** el selector segmentado anima su indicador blanco hacia la derecha y se habilitan los campos para registro.
2. **Given** un estudiante que ingresa un correo con dominio institucional (ej. `estudiante@uc.cl`), **When** completa el registro, **Then** el sistema asigna el flag `isInstitutional: true` y prepara el perfil con su departamento o carrera.
3. **Given** una contraseña con menos de 6 caracteres, **When** el usuario intenta registrarse, **Then** el campo de contraseña muestra validación preventiva antes de realizar la petición al servidor.

---

### User Story 3 - Recuperación de Contraseña sin Estrés (Priority: P2)

Como usuario que ha olvidado su clave, deseo pulsar el enlace "¿Olvidaste tu contraseña?" para solicitar un enlace de restablecimiento a mi correo electrónico sin abandonar la atmósfera de calma de la aplicación.

**Why this priority**: Evita la pérdida permanente de acceso a las reflexiones y hábitos de bienestar del estudiante.

**Independent Test**: Al hacer clic en "¿Olvidaste tu contraseña?", se despliega un diálogo o modal sereno solicitando el correo; al confirmar, se invoca `sendPasswordResetEmail` de `AuthRepository` y se notifica con un mensaje de confirmación claro.

**Acceptance Scenarios**:
1. **Given** el usuario en la pantalla de login, **When** presiona "¿Olvidaste tu contraseña?", **Then** se presenta un diálogo con el estilo visual de mindUC para ingresar el correo registrado.
2. **Given** un correo válido, **When** el usuario solicita el restablecimiento, **Then** se envía el correo a través de Firebase y se muestra una confirmación con tono tranquilizador ("Te hemos enviado un enlace para restablecer tu contraseña con calma").

---

### User Story 4 - Redirección Reactiva de Sesión en GoRouter (Priority: P1)

Como usuario ya autenticado, deseo que la aplicación reconozca mi sesión persistente al abrirse y me dirija directamente a `/home`, o me muestre `/auth` si no he iniciado sesión.

**Why this priority**: Garantiza una experiencia sin fricciones al abrir la app día a día.

**Independent Test**: El router escucha `authStateChangesProvider`; si el usuario está autenticado, cualquier intento de ir a `/auth` redirige a `/home`; si cierra sesión, es redirigido a `/auth`.

**Acceptance Scenarios**:
1. **Given** un usuario con sesión activa en `AuthRepository`, **When** la aplicación arranca, **Then** GoRouter redirige automáticamente a `/home`.
2. **Given** un usuario que presiona "Cerrar sesión en este dispositivo" desde la pantalla de Perfil, **When** la sesión se cierra, **Then** GoRouter redirige instantáneamente a `/auth`.

---

### Edge Cases

- **Usuario sin conexión a internet durante el login**: Se debe informar mediante un mensaje claro ("Sin conexión a internet. Revisa tu red para ingresar") sin bloquear la interfaz.
- **Formato de correo no válido**: Validación inmediata al perder el foco o antes de enviar.
- **Teclado virtual desplegado**: El contenido debe estar contenido en un `SingleChildScrollView` para evitar `RenderFlex overflow` en pantallas pequeñas cuando el teclado cubre más del 40% de la altura de pantalla.

---

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: La pantalla `WelcomeAuthScreen` DEBE coincidir en un 100% con la jerarquía y estética del mockup `mindUC - Bienvenida y Autenticación.png`:
  - Cabecera con título `mindUC - Bienvenida Y Autenticación` y botón de perfil/atrás.
  - Emblema central botánico circular con brote/árbol.
  - Etiqueta píldora: `🌱 Espacio de Bienestar Estudiantil` (`#EBE8F7` / `#7B72B8`).
  - Titular: "Encuentra tu centro en el ritmo universitario".
  - Subtitular: "Un espacio seguro y compasivo para cultivar tus hábitos, claridad mental y paz interior."
  - Pie de página sereno: `• Ritmo guiado • Diario reflexivo • Calma activa •`.
- **FR-002**: El sistema DEBE proveer un selector segmentado alternable con animación suave entre "Iniciar sesión" y "Registrarse".
- **FR-003**: El campo de correo DEBE soportar correos `@uc.cl` y correos personales, mostrando el placeholder oficial `camila.soto@uc.cl`.
- **FR-004**: El campo de contraseña DEBE contar con botón de visibilidad (icono de ojo) para alternar el enmascarado del texto.
- **FR-005**: El enlace "¿Olvidaste tu contraseña?" DEBE abrir un modal de recuperación de contraseña que consuma `sendPasswordResetEmail`.
- **FR-006**: El botón principal DEBE mostrar retroalimentación de carga (`CircularProgressIndicator`) mientras la operación asíncrona está en progreso.
- **FR-007**: GoRouter DEBE incorporar una regla de redirección (`redirect`) basada en el Stream de `authStateChangesProvider` para proteger las rutas del shell y gestionar el flujo de bienvenida.

---

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: El flujo de inicio de sesión y registro se completa en menos de 2 segundos en condiciones de red normales.
- **SC-002**: 100% de los estados interactivos (login, registro, validación, loading, error, visibilidad de clave) cuentan con pruebas de widgets automatizadas aprobadas.
- **SC-003**: Cero advertencias y cero errores en `dart analyze`.
- **SC-004**: Ningún desbordamiento de renderizado (`Zero RenderFlex overflow`) en emuladores de 4.7" a 6.7" con el teclado en pantalla desplegado.
