# mindUC Constitution

## Core Principles

### I. Arquitectura Limpia y Modularidad por Características (Feature-First)
El código de mindUC se organiza siguiendo **Clean Architecture** orientada a características (`features/`). Cada módulo funcional (Respiración, Agenda, Agendador, Foro, Diario, Gamificación, Asistente IA, Concentración) debe estructurarse estrictamente en tres capas desacopladas:
- **Presentation**: Widgets inmutables, vistas, controles de usuario y controladores de estado (Riverpod StateNotifiers/Notifiers).
- **Domain**: Entidades de negocio puras, Value Objects y casos de uso (`UseCases`), libres de dependencias de Flutter, Firebase y paquetes de terceros.
- **Data**: Modelos DTOs, implementaciones de repositorios, mapeadores y fuentes de datos (DataSources: locales y remotas).

Ningún componente de dominio dependerá de capas externas, SDKs de terceros ni de frameworks específicos.

### II. Desarrollo Guiado por Especificaciones y Verificación Continua (Spec-Driven & Test-First)
Todo desarrollo debe proceder bajo el ciclo riguroso de **Spec Kit**:
`Constitution → Specify (spec.md) → Clarify → Plan (plan.md) → Tasks (tasks.md) → Implement → Converge/Analyze`.
- **Prohibido el código huérfano**: Ninguna pantalla, modelo o servicio se implementará sin estar vinculado a una tarea trazable en `tasks.md`.
- **Pruebas Automatizadas**: Cada caso de uso dispondrá de pruebas unitarias (`test/unit/`), cada componente de diseño reutilizable dispondrá de pruebas de widget (`test/widget/`), y los flujos críticos de usuario (autenticación, temporizadores, agendador, diario) dispondrán de pruebas de integración.

### III. Fidelidad Visual Absoluta y Sistema de Diseño Centralizado (Figma como Verdad Visual)
Los mockups y guías de diseño de Figma constituyen la referencia visual inmutable del proyecto:
- Se implementará un **Sistema de Diseño Centralizado** (`core/theme/` y `core/design_system/`) que formalice paleta de colores serena, escala tipográfica, espaciados (márgenes de 16/24 dp), radios de curvatura (tarjetas con bordes de 16-24 dp), sombras y estados interactivos (pressed, disabled, focused).
- Queda prohibido usar colores hexadecimales "hardcodeados" o componentes nativos genéricos sin tematizar que alteren la identidad serena, compasiva y armoniosa de mindUC reflejada en los 12 mockups oficiales.

### IV. Gestión de Estado con Riverpod, Navegación GoRouter y Backend en Firebase
- **Riverpod** es el estándar mandatorio de gestión de estado reactivo, inyección de dependencias y ciclo de vida de recursos.
- **GoRouter** gestiona la navegación declarativa y jerárquica: implementa `StatefulShellRoute` para la navegación persistente de 4 pestañas de la barra inferior (*Inicio*, *Bienestar*, *Agenda*, *Perfil*) y subrutas modales anidadas.
- **Firebase como Plataforma de Datos y Autenticación**:
  - **Firebase Authentication**: Gestión segura de sesiones de usuario (registro institucional `@uc.cl`, login y recuperación).
  - **Cloud Firestore**: Base de datos NoSQL reactiva para sincronización remota de perfiles, agenda, tareas y comunidad, bajo arquitectura Offline-First.
  - Toda interacción con Firebase debe encapsularse detrás de interfaces abstractas de repositorio (`Repository Pattern`), garantizando que la capa de dominio no dependa del SDK de Firebase.

### V. Privacidad por Diseño, Seguridad y Soberanía del Usuario
mindUC maneja reflexiones personales sensibles, estado emocional y datos de autocuidado estudiantil:
- **Diario Personal**: Almacenamiento local protegido con cifrado robusto (AES-256 / SQLCipher o almacenamiento seguro local) con opción de biometría/clave, asegurando que los pensamientos privados no queden expuestos ni sincronizados sin consentimiento explícito.
- **Foro Colaborativo**: Separación criptográfica y lógica estricta entre la identidad real del estudiante (`camila.soto@uc.cl`) y los alias efímeros públicos generados (`@BúhoCurioso`, `@BroteCalmo`). Ninguna consulta pública o documento de Firestore expondrá correos ni identificadores personales del autor.
- **Auditoría y Eliminación**: Se garantiza el derecho de supresión total e inmediata de datos personales y cuenta de Firebase a petición del usuario.

---

## Principios y Módulos Diferidos (Fases Posteriores / Post-MVP)

Los siguientes principios y alcances quedan formalmente **diferidos** por decisión de proyecto y no forman parte del alcance de implementación actual:

### VI. [DIFERIDO] Ética de Inteligencia Artificial y Gamificación Avanzada
- *Alcance Diferido*: Integración activa de modelos de lenguaje (LLM conversacionales en la app) y algoritmos complejos de gamificación.
- *Tratamiento Actual*: El asistente conversacional con IA y los sistemas avanzados de gamificación se posponen hasta la consolidación de la arquitectura base, persistencia en Firebase y módulos centrales de bienestar.

### VII. [DIFERIDO] Bloqueo Nativo de Aplicaciones a Nivel de Sistema Operativo
- *Alcance Diferido*: Mecanismos de restricción forzada o intercepción de aplicaciones de terceros mediante APIs nativas invasivas (Screen Time / Family Controls en iOS o UsageStats/Accessibility en Android).
- *Tratamiento Actual*: En esta fase, el módulo de Concentración (Pomodoro) se centrará exclusivamente en el temporizador configurable, paisajes sonoros relajantes y recordatorios locales conscientes sin bloquear procesos externos del sistema operativo.

---

## Restricciones y Estándares de Código

1. **Lenguaje y Entorno**: Dart 3.x con modo Null Safety estricto (`sound null safety`) y Flutter 3.x estable.
2. **Análisis Estático**: `flutter_lints` configurado de manera estricta; sin advertencias (warnings) toleradas en ramas principales.
3. **Manejo de Errores**: Uso de clases Result (`Either` / `Result<T, Failure>`) en capas de dominio y datos para evitar el lanzamiento descontrolado de excepciones.
4. **Seguridad de Secretos**: Ningún secreto, credencial de servicio ni llave privada se incrustará en el código cliente de Flutter.

## Flujo de Desarrollo y Gobernanza Spec Kit

1. **Gobernanza**: Esta constitución es la norma de máxima jerarquía técnica del proyecto mindUC. Toda decisión de arquitectura o Pull Request debe validar conformidad con estos principios.
2. **Ciclo SDD**:
   - **Specify**: Especificar los requisitos en `specs/` antes de codificar.
   - **Plan**: Diseñar contratos de datos, arquitectura y dependencias antes de generar tareas.
   - **Tasks**: Descomponer en micro-tareas independientes y comprobables.
   - **Implement**: Desarrollar estrictamente el alcance de la tarea asignada con pruebas de verificación.
3. **Enmiendas**: Cualquier modificación a estos principios requiere documentación explícita, justificación de impacto y actualización de versión bajo versionado semántico.

**Version**: 1.1.0 | **Ratified**: 2026-11-02 | **Last Amended**: 2026-11-02
