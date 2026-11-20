import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/blocked_app.dart';

/// Modal interactivo para seleccionar las aplicaciones que el usuario desea bloquear,
/// agregar nuevas aplicaciones y configurar el tiempo del período de bloqueo.
/// Diseñado con restricciones elásticas y adaptativas para evitar cualquier overflow.
class AppSelectionModal extends StatefulWidget {
  const AppSelectionModal({
    super.key,
    required this.availableApps,
    required this.currentDurationMinutes,
    required this.onToggleApp,
    required this.onAddCustomApp,
    required this.onDurationChanged,
  });

  final List<BlockedApp> availableApps;
  final int currentDurationMinutes;
  final void Function(String appId, bool isBlocked) onToggleApp;
  final void Function(String name) onAddCustomApp;
  final ValueChanged<int> onDurationChanged;

  @override
  State<AppSelectionModal> createState() => _AppSelectionModalState();
}

class _AppSelectionModalState extends State<AppSelectionModal> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _customAppController = TextEditingController();
  late int _selectedDuration;
  late List<BlockedApp> _apps;
  String _searchQuery = '';
  bool _showCustomInput = false;

  @override
  void initState() {
    super.initState();
    _selectedDuration = widget.currentDurationMinutes;
    _apps = List<BlockedApp>.from(widget.availableApps);
  }

  @override
  void didUpdateWidget(covariant AppSelectionModal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.availableApps != widget.availableApps) {
      setState(() {
        _apps = List<BlockedApp>.from(widget.availableApps);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _customAppController.dispose();
    super.dispose();
  }

  void _toggleApp(String appId, bool isBlocked) {
    setState(() {
      _apps = _apps.map((app) {
        if (app.id == appId || app.packageName == appId) {
          return app.copyWith(isBlocked: isBlocked);
        }
        return app;
      }).toList();
    });
    widget.onToggleApp(appId, isBlocked);
  }

  void _addCustomApp() {
    final name = _customAppController.text.trim();
    if (name.isEmpty) return;

    final lower = name.toLowerCase();
    // 1. Si ya existe en la lista (por nombre o paquete), solo activarla
    final existingIndex = _apps.indexWhere((a) =>
        a.name.toLowerCase() == lower ||
        a.packageName.toLowerCase() == lower ||
        (lower.contains('instagram') && a.packageName.contains('instagram')) ||
        (lower.contains('tiktok') &&
            (a.packageName.contains('tiktok') ||
                a.packageName.contains('musically'))) ||
        (lower.contains('whatsapp') && a.packageName.contains('whatsapp')) ||
        (lower.contains('aliexpress') && a.packageName.contains('aliexpress')));

    if (existingIndex != -1) {
      final existing = _apps[existingIndex];
      _toggleApp(existing.id, true);
      _customAppController.clear();
      setState(() {
        _showCustomInput = false;
      });
      return;
    }

    // 2. Si es una app conocida, usar su nombre de paquete oficial
    String canonicalPackage = 'custom_${DateTime.now().millisecondsSinceEpoch}';
    if (lower.contains('instagram')) {
      canonicalPackage = 'com.instagram.android';
    } else if (lower.contains('tiktok') || lower.contains('musically')) {
      canonicalPackage = 'com.zhiliaoapp.musically';
    } else if (lower.contains('whatsapp')) {
      canonicalPackage = 'com.whatsapp';
    } else if (lower.contains('facebook')) {
      canonicalPackage = 'com.facebook.katana';
    } else if (lower.contains('youtube')) {
      canonicalPackage = 'com.google.android.youtube';
    } else if (lower.contains('aliexpress')) {
      canonicalPackage = 'com.alibaba.aliexpresshd';
    } else if (lower.contains('temu')) {
      canonicalPackage = 'com.einnovation.temu';
    } else if (lower.contains('twitter') || lower == 'x') {
      canonicalPackage = 'com.twitter.android';
    } else if (name.contains('.')) {
      canonicalPackage = name;
    }

    final id = canonicalPackage.startsWith('com.') ||
            canonicalPackage.startsWith('org.')
        ? canonicalPackage
        : 'custom_${DateTime.now().millisecondsSinceEpoch}';

    final newApp = BlockedApp(
      id: id,
      name: name,
      packageName: canonicalPackage,
      category: 'Personalizada',
      isBlocked: true,
      dotColorValue: 0xFF2E7D32,
    );

    setState(() {
      _apps = [newApp, ..._apps];
      _showCustomInput = false;
    });
    _customAppController.clear();
    widget.onAddCustomApp(name);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewInsets.bottom;
    final bottomPadding = mediaQuery.padding.bottom;

    final filtered = _apps.where((app) {
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.toLowerCase().trim();
      return app.name.toLowerCase().contains(q) ||
          app.category.toLowerCase().contains(q);
    }).toList();

    final selectedCount = _apps.where((a) => a.isBlocked).length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalAvailable = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : mediaQuery.size.height;
        final sheetMaxHeight =
            (totalAvailable * 0.88).clamp(280.0, totalAvailable);

        final effectiveBottomPadding = bottomInset > 0
            ? bottomInset + 8.0
            : (bottomPadding > 0 ? bottomPadding + 8.0 : 16.0);

        return Material(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: sheetMaxHeight,
              minHeight: 200,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: 12,
                left: 20,
                right: 20,
                bottom: effectiveBottomPadding,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Barra de agarre superior
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Título y botón cerrar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Seleccionar aplicaciones',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: MindColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Elige qué apps silenciar en tus sesiones',
                              style: TextStyle(
                                fontSize: 12,
                                color: MindColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded,
                            color: MindColors.textSecondary),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Contenido desplazable verticalmente sin riesgo de overflow
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        // Selector de duración del período de bloqueo
                        const Text(
                          'Período de bloqueo:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: MindColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: [15, 25, 45, 60].map((mins) {
                              final isChosen = _selectedDuration == mins;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(
                                    mins == 25
                                        ? '25 min (Pomodoro)'
                                        : '$mins min',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: isChosen
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: isChosen
                                          ? Colors.white
                                          : MindColors.textPrimary,
                                    ),
                                  ),
                                  selected: isChosen,
                                  selectedColor: MindColors.primary,
                                  backgroundColor: const Color(0xFFF0F4F1),
                                  showCheckmark: false,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() => _selectedDuration = mins);
                                      widget.onDurationChanged(mins);
                                    }
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Campo de búsqueda
                        TextField(
                          controller: _searchController,
                          onChanged: (val) =>
                              setState(() => _searchQuery = val),
                          decoration: InputDecoration(
                            hintText: 'Buscar aplicación o red social...',
                            hintStyle: const TextStyle(
                                fontSize: 13, color: MindColors.textSecondary),
                            prefixIcon: const Icon(Icons.search_rounded,
                                size: 20, color: MindColors.textSecondary),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded,
                                        size: 18),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                  )
                                : null,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            filled: true,
                            fillColor: const Color(0xFFF6F8F6),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade200),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade200),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide:
                                  const BorderSide(color: MindColors.primary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Botón para desplegar campo de app personalizada
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Disponibles (${filtered.length})',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: MindColors.textPrimary,
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                setState(
                                    () => _showCustomInput = !_showCustomInput);
                              },
                              icon: Icon(
                                _showCustomInput
                                    ? Icons.remove_rounded
                                    : Icons.add_rounded,
                                size: 16,
                                color: MindColors.primary,
                              ),
                              label: Text(
                                _showCustomInput
                                    ? 'Ocultar'
                                    : 'Agregar otra app',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: MindColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),

                        if (_showCustomInput) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _customAppController,
                                  decoration: InputDecoration(
                                    hintText:
                                        'Nombre de la aplicación (ej. Twitter, Reddit)',
                                    hintStyle: const TextStyle(fontSize: 12),
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _addCustomApp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MindColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('Agregar'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],

                        // Lista de aplicaciones con Checkbox reactivo
                        if (filtered.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: Text(
                                'No se encontraron aplicaciones coincidentes.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: MindColors.textSecondary,
                                ),
                              ),
                            ),
                          )
                        else
                          ...filtered.map((app) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CheckboxListTile(
                                key: Key('app_checkbox_${app.id}'),
                                value: app.isBlocked,
                                activeColor: MindColors.primary,
                                contentPadding: EdgeInsets.zero,
                                secondary: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        app.dotColor.withValues(alpha: 0.15),
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: app.dotColor,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  app.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: MindColors.textPrimary,
                                  ),
                                ),
                                subtitle: Text(
                                  app.category,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: MindColors.textSecondary,
                                  ),
                                ),
                                onChanged: (bool? value) {
                                  _toggleApp(app.id, value ?? false);
                                },
                              ),
                              Divider(height: 1, color: Colors.grey.shade100),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Botón inferior para guardar preferencias
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MindColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Guardar preferencias ($selectedCount seleccionadas)',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
