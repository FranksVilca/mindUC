# Quickstart & Verification Guide: 009-community-forum

## Overview
Guía de ejecución y verificación para el módulo `009-community-forum` de mindUC.

---

## 1. Verificación Automatizada

### Pruebas Unitarias del Controlador y Repositorio
```bash
flutter test test/unit/features/community_forum/community_controller_test.dart
```

### Pruebas de Widgets y Tarjetas Comunitarias
```bash
flutter test test/widget/features/community_forum/community_post_card_test.dart
flutter test test/widget/features/community_forum/community_post_create_modal_test.dart
```

### Pruebas de Integración de Pantalla Completa
```bash
flutter test test/widget/features/community_forum/community_screen_test.dart
```

### Verificación Estática y Suite Global
```bash
dart analyze
flutter test
```

---

## 2. Flujo de Verificación Manual

1. **Navegación al Foro**:
   - Desde la pantalla de Inicio (`HomeScreen`), pulsa la tarjeta de acceso rápido "Comunidad".
   - Verifica la transición a la ruta `/community`.
2. **Inspección Visual del Banner y Filtros**:
   - Verifica el banner de "Comunidad UC Consciente" con las insignias "ESPACIO SEGURO UC" y "• Moderado con empatía".
   - Verifica la nota de privacidad: "Identidad protegida: todos los alias son ficticios y efímeros".
   - Verifica el botón "+ Compartir reflexión anónima".
   - Verifica el contador "X hilos activos" y los filtros por sentir.
3. **Inspección de las Tarjetas de Hilo de Figma**:
   - Hilo 1: `@BúhoCurioso` con chip "• Necesito desahogo", "Exámenes" y el aviso "5 compañeros han tomado una pausa respiratoria tras leer esto".
   - Hilo 2: `@BroteCalmo` con chip "• Hábito saludable", "Mindfulness" y la tarjeta "Guía 4–7–8 recomendada" con botón "Probar".
   - Hilo 3: `@LluviaSuave` con chip "• Vulnerabilidad", "Autoexigencia" y "🌱 Respuesta más apoyada".
4. **Interacción de Reacciones**:
   - Toca `🤍❤️ 42`: el contador debe incrementarse a `43`.
   - Vuelve a tocarlo: el contador debe decrementarse a `42`.
5. **Navegación a Guía Recomendada**:
   - En el hilo de `@BroteCalmo`, pulsa el botón "Probar": debe navegar directamente a la sesión guiada de respiración (`/breathing-session`).
6. **Publicación de una Nueva Reflexión**:
   - Pulsa "+ Compartir reflexión anónima".
   - Verifica el alias ficticio preasignado.
   - Escribe una reflexión, selecciona facultad y categoría de sentir.
   - Pulsa "Publicar en comunidad": el nuevo hilo debe insertarse al inicio de la lista y el contador de hilos activos debe incrementarse.
