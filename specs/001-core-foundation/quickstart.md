# Quickstart: 001-core-foundation

Esta guía describe cómo verificar y ejecutar los cimientos de mindUC localmente.

## Requisitos Previos
- Flutter SDK 3.44.4+
- Dart SDK 3.12.2+
- Emulador Android (API 34) o Simulador iOS (iOS 17+) configurado.

## 1. Inicialización de dependencias
```bash
flutter pub get
```

## 2. Ejecución del Análisis Estático
```bash
flutter analyze
```
*Debe reportar 0 issues.*

## 3. Ejecución de la Suite de Tests
```bash
flutter test
```
Verifica:
- `test/unit/core/result_test.dart`
- `test/unit/features/auth/auth_repository_test.dart`
- `test/widget/core/design_system/mind_button_test.dart`
- `test/widget/core/design_system/mind_card_test.dart`
- `test/widget/core/design_system/mind_bottom_nav_test.dart`

## 4. Ejecución de la Aplicación en Modo Mock / Desarrollo
```bash
flutter run
```
*La aplicación arranca en el shell con las 4 pestañas funcionales (Inicio, Bienestar, Agenda, Perfil), renderizando la paleta visual serena y componentes de Figma sin requerir credenciales externas obligatorias para la navegación inicial.*
