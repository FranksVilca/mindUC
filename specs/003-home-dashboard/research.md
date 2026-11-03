# Research & Decisions: 003-home-dashboard

**Feature**: 003-home-dashboard (Dashboard Principal del Estudiante)  
**Date**: 2026-11-02  
**Status**: Resolved  

---

## 1. Offline-First Mood Tracking & Daily Check-in

### Context & Challenge
El check-in de ánimo ("¿Cómo te sientes en este momento?") debe registrarse en menos de 2 segundos con un solo toque (SC-001) y estar disponible inmediatamente sin depender de la latencia de red ni fallar en modo avión o con mala conectividad en el campus UC.

### Decision
Implementar un repositorio con patrón Repository (`MoodRepository`) que escribe simultáneamente en el estado reactivo en memoria (Riverpod) y en Cloud Firestore con persistencia offline (`users/{uid}/mood_entries/{yyyy-MM-dd}`).
- Para tests y entornos sin emulador Firebase, se utiliza un `FakeMoodDataSource` desacoplado que replica fielmente el comportamiento de Firestore.
- Para producción, `FirestoreMoodDataSource` escribe con `SetOptions(merge: true)` en el documento del día para garantizar idempotencia y soporte offline nativo de Firestore.

### Alternatives Considered
- *Almacenamiento únicamente en SharedPreferences / FlutterSecureStorage*: Rechazado porque los datos de bienestar deben sincronizarse con la cuenta universitaria del estudiante entre dispositivos (móvil, tablet) y respaldarse en la nube.
- *Llamadas REST tradicionales a backend personalizado*: Rechazado por complejidad innecesaria y menor resiliencia offline comparado con el SDK de Firestore ya ratificado en la Constitución.

---

## 2. Formateo de Fecha Sereno y Localizado en Español

### Context & Challenge
La píldora superior muestra la fecha en español con formato exacto de Figma: `Jueves, 24 de Octubre`. Se requiere formatear correctamente sin depender de configuraciones regionales del sistema operativo del usuario que pudieran mostrar la fecha en inglés u otros idiomas.

### Decision
Crear una utilidad pura y robusta `SpanishDateFormatter` en `core/utils/date_formatter.dart` (o uso de `intl` inicializado en español) que traduzca días y meses de forma determinista y sin fallos por locale ausente:
- Días: Lunes, Martes, Miércoles, Jueves, Viernes, Sábado, Domingo.
- Meses: Enero, Febrero, Marzo, Abril, Mayo, Junio, Julio, Agosto, Septiembre, Octubre, Noviembre, Diciembre.
- Formato: `EEEE, d 'de' MMMM` con mayúscula inicial en el día y mes.

### Alternatives Considered
- *Depender del locale por defecto del dispositivo*: Rechazado porque si el teléfono está en inglés, mostraría `Thursday, October 24`, violando el diseño visual de Figma.

---

## 3. Navegación desde la Cuadrícula 2x2 "Espacios para ti"

### Context & Challenge
Las 4 tarjetas de acceso rápido conducen a:
1. **Relajación**: Módulo de respiración / bienestar.
2. **Agenda**: Tab 2 del shell persistente.
3. **Comunidad**: Foro universitario.
4. **Mi progreso**: Pantalla de progreso y florecimiento.

### Decision
Integrar la navegación utilizando `context.go(route)` de GoRouter:
- `Agenda` navega a `AppRoutes.agenda` conmutando la pestaña del shell persistente.
- `Relajación` navega a `AppRoutes.wellness` (o sub-ruta de respiración guiada).
- Para `Comunidad` y `Mi progreso`, se configuran las rutas `AppRoutes.community` (`/community`) y `AppRoutes.progress` (`/progress`) en `app_router.dart`, proveyendo pantallas provisionales serenas si el módulo aún no tiene su feature completa implementada, evitando rutas rotas o bloqueos.

### Alternatives Considered
- *Inhabilitar los botones de módulos no terminados*: Rechazado porque rompe la experiencia de usuario de Figma y dificulta pruebas de integración visuales. Las pantallas provisionales con el diseño del sistema garantizan navegación consistente.

---

## 4. Diseño Responsivo de la Cuadrícula 2x2

### Context & Challenge
En dispositivos de diferentes relaciones de aspecto (desde pantallas compactas de 360x640 hasta pantallas grandes de 430x932), las 4 tarjetas deben mantener una relación visual armoniosa, radios de 22dp, espaciados generosos y no generar desbordamientos de píxeles (`A RenderFlex overflowed`).

### Decision
Utilizar un diseño basado en `GridView.count` con `shrinkWrap: true`, `physics: const NeverScrollableScrollPhysics()`, `crossAxisCount: 2`, `childAspectRatio: 1.1` (o layout `Row` con `Column` simétrica en `SingleChildScrollView`).
- Tarjetas con padding interno de 16dp.
- Altura adaptable y contenido vertical equilibrado (icono circular de 44x44 en parte superior, flecha derecha sutil, título en `MindTypography.titleMedium` y subtítulo en `MindTypography.bodySmall`).

---

## 5. Resumen de Decisiones Técnicas

| Área | Decisión | Justificación |
| :--- | :--- | :--- |
| **Arquitectura** | Clean Architecture Feature-First (`lib/features/home/`) | Conforme a Constitución v1.1.0 (Principio I). |
| **Estado** | Riverpod (`homeDashboardControllerProvider`) | Conforme a Constitución (Principio IV). |
| **Persistencia** | Firestore Offline + Fake Local para testing | Alta velocidad en tests y robustez sin conexión. |
| **Fidelidad Visual** | Mockup `mindUC - Inicio.png` (Colores pastel de Figma, 22dp radios) | Conforme a Principio III. |
