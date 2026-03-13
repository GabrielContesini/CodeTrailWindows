import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/router/app_router.dart';
import '../../../core/utils/layout_utils.dart';
import '../../../domain/entities/app_entities.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/models/app_enums.dart';
import '../../../shared/models/app_view_models.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../auth/application/auth_controller.dart';
import '../../projects/application/projects_controller.dart';
import '../../tracks/application/tracks_controller.dart';
import '../application/mind_map_codec.dart';
import '../application/mind_map_document.dart';
import '../application/mind_maps_controller.dart';

class MindMapsScreen extends ConsumerStatefulWidget {
  const MindMapsScreen({
    super.key,
    this.initialMindMapId,
    this.immersive = false,
    this.createOnOpen = false,
  });

  final String? initialMindMapId;
  final bool immersive;
  final bool createOnOpen;

  @override
  ConsumerState<MindMapsScreen> createState() => _MindMapsScreenState();
}

class _MindMapsScreenState extends ConsumerState<MindMapsScreen> {
  static const double _boardWidth = 2200;
  static const double _boardHeight = 1400;

  final Uuid _uuid = const Uuid();
  final TransformationController _transformController =
      TransformationController();
  final GlobalKey _canvasViewportKey = GlobalKey();
  final ScrollController _libraryScrollController = ScrollController();

  String _selectedFolder = 'Todas';
  String? _selectedMapId;
  String _searchQuery = '';
  String? _selectedNodeId;
  MindMapDocument? _draftDocument;
  String? _loadedMapId;
  bool _initialRouteSelectionApplied = false;
  bool _initialCreationPromptScheduled = false;
  bool _showLibraryPane = false;
  bool _showInspectorPane = false;
  bool _connectMode = false;
  String? _connectionSourceNodeId;

  @override
  void dispose() {
    _libraryScrollController.dispose();
    _transformController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MindMapsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialMindMapId != widget.initialMindMapId ||
        oldWidget.immersive != widget.immersive ||
        oldWidget.createOnOpen != widget.createOnOpen) {
      _resetRouteDrivenState();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mindMapsAsync = ref.watch(mindMapsProvider);
    final trackBlueprints =
        ref.watch(trackBlueprintsProvider).asData?.value ??
        const <TrackBlueprint>[];
    final projectBundles =
        ref.watch(projectsProvider).asData?.value ?? const <ProjectBundle>[];

    final content = AsyncValueView(
      value: mindMapsAsync,
      loadingMessage: 'Preparando boards e canvas...',
      data: (mindMaps) {
        final trackNameById = {
          for (final item in trackBlueprints) item.track.id: item.track.name,
        };
        final moduleNameById = {
          for (final item in trackBlueprints)
            for (final module in item.modules) module.id: module.title,
        };
        final projectNameById = {
          for (final item in projectBundles)
            item.project.id: item.project.title,
        };

        if (mindMaps.isEmpty) {
          return EmptyState(
            title: 'Nenhum mapa mental criado ainda',
            subtitle:
                'Abra um primeiro board para ligar conceitos, módulos e dependências da sua trilha.',
            action: FilledButton.icon(
              onPressed: () => context.push(AppRoutes.mindMapNew),
              icon: const Icon(Icons.account_tree_outlined),
              label: const Text('Criar primeiro mapa'),
            ),
          );
        }

        final folders = <String>{
          'Geral',
          ...mindMaps.map((item) => item.folderName),
        }..removeWhere((item) => item.trim().isEmpty);
        final folderOptions = ['Todas', ...(folders.toList()..sort())];
        if (!folderOptions.contains(_selectedFolder)) {
          _selectedFolder = 'Todas';
        }

        final normalizedQuery = _searchQuery.trim().toLowerCase();
        final folderFiltered = _selectedFolder == 'Todas'
            ? mindMaps
            : mindMaps
                  .where((item) => item.folderName == _selectedFolder)
                  .toList();
        final filteredMaps = normalizedQuery.isEmpty
            ? folderFiltered
            : folderFiltered.where((item) {
                final haystack =
                    '${item.title} ${item.folderName} ${trackNameById[item.trackId] ?? ''} ${moduleNameById[item.moduleId] ?? ''} ${projectNameById[item.projectId] ?? ''}'
                        .toLowerCase();
                return haystack.contains(normalizedQuery);
              }).toList();

        if (!_initialRouteSelectionApplied) {
          _selectedMapId = widget.createOnOpen
              ? null
              : (widget.initialMindMapId ?? _selectedMapId);
          _initialRouteSelectionApplied = true;
        }

        final sourceMaps = widget.immersive ? mindMaps : filteredMaps;
        final allowFallbackSelection =
            !widget.immersive ||
            (!widget.createOnOpen && widget.initialMindMapId == null);

        if (_selectedMapId == null ||
            sourceMaps.every((item) => item.id != _selectedMapId)) {
          _selectedMapId = allowFallbackSelection && sourceMaps.isNotEmpty
              ? sourceMaps.first.id
              : _selectedMapId;
        }

        MindMapEntity? selectedMap;
        for (final item in sourceMaps) {
          if (item.id == _selectedMapId) {
            selectedMap = item;
            break;
          }
        }

        if (widget.immersive &&
            widget.createOnOpen &&
            !_initialCreationPromptScheduled &&
            selectedMap == null) {
          _initialCreationPromptScheduled = true;
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            final screenContext = context;
            if (!screenContext.mounted) return;
            final created = await _showMindMapDialog(
              screenContext,
              trackBlueprints: trackBlueprints,
              projectBundles: projectBundles,
            );
            if (!screenContext.mounted) return;
            if (created == null) {
              _leaveEditor();
              return;
            }
            screenContext.go('${AppRoutes.mindMapEditor}/${created.id}');
          });
        }

        if (_loadedMapId != selectedMap?.id) {
          _loadedMapId = selectedMap?.id;
          _draftDocument = selectedMap == null
              ? null
              : MindMapCodec.decode(
                  selectedMap.contentJson,
                  fallbackLabel: selectedMap.title,
                );
          _selectedNodeId = _draftDocument?.nodes.isNotEmpty == true
              ? _draftDocument!.nodes.first.id
              : null;
          _showInspectorPane = false;
          _connectMode = false;
          _connectionSourceNodeId = null;
          _transformController.value = Matrix4.identity();
          final documentToFit = _draftDocument;
          if (documentToFit != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              _fitContentToViewport(documentToFit);
            });
          }
        }

        final selectedDocument = selectedMap == null ? null : _draftDocument;
        final selectedNode = selectedDocument == null
            ? null
            : (_findNode(selectedDocument, _selectedNodeId) ??
                  (selectedDocument.nodes.isEmpty
                      ? null
                      : selectedDocument.nodes.first));

        return LayoutBuilder(
          builder: (context, constraints) {
            if (!widget.immersive) {
              return _buildLibraryHome(
                context,
                constraints: constraints,
                maps: filteredMaps,
                folderOptions: folderOptions,
                trackNameById: trackNameById,
                moduleNameById: moduleNameById,
                projectNameById: projectNameById,
                selectedMap: selectedMap,
              );
            }

            if (selectedMap == null || selectedDocument == null) {
              return AppCard(
                child: EmptyState(
                  title: widget.createOnOpen
                      ? 'Preparando novo canvas'
                      : 'Mapa não encontrado',
                  subtitle: widget.createOnOpen
                      ? 'Abrindo o editor dedicado para configurar seu novo mind map.'
                      : 'Esse mapa não está mais disponível. Volte para a biblioteca e abra outro canvas.',
                  action: OutlinedButton.icon(
                    onPressed: _leaveEditor,
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('Voltar para biblioteca'),
                  ),
                ),
              );
            }

            return _buildWorkspace(
              context,
              selectedMap,
              selectedDocument,
              selectedNode,
              trackNameById,
              moduleNameById,
              projectNameById,
              trackBlueprints,
              projectBundles,
              showLibraryToggle: false,
            );
          },
        );
      },
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          widget.immersive
              ? _buildImmersiveHeader(context)
              : _buildLibraryHeader(context),
          const SizedBox(height: 14),
          Expanded(child: content),
        ],
      ),
    );
  }

  Widget _buildLibraryHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mapas mentais',
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Abra um mapa no editor dedicado ou crie um board novo com foco total no canvas.',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.72),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        FilledButton.icon(
          onPressed: () => context.push(AppRoutes.mindMapNew),
          icon: const Icon(Icons.account_tree_outlined),
          label: const Text('Novo mapa'),
        ),
      ],
    );
  }

  void _resetRouteDrivenState() {
    _selectedMapId = widget.createOnOpen ? null : widget.initialMindMapId;
    _selectedNodeId = null;
    _draftDocument = null;
    _loadedMapId = null;
    _initialRouteSelectionApplied = false;
    _initialCreationPromptScheduled = false;
    _showInspectorPane = false;
    _connectMode = false;
    _connectionSourceNodeId = null;
    _transformController.value = Matrix4.identity();
  }

  Widget _buildImmersiveHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Canvas Mind Map',
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Editor dedicado com foco total no canvas e nos vínculos do mapa.',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.72),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            OutlinedButton.icon(
              onPressed: _leaveEditor,
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Voltar'),
            ),
            FilledButton.icon(
              onPressed: () => context.push(AppRoutes.mindMapNew),
              icon: const Icon(Icons.add_box_outlined),
              label: const Text('Novo mapa'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLibrary(
    BuildContext context,
    List<MindMapEntity> maps,
    List<String> folderOptions,
    Map<String, String> trackNameById,
    Map<String, String> moduleNameById,
    Map<String, String> projectNameById,
  ) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mapas',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${maps.length} mapa(s) no resultado atual.',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.68),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedFolder,
                  decoration: const InputDecoration(labelText: 'Pasta'),
                  items: folderOptions
                      .map(
                        (item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _selectedFolder = value;
                      _selectedMapId = null;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            onChanged: (value) => setState(() {
              _searchQuery = value;
              _selectedMapId = null;
            }),
            decoration: InputDecoration(
              labelText: 'Buscar mapa',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _searchQuery.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () => setState(() => _searchQuery = ''),
                      icon: const Icon(Icons.close_rounded),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: maps.isEmpty
                ? Center(
                    child: Text(
                      'Nenhum mapa encontrado nesse filtro.',
                      style: context.textTheme.bodyMedium,
                    ),
                  )
                : Scrollbar(
                    controller: _libraryScrollController,
                    thumbVisibility: true,
                    child: ListView.separated(
                      controller: _libraryScrollController,
                      primary: false,
                      padding: const EdgeInsets.only(right: 8),
                      itemCount: maps.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final map = maps[index];
                        final document = MindMapCodec.decode(
                          map.id == _selectedMapId && _draftDocument != null
                              ? MindMapCodec.encode(_draftDocument!)
                              : map.contentJson,
                          fallbackLabel: map.title,
                        );
                        return _MapListTile(
                          map: map,
                          document: document,
                          selected: map.id == _selectedMapId,
                          contextLabels: _mindMapContextLabels(
                            map,
                            trackNameById: trackNameById,
                            moduleNameById: moduleNameById,
                            projectNameById: projectNameById,
                          ),
                          onTap: () => setState(() {
                            _selectedMapId = map.id;
                            _loadedMapId = null;
                          }),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLibraryHome(
    BuildContext context, {
    required BoxConstraints constraints,
    required List<MindMapEntity> maps,
    required List<String> folderOptions,
    required Map<String, String> trackNameById,
    required Map<String, String> moduleNameById,
    required Map<String, String> projectNameById,
    required MindMapEntity? selectedMap,
  }) {
    final library = _buildLibrary(
      context,
      maps,
      folderOptions,
      trackNameById,
      moduleNameById,
      projectNameById,
    );
    final compact = constraints.maxWidth < 1420;

    final preview = selectedMap == null
        ? AppCard(
            child: EmptyState(
              title: 'Nenhum mapa nesse filtro',
              subtitle:
                  'Ajuste a busca, troque a pasta ou crie um novo board para abrir no canvas.',
              action: FilledButton.icon(
                onPressed: () => context.push(AppRoutes.mindMapNew),
                icon: const Icon(Icons.account_tree_outlined),
                label: const Text('Novo mapa'),
              ),
            ),
          )
        : _buildLibraryPreview(
            context,
            selectedMap,
            compact: compact,
            trackNameById: trackNameById,
            moduleNameById: moduleNameById,
            projectNameById: projectNameById,
          );

    if (!compact) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(width: 332, child: library),
          const SizedBox(width: 18),
          Expanded(child: preview),
        ],
      );
    }

    return Column(
      children: [
        SizedBox(height: 360, child: library),
        const SizedBox(height: 16),
        Expanded(child: preview),
      ],
    );
  }

  Widget _buildLibraryPreview(
    BuildContext context,
    MindMapEntity map, {
    required bool compact,
    required Map<String, String> trackNameById,
    required Map<String, String> moduleNameById,
    required Map<String, String> projectNameById,
  }) {
    final document = MindMapCodec.decode(
      map.contentJson,
      fallbackLabel: map.title,
    );
    final contextLabels = _mindMapContextLabels(
      map,
      trackNameById: trackNameById,
      moduleNameById: moduleNameById,
      projectNameById: projectNameById,
    );
    final summaryCard = AppCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stackActions = compact || constraints.maxWidth < 720;
          final actions = Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.icon(
                onPressed: () =>
                    context.push('${AppRoutes.mindMapEditor}/${map.id}'),
                icon: const Icon(Icons.open_in_full_rounded),
                label: const Text('Abrir canvas'),
              ),
              OutlinedButton.icon(
                onPressed: () => context.push(AppRoutes.mindMapNew),
                icon: const Icon(Icons.add_box_outlined),
                label: const Text('Novo mapa'),
              ),
            ],
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selecionado',
                style: context.textTheme.labelLarge?.copyWith(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              if (stackActions) ...[
                Text(
                  map.title,
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Abra este mapa em um canvas dedicado para editar com mais espaço e foco.',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurface.withValues(
                      alpha: 0.72,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                actions,
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            map.title,
                            style: context.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Abra este mapa em um canvas dedicado para editar com mais espaço e foco.',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.colorScheme.onSurface.withValues(
                                alpha: 0.72,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 18),
                    actions,
                  ],
                ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _CanvasMetricChip(
                    icon: Icons.radio_button_checked_rounded,
                    label: '${document.nodes.length} nós',
                  ),
                  _CanvasMetricChip(
                    icon: Icons.timeline_rounded,
                    label: '${document.connections.length} conexões',
                  ),
                  _CanvasMetricChip(
                    icon: Icons.folder_open_rounded,
                    label: map.folderName,
                  ),
                  ...contextLabels.map((item) => _ContextPill(label: item)),
                ],
              ),
            ],
          );
        },
      ),
    );

    final previewCard = AppCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                context.colorScheme.surface.withValues(alpha: 0.96),
                context.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.52,
                ),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(child: _MiniMindMapPreview(document: document)),
              Positioned(
                right: 18,
                bottom: 18,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.colorScheme.surface.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: context.colorScheme.outline.withValues(alpha: 0.7),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Text(
                      'Prévia do mapa',
                      style: context.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          summaryCard,
          const SizedBox(height: 16),
          SizedBox(height: 280, child: previewCard),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        summaryCard,
        const SizedBox(height: 16),
        Expanded(child: previewCard),
      ],
    );
  }

  Widget _buildWorkspace(
    BuildContext context,
    MindMapEntity map,
    MindMapDocument document,
    MindMapCanvasNode? selectedNode,
    Map<String, String> trackNameById,
    Map<String, String> moduleNameById,
    Map<String, String> projectNameById,
    List<TrackBlueprint> trackBlueprints,
    List<ProjectBundle> projectBundles, {
    required bool showLibraryToggle,
  }) {
    final contextLabels = _mindMapContextLabels(
      map,
      trackNameById: trackNameById,
      moduleNameById: moduleNameById,
      projectNameById: projectNameById,
    );
    final selectedConnections = selectedNode == null
        ? const <MindMapCanvasConnection>[]
        : document.connections
              .where(
                (item) =>
                    item.sourceId == selectedNode.id ||
                    item.targetId == selectedNode.id,
              )
              .toList();
    return LayoutBuilder(
      builder: (context, constraints) {
        final compactWorkspace =
            constraints.maxWidth < 1320 || constraints.maxHeight < 900;
        final canvas = compactWorkspace
            ? _buildCanvas(context, map, document)
            : _buildCanvasStage(
                context,
                map,
                document,
                selectedNode,
                contextLabels,
                trackBlueprints,
                projectBundles,
                showLibraryToggle: showLibraryToggle,
              );
        final inspector = _buildInspector(
          context,
          map,
          document,
          selectedNode,
          selectedConnections,
          compact: compactWorkspace,
        );

        if (compactWorkspace) {
          final canvasHeight = math.max(
            540.0,
            math.min(820.0, constraints.maxHeight * 0.72),
          );

          return Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(right: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildWorkspaceHeader(
                    context,
                    map,
                    document,
                    selectedNode,
                    contextLabels,
                    trackBlueprints,
                    projectBundles,
                    showLibraryToggle: showLibraryToggle,
                    compact: true,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(height: canvasHeight, child: canvas),
                  const SizedBox(height: 16),
                  inspector,
                ],
              ),
            ),
          );
        }

        final inspectorWidth = constraints.maxWidth >= 1560 ? 360.0 : 320.0;
        final inspectorVisible = _showInspectorPane;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: canvas),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: inspectorVisible ? 16 : 0,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: inspectorVisible ? inspectorWidth : 0,
              child: inspectorVisible ? inspector : const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWorkspaceHeader(
    BuildContext context,
    MindMapEntity map,
    MindMapDocument document,
    MindMapCanvasNode? selectedNode,
    List<String> contextLabels,
    List<TrackBlueprint> trackBlueprints,
    List<ProjectBundle> projectBundles, {
    required bool showLibraryToggle,
    required bool compact,
  }) {
    final actions = Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        if (showLibraryToggle)
          _ActionChipButton(
            onTap: () => setState(() => _showLibraryPane = !_showLibraryPane),
            icon: _showLibraryPane
                ? Icons.menu_open_rounded
                : Icons.library_books_outlined,
            label: _showLibraryPane ? 'Fechar biblioteca' : 'Biblioteca',
          ),
        _ActionChipButton(
          onTap: () => setState(() => _showInspectorPane = !_showInspectorPane),
          icon: _showInspectorPane
              ? Icons.chevron_right_rounded
              : Icons.tune_rounded,
          label: _showInspectorPane ? 'Fechar inspetor' : 'Inspetor',
        ),
        PopupMenuButton<MindMapNodeShape>(
          onSelected: (shape) => _createNode(map, document, shape),
          itemBuilder: (context) => MindMapNodeShape.values
              .map(
                (shape) => PopupMenuItem<MindMapNodeShape>(
                  value: shape,
                  child: Text('Adicionar ${shape.label.toLowerCase()}'),
                ),
              )
              .toList(),
          child: const _ActionChip(
            icon: Icons.add_box_outlined,
            label: 'Novo nó',
            primary: true,
          ),
        ),
        _ActionChipButton(
          onTap: selectedNode == null
              ? null
              : () => _editNode(map, document, selectedNode),
          icon: Icons.edit_outlined,
          label: 'Editar nó',
        ),
        _ActionChipButton(
          onTap: selectedNode == null
              ? null
              : () => setState(() {
                  _connectMode = !_connectMode;
                  _connectionSourceNodeId = _connectMode
                      ? _selectedNodeId
                      : null;
                }),
          icon: _connectMode ? Icons.link_off_rounded : Icons.add_link_rounded,
          label: _connectMode ? 'Cancelar' : 'Conectar',
        ),
        _ActionChipButton(
          onTap: () => _fitContentToViewport(document),
          icon: Icons.fit_screen_rounded,
          label: 'Ajustar',
        ),
        _ActionChipButton(
          onTap: _resetZoom,
          icon: Icons.center_focus_strong_rounded,
          label: 'Resetar',
        ),
        _ActionChipButton(
          onTap: () => _showMindMapDialog(
            context,
            trackBlueprints: trackBlueprints,
            projectBundles: projectBundles,
            mindMap: map,
          ),
          icon: Icons.tune_rounded,
          label: 'Editar mapa',
        ),
        IconButton(
          tooltip: 'Excluir mapa',
          onPressed: () => _deleteMap(map),
          icon: const Icon(Icons.delete_outline_rounded),
        ),
      ],
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (compact) ...[
            Text(
              map.title,
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${map.folderName} • ${_formatDateTime(map.updatedAt)}',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.72),
              ),
            ),
            const SizedBox(height: 16),
            actions,
          ] else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        map.title,
                        style: context.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${map.folderName} • ${_formatDateTime(map.updatedAt)}',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurface.withValues(
                            alpha: 0.72,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: Align(alignment: Alignment.topRight, child: actions),
                ),
              ],
            ),
          if (contextLabels.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: contextLabels
                  .map((item) => _ContextPill(label: item))
                  .toList(),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            _connectMode
                ? _connectionSourceNodeId == null
                      ? 'Modo conexão ativo. Clique no nó de origem.'
                      : 'Origem definida. Agora clique no nó de destino.'
                : 'Ajuste o conteúdo para enquadrar todos os nós e use o canvas para mover, conectar e revisar a estrutura.',
            style: context.textTheme.bodyMedium?.copyWith(
              color: _connectMode
                  ? context.colorScheme.primary
                  : context.colorScheme.onSurface.withValues(alpha: 0.78),
              fontWeight: _connectMode ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCanvasStage(
    BuildContext context,
    MindMapEntity map,
    MindMapDocument document,
    MindMapCanvasNode? selectedNode,
    List<String> contextLabels,
    List<TrackBlueprint> trackBlueprints,
    List<ProjectBundle> projectBundles, {
    required bool showLibraryToggle,
  }) {
    final toolbar = Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.end,
      children: [
        if (showLibraryToggle)
          _OverlayToolButton(
            icon: _showLibraryPane
                ? Icons.menu_open_rounded
                : Icons.library_books_outlined,
            label: _showLibraryPane ? 'Fechar biblioteca' : 'Biblioteca',
            onTap: () => setState(() => _showLibraryPane = !_showLibraryPane),
          ),
        _OverlayToolButton(
          icon: _showInspectorPane
              ? Icons.chevron_right_rounded
              : Icons.tune_rounded,
          label: _showInspectorPane ? 'Fechar inspetor' : 'Inspetor',
          onTap: () => setState(() => _showInspectorPane = !_showInspectorPane),
        ),
        PopupMenuButton<MindMapNodeShape>(
          onSelected: (shape) => _createNode(map, document, shape),
          itemBuilder: (context) => MindMapNodeShape.values
              .map(
                (shape) => PopupMenuItem<MindMapNodeShape>(
                  value: shape,
                  child: Text('Adicionar ${shape.label.toLowerCase()}'),
                ),
              )
              .toList(),
          child: const _OverlayToolButton(
            icon: Icons.add_box_outlined,
            label: 'Novo nó',
            primary: true,
          ),
        ),
        _OverlayToolButton(
          icon: _connectMode ? Icons.link_off_rounded : Icons.add_link_rounded,
          label: _connectMode ? 'Cancelar conexão' : 'Conectar',
          onTap: selectedNode == null
              ? null
              : () => setState(() {
                  _connectMode = !_connectMode;
                  _connectionSourceNodeId = _connectMode
                      ? _selectedNodeId
                      : null;
                }),
        ),
        _OverlayToolButton(
          icon: Icons.fit_screen_rounded,
          label: 'Ajustar',
          onTap: () => _fitContentToViewport(document),
        ),
        _OverlayToolButton(
          icon: Icons.center_focus_strong_rounded,
          label: 'Resetar',
          onTap: _resetZoom,
        ),
      ],
    );

    final mapSummary = _FloatingPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            map.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${map.folderName} • ${_formatDateTime(map.updatedAt)}',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _CanvasMetricChip(
                icon: Icons.radio_button_checked_rounded,
                label: '${document.nodes.length} nós',
              ),
              _CanvasMetricChip(
                icon: Icons.timeline_rounded,
                label: '${document.connections.length} conexões',
              ),
              ...contextLabels.take(2).map((item) => _ContextPill(label: item)),
            ],
          ),
          if (selectedNode != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: context.colorScheme.primary.withValues(alpha: 0.18),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.ads_click_rounded,
                    size: 16,
                    color: context.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Selecionado: ${selectedNode.label}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: context.colorScheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );

    final quickActions = _FloatingPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          toolbar,
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              if (selectedNode != null)
                _OverlayToolButton(
                  icon: Icons.edit_outlined,
                  label: 'Editar nó',
                  onTap: () => _editNode(map, document, selectedNode),
                ),
              _OverlayToolButton(
                icon: Icons.tune_rounded,
                label: 'Editar mapa',
                onTap: () => _showMindMapDialog(
                  context,
                  trackBlueprints: trackBlueprints,
                  projectBundles: projectBundles,
                  mindMap: map,
                ),
              ),
              _OverlayToolButton(
                icon: Icons.delete_outline_rounded,
                label: 'Excluir mapa',
                onTap: () => _deleteMap(map),
                danger: true,
              ),
            ],
          ),
        ],
      ),
    );

    return Stack(
      children: [
        Positioned.fill(child: _buildCanvas(context, map, document)),
        Positioned(
          top: 18,
          left: 18,
          right: 18,
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 1220) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    mapSummary,
                    const SizedBox(height: 12),
                    quickActions,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: mapSummary,
                  ),
                  const Spacer(),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 620),
                    child: quickActions,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCanvas(
    BuildContext context,
    MindMapEntity map,
    MindMapDocument document,
  ) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            DecoratedBox(
              key: _canvasViewportKey,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.colorScheme.surface.withValues(alpha: 0.94),
                    context.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.56,
                    ),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: InteractiveViewer(
                transformationController: _transformController,
                constrained: false,
                minScale: 0.45,
                maxScale: 2.4,
                boundaryMargin: const EdgeInsets.all(240),
                child: SizedBox(
                  width: _boardWidth,
                  height: _boardHeight,
                  child: Stack(
                    children: [
                      const Positioned.fill(
                        child: CustomPaint(painter: _MindMapGridPainter()),
                      ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _MindMapConnectionsPainter(
                            nodes: document.nodes,
                            connections: document.connections,
                            selectedNodeId: _selectedNodeId,
                            connectionSourceNodeId: _connectionSourceNodeId,
                          ),
                        ),
                      ),
                      for (final node in document.nodes)
                        Positioned(
                          left: node.x,
                          top: node.y,
                          child: _NodeWidget(
                            node: node,
                            selected: node.id == _selectedNodeId,
                            onTap: () => _handleNodeTap(map, document, node),
                            onDrag: (delta) =>
                                _handleNodeDrag(document, node.id, delta),
                            onDragEnd: () => _persistDocument(
                              map,
                              _draftDocument ?? document,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 18,
              bottom: 18,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colorScheme.surface.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: context.colorScheme.outline.withValues(alpha: 0.7),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    'Arraste no fundo para navegar. Use Ajustar para focar todos os nós.',
                    style: context.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInspector(
    BuildContext context,
    MindMapEntity map,
    MindMapDocument document,
    MindMapCanvasNode? selectedNode,
    List<MindMapCanvasConnection> selectedConnections, {
    required bool compact,
  }) {
    if (selectedNode == null) {
      return AppCard(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: compact ? 160 : 0),
          child: Center(
            child: Text(
              'Selecione um nó para editar ou revisar as conexões.',
              style: context.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final connectionWrap = selectedConnections.isEmpty
        ? Center(
            child: Text(
              'Esse nó ainda não está conectado.',
              style: context.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          )
        : Wrap(
            spacing: 10,
            runSpacing: 10,
            children: selectedConnections.map((connection) {
              final otherNode = _otherNode(
                document,
                connection,
                selectedNode.id,
              );
              return InputChip(
                label: Text(otherNode?.label ?? 'Conexão'),
                onDeleted: () =>
                    _deleteConnection(map, document, connection.id),
              );
            }).toList(),
          );

    final header = LayoutBuilder(
      builder: (context, constraints) {
        final stackActions = compact || constraints.maxWidth < 340;
        final actions = Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilledButton.tonalIcon(
              onPressed: () => _editNode(map, document, selectedNode),
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Editar'),
            ),
            FilledButton.tonalIcon(
              onPressed: () => _deleteNode(map, document, selectedNode),
              icon: const Icon(Icons.delete_outline_rounded, size: 18),
              label: const Text('Excluir'),
            ),
          ],
        );

        if (stackActions) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedNode.label,
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${selectedNode.shape.label} • ${selectedNode.x.round()} x ${selectedNode.y.round()}',
                style: context.textTheme.bodySmall,
              ),
              const SizedBox(height: 14),
              actions,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedNode.label,
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${selectedNode.shape.label} • ${selectedNode.x.round()} x ${selectedNode.y.round()}',
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            actions,
          ],
        );
      },
    );

    return AppCard(
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                header,
                const SizedBox(height: 14),
                Text(
                  'Conexões',
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                connectionWrap,
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header,
                const SizedBox(height: 14),
                Text(
                  'Conexões',
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: selectedConnections.isEmpty
                      ? connectionWrap
                      : Scrollbar(
                          thumbVisibility: true,
                          child: SingleChildScrollView(child: connectionWrap),
                        ),
                ),
              ],
            ),
    );
  }

  void _resetZoom() {
    _transformController.value = Matrix4.identity();
  }

  void _leaveEditor() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutes.mindMaps);
  }

  void _fitContentToViewport(MindMapDocument document) {
    if (document.nodes.isEmpty) {
      _resetZoom();
      return;
    }

    final viewportContext = _canvasViewportKey.currentContext;
    final renderBox = viewportContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) {
      _resetZoom();
      return;
    }

    final viewport = renderBox.size;
    final left = document.nodes
        .map((item) => item.x)
        .reduce((value, element) => math.min(value, element));
    final top = document.nodes
        .map((item) => item.y)
        .reduce((value, element) => math.min(value, element));
    final right = document.nodes
        .map((item) => item.x + item.width)
        .reduce((value, element) => math.max(value, element));
    final bottom = document.nodes
        .map((item) => item.y + item.height)
        .reduce((value, element) => math.max(value, element));

    const padding = 120.0;
    final targetRect = Rect.fromLTRB(
      math.max(0.0, left - padding),
      math.max(0.0, top - padding),
      math.min(_boardWidth, right + padding),
      math.min(_boardHeight, bottom + padding),
    );

    final scaleX = viewport.width / math.max(targetRect.width, 1.0);
    final scaleY = viewport.height / math.max(targetRect.height, 1.0);
    final scale = math.min(math.min(scaleX, scaleY), 1.0).clamp(0.45, 2.4);

    final translatedX =
        (viewport.width - targetRect.width * scale) / 2 -
        targetRect.left * scale;
    final translatedY =
        (viewport.height - targetRect.height * scale) / 2 -
        targetRect.top * scale;

    _transformController.value = Matrix4.identity()
      ..translateByDouble(translatedX, translatedY, 0, 1)
      ..scaleByDouble(scale, scale, scale, 1);
  }

  Future<void> _createNode(
    MindMapEntity map,
    MindMapDocument document,
    MindMapNodeShape shape,
  ) async {
    final baseNode = _findNode(document, _selectedNodeId);
    final size = _sizeForShape(shape);
    final position = _nextNodePosition(
      document,
      width: size.width,
      height: size.height,
      baseNode: baseNode,
    );
    final node = await _showNodeDialog(
      context,
      initialNode: MindMapCanvasNode(
        id: _uuid.v4(),
        label: 'Novo conceito',
        shape: shape,
        colorHex: _defaultColorForShape(shape),
        x: position.dx,
        y: position.dy,
        width: size.width,
        height: size.height,
      ),
    );
    if (node == null) return;

    final updated = document.copyWith(nodes: [...document.nodes, node]);
    setState(() {
      _draftDocument = updated;
      _selectedNodeId = node.id;
      _showInspectorPane = true;
    });
    await _persistDocument(map, updated);
  }

  Future<void> _editNode(
    MindMapEntity map,
    MindMapDocument document,
    MindMapCanvasNode node,
  ) async {
    final updatedNode = await _showNodeDialog(context, initialNode: node);
    if (updatedNode == null) return;

    final updated = document.copyWith(
      nodes: [
        for (final item in document.nodes)
          if (item.id == node.id) updatedNode else item,
      ],
    );
    setState(() {
      _draftDocument = updated;
      _showInspectorPane = true;
    });
    await _persistDocument(map, updated);
  }

  Future<void> _deleteNode(
    MindMapEntity map,
    MindMapDocument document,
    MindMapCanvasNode node,
  ) async {
    if (document.nodes.length == 1) {
      context.showAppSnackBar('Mantenha pelo menos um nó no mapa.');
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Remover nó'),
          content: Text('Excluir "${node.label}" e as conexões ligadas a ele?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
    if (shouldDelete != true) return;

    final updated = document.copyWith(
      nodes: document.nodes.where((item) => item.id != node.id).toList(),
      connections: document.connections
          .where((item) => item.sourceId != node.id && item.targetId != node.id)
          .toList(),
    );
    setState(() {
      _draftDocument = updated;
      _selectedNodeId = updated.nodes.first.id;
      if (_connectionSourceNodeId == node.id) {
        _connectMode = false;
        _connectionSourceNodeId = null;
      }
    });
    await _persistDocument(map, updated, successMessage: 'Nó removido.');
  }

  Future<void> _deleteConnection(
    MindMapEntity map,
    MindMapDocument document,
    String connectionId,
  ) async {
    final updated = document.copyWith(
      connections: document.connections
          .where((item) => item.id != connectionId)
          .toList(),
    );
    setState(() => _draftDocument = updated);
    await _persistDocument(map, updated, successMessage: 'Conexão removida.');
  }

  Future<void> _handleNodeTap(
    MindMapEntity map,
    MindMapDocument document,
    MindMapCanvasNode node,
  ) async {
    setState(() {
      _selectedNodeId = node.id;
      _showInspectorPane = true;
    });

    if (!_connectMode) return;

    if (_connectionSourceNodeId == null) {
      setState(() => _connectionSourceNodeId = node.id);
      context.showAppSnackBar(
        'Origem definida. Agora clique no nó de destino.',
      );
      return;
    }

    if (_connectionSourceNodeId == node.id) {
      setState(() => _connectionSourceNodeId = null);
      return;
    }

    final duplicate = document.connections.any(
      (item) => _isSameConnection(
        item,
        sourceId: _connectionSourceNodeId!,
        targetId: node.id,
      ),
    );
    if (duplicate) {
      context.showAppSnackBar('Essa conexão já existe no board.');
      return;
    }

    final updated = document.copyWith(
      connections: [
        ...document.connections,
        MindMapCanvasConnection(
          id: _uuid.v4(),
          sourceId: _connectionSourceNodeId!,
          targetId: node.id,
        ),
      ],
    );

    setState(() {
      _draftDocument = updated;
      _selectedNodeId = node.id;
      _connectMode = false;
      _connectionSourceNodeId = null;
    });
    await _persistDocument(map, updated, successMessage: 'Conexão criada.');
  }

  void _handleNodeDrag(MindMapDocument document, String nodeId, Offset delta) {
    final scale = _transformController.value.getMaxScaleOnAxis().clamp(
      0.4,
      3.0,
    );
    final adjusted = Offset(delta.dx / scale, delta.dy / scale);

    final updated = document.copyWith(
      nodes: [
        for (final item in document.nodes)
          if (item.id == nodeId)
            item.copyWith(
              x: (item.x + adjusted.dx).clamp(0, _boardWidth - item.width),
              y: (item.y + adjusted.dy).clamp(0, _boardHeight - item.height),
            )
          else
            item,
      ],
    );

    setState(() {
      _draftDocument = updated;
      _selectedNodeId = nodeId;
    });
  }

  Future<void> _persistDocument(
    MindMapEntity map,
    MindMapDocument document, {
    String? successMessage,
  }) async {
    final updatedMap = map.copyWith(
      contentJson: MindMapCodec.encode(document),
      updatedAt: DateTime.now().toUtc(),
    );
    await ref.read(mindMapActionsProvider).save(updatedMap);
    if (!mounted || successMessage == null) return;
    context.showAppSnackBar(successMessage);
  }

  Future<void> _deleteMap(MindMapEntity map) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Remover mapa'),
          content: Text('Excluir o mapa "${map.title}" do workspace?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
    if (shouldDelete != true) return;

    await ref.read(mindMapActionsProvider).delete(map.id);
    if (!mounted) return;

    if (widget.immersive) {
      context.showAppSnackBar('Mapa removido.');
      _leaveEditor();
      return;
    }

    setState(() {
      _selectedMapId = null;
      _selectedNodeId = null;
      _draftDocument = null;
      _loadedMapId = null;
      _connectMode = false;
      _connectionSourceNodeId = null;
    });
    context.showAppSnackBar('Mapa removido.');
  }

  Future<MindMapEntity?> _showMindMapDialog(
    BuildContext context, {
    required List<TrackBlueprint> trackBlueprints,
    required List<ProjectBundle> projectBundles,
    MindMapEntity? mindMap,
  }) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return null;

    final folderController = TextEditingController(
      text: mindMap?.folderName ?? 'Geral',
    );
    final titleController = TextEditingController(text: mindMap?.title ?? '');
    String? selectedTrackId = mindMap?.trackId;
    String? selectedModuleId = mindMap?.moduleId;
    String? selectedProjectId = mindMap?.projectId;
    MindMapEntity? result;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final dialogWidth = responsiveDialogWidth(
          dialogContext,
          ideal: 620,
          min: 340,
        );
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            final selectedTrack = _findTrackBlueprint(
              trackBlueprints,
              selectedTrackId,
            );
            final availableModules =
                selectedTrack?.modules ?? const <StudyModuleEntity>[];

            return AlertDialog(
              title: Text(mindMap == null ? 'Novo mapa mental' : 'Editar mapa'),
              content: SizedBox(
                width: dialogWidth,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: folderController,
                        decoration: const InputDecoration(
                          labelText: 'Caderno / pasta',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Título do mapa',
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String?>(
                        initialValue:
                            trackBlueprints.any(
                              (item) => item.track.id == selectedTrackId,
                            )
                            ? selectedTrackId
                            : null,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Relacionar trilha',
                        ),
                        items: [
                          const DropdownMenuItem<String?>(
                            value: null,
                            child: Text('Sem trilha'),
                          ),
                          ...trackBlueprints.map(
                            (item) => DropdownMenuItem<String?>(
                              value: item.track.id,
                              child: Text(item.track.name),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setDialogState(() {
                            selectedTrackId = value;
                            if (!availableModules.any(
                              (item) => item.id == selectedModuleId,
                            )) {
                              selectedModuleId = null;
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String?>(
                        initialValue:
                            availableModules.any(
                              (item) => item.id == selectedModuleId,
                            )
                            ? selectedModuleId
                            : null,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Relacionar módulo',
                        ),
                        items: [
                          const DropdownMenuItem<String?>(
                            value: null,
                            child: Text('Sem módulo'),
                          ),
                          ...availableModules.map(
                            (item) => DropdownMenuItem<String?>(
                              value: item.id,
                              child: Text(item.title),
                            ),
                          ),
                        ],
                        onChanged: (value) =>
                            setDialogState(() => selectedModuleId = value),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String?>(
                        initialValue:
                            projectBundles.any(
                              (item) => item.project.id == selectedProjectId,
                            )
                            ? selectedProjectId
                            : null,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Relacionar projeto',
                        ),
                        items: [
                          const DropdownMenuItem<String?>(
                            value: null,
                            child: Text('Sem projeto'),
                          ),
                          ...projectBundles.map(
                            (item) => DropdownMenuItem<String?>(
                              value: item.project.id,
                              child: Text(item.project.title),
                            ),
                          ),
                        ],
                        onChanged: (value) =>
                            setDialogState(() => selectedProjectId = value),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () async {
                    final title = titleController.text.trim();
                    final folder = folderController.text.trim().isEmpty
                        ? 'Geral'
                        : folderController.text.trim();
                    if (title.isEmpty) {
                      dialogContext.showAppSnackBar(
                        'Defina um título para o mapa.',
                      );
                      return;
                    }

                    final now = DateTime.now().toUtc();
                    final selectedTrack = _findTrackBlueprint(
                      trackBlueprints,
                      selectedTrackId,
                    );
                    final selectedModule = _findModule(
                      selectedTrack?.modules ?? const <StudyModuleEntity>[],
                      selectedModuleId,
                    );
                    final selectedProject = _findProjectBundle(
                      projectBundles,
                      selectedProjectId,
                    );

                    final updated = MindMapEntity(
                      id: mindMap?.id ?? _uuid.v4(),
                      userId: userId,
                      folderName: folder,
                      title: title,
                      contentJson:
                          mindMap?.contentJson ??
                          MindMapCodec.encode(
                            MindMapDocument.initial(rootLabel: title),
                          ),
                      trackId: selectedTrack?.track.id,
                      moduleId: selectedModule?.id,
                      projectId: selectedProject?.project.id,
                      createdAt: mindMap?.createdAt ?? now,
                      updatedAt: now,
                    );

                    await ref.read(mindMapActionsProvider).save(updated);
                    if (!dialogContext.mounted) return;

                    setState(() {
                      _selectedFolder = folder;
                      _selectedMapId = updated.id;
                      _loadedMapId = null;
                    });
                    result = updated;
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(mindMap == null ? 'Criar' : 'Salvar'),
                ),
              ],
            );
          },
        );
      },
    );

    return result;
  }

  Future<MindMapCanvasNode?> _showNodeDialog(
    BuildContext context, {
    required MindMapCanvasNode initialNode,
  }) async {
    final labelController = TextEditingController(text: initialNode.label);
    var selectedShape = initialNode.shape;
    var selectedColor = initialNode.colorHex;
    MindMapCanvasNode? result;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final dialogWidth = responsiveDialogWidth(
          dialogContext,
          ideal: 560,
          min: 340,
        );
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            final size = _sizeForShape(selectedShape);
            final previewNode = initialNode.copyWith(
              label: labelController.text.trim().isEmpty
                  ? 'Novo conceito'
                  : labelController.text.trim(),
              shape: selectedShape,
              colorHex: selectedColor,
              width: size.width,
              height: size.height,
            );

            return AlertDialog(
              title: const Text('Configurar nó'),
              content: SizedBox(
                width: dialogWidth,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: labelController,
                        decoration: const InputDecoration(
                          labelText: 'Rótulo do nó',
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<MindMapNodeShape>(
                        initialValue: selectedShape,
                        decoration: const InputDecoration(
                          labelText: 'Forma geométrica',
                        ),
                        items: MindMapNodeShape.values
                            .map(
                              (shape) => DropdownMenuItem<MindMapNodeShape>(
                                value: shape,
                                child: Text(shape.label),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setDialogState(() => selectedShape = value);
                        },
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _mindMapPalette
                            .map(
                              (colorHex) => _ColorDot(
                                color: _colorFromHex(colorHex),
                                selected: selectedColor == colorHex,
                                onTap: () => setDialogState(
                                  () => selectedColor = colorHex,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 18),
                      Center(
                        child: _NodeCard(node: previewNode, selected: true),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () {
                    final label = labelController.text.trim();
                    if (label.isEmpty) {
                      dialogContext.showAppSnackBar(
                        'Defina um rótulo para o nó.',
                      );
                      return;
                    }

                    result = initialNode.copyWith(
                      label: label,
                      shape: selectedShape,
                      colorHex: selectedColor,
                      width: size.width,
                      height: size.height,
                    );
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );

    return result;
  }
}

class _MiniMindMapPreview extends StatelessWidget {
  const _MiniMindMapPreview({required this.document});

  final MindMapDocument document;

  @override
  Widget build(BuildContext context) {
    if (document.nodes.isEmpty) {
      return Center(
        child: Text(
          'Sem nós para pré-visualizar.',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface.withValues(alpha: 0.68),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final left = document.nodes
            .map((item) => item.x)
            .reduce((value, element) => math.min(value, element));
        final top = document.nodes
            .map((item) => item.y)
            .reduce((value, element) => math.min(value, element));
        final right = document.nodes
            .map((item) => item.x + item.width)
            .reduce((value, element) => math.max(value, element));
        final bottom = document.nodes
            .map((item) => item.y + item.height)
            .reduce((value, element) => math.max(value, element));

        const padding = 48.0;
        final contentWidth = math.max(right - left, 1.0);
        final contentHeight = math.max(bottom - top, 1.0);
        final scale = math
            .min(
              (constraints.maxWidth - padding * 2) / contentWidth,
              (constraints.maxHeight - padding * 2) / contentHeight,
            )
            .clamp(0.18, 0.72);

        final offsetX =
            (constraints.maxWidth - contentWidth * scale) / 2 - left * scale;
        final offsetY =
            (constraints.maxHeight - contentHeight * scale) / 2 - top * scale;

        final previewNodes = [
          for (final node in document.nodes)
            node.copyWith(
              x: offsetX + node.x * scale,
              y: offsetY + node.y * scale,
              width: math.max(74.0, node.width * scale),
              height: math.max(44.0, node.height * scale),
            ),
        ];

        return Stack(
          children: [
            const Positioned.fill(
              child: CustomPaint(painter: _MindMapGridPainter()),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: _MindMapConnectionsPainter(
                  nodes: previewNodes,
                  connections: document.connections,
                  selectedNodeId: null,
                  connectionSourceNodeId: null,
                ),
              ),
            ),
            for (final node in previewNodes)
              Positioned(
                left: node.x,
                top: node.y,
                child: _MiniNodeCard(node: node),
              ),
          ],
        );
      },
    );
  }
}

class _MapListTile extends StatelessWidget {
  const _MapListTile({
    required this.map,
    required this.document,
    required this.selected,
    required this.contextLabels,
    required this.onTap,
  });

  final MindMapEntity map;
  final MindMapDocument document;
  final bool selected;
  final List<String> contextLabels;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: selected
                  ? context.colorScheme.primary
                  : context.colorScheme.outline.withValues(alpha: 0.82),
            ),
            color: selected
                ? context.colorScheme.primary.withValues(alpha: 0.12)
                : context.colorScheme.surface.withValues(alpha: 0.18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                map.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${map.folderName} • ${_formatShortDate(map.updatedAt)}',
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ContextPill(label: '${document.nodes.length} nós'),
                  _ContextPill(
                    label: '${document.connections.length} conexões',
                  ),
                  ...contextLabels.map((item) => _ContextPill(label: item)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    this.primary = false,
  });

  final IconData icon;
  final String label;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final background = primary
        ? context.colorScheme.primary.withValues(alpha: 0.88)
        : context.colorScheme.surface.withValues(alpha: 0.24);
    final foreground = primary
        ? context.colorScheme.onPrimary
        : context.colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: background,
        border: Border.all(
          color: primary
              ? context.colorScheme.primary.withValues(alpha: 0.2)
              : context.colorScheme.outline.withValues(alpha: 0.8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: foreground),
          const SizedBox(width: 8),
          Text(
            label,
            style: context.textTheme.labelLarge?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionChipButton extends StatelessWidget {
  const _ActionChipButton({
    required this.onTap,
    required this.icon,
    required this.label,
  });

  final VoidCallback? onTap;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap == null ? 0.45 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onTap,
          child: _ActionChip(icon: icon, label: label),
        ),
      ),
    );
  }
}

class _FloatingPanel extends StatelessWidget {
  const _FloatingPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.colorScheme.surface.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: context.colorScheme.outline.withValues(alpha: 0.74),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.14),
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _OverlayToolButton extends StatelessWidget {
  const _OverlayToolButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.primary = false,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool primary;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    final scheme = context.colorScheme;
    final background = primary
        ? scheme.primary.withValues(alpha: disabled ? 0.36 : 0.92)
        : danger
        ? scheme.error.withValues(alpha: disabled ? 0.16 : 0.14)
        : scheme.surfaceContainerHighest.withValues(
            alpha: disabled ? 0.32 : 0.82,
          );
    final foreground = primary
        ? scheme.onPrimary
        : danger
        ? scheme.error
        : scheme.onSurface;

    return Opacity(
      opacity: disabled ? 0.46 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onTap,
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: background,
              border: Border.all(
                color: primary
                    ? scheme.primary.withValues(alpha: 0.24)
                    : danger
                    ? scheme.error.withValues(alpha: 0.22)
                    : scheme.outline.withValues(alpha: 0.6),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: foreground),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CanvasMetricChip extends StatelessWidget {
  const _CanvasMetricChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: context.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.82,
        ),
        border: Border.all(
          color: context.colorScheme.outline.withValues(alpha: 0.62),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: context.colorScheme.primary),
          const SizedBox(width: 7),
          Text(
            label,
            style: context.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContextPill extends StatelessWidget {
  const _ContextPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: context.colorScheme.primary.withValues(alpha: 0.10),
        border: Border.all(
          color: context.colorScheme.primary.withValues(alpha: 0.18),
        ),
      ),
      child: Text(
        label,
        style: context.textTheme.labelMedium?.copyWith(
          color: context.colorScheme.primary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(
            color: selected ? Colors.white : color.withValues(alpha: 0.22),
            width: selected ? 3 : 1,
          ),
        ),
      ),
    );
  }
}

class _NodeWidget extends StatelessWidget {
  const _NodeWidget({
    required this.node,
    required this.selected,
    required this.onTap,
    required this.onDrag,
    required this.onDragEnd,
  });

  final MindMapCanvasNode node;
  final bool selected;
  final VoidCallback onTap;
  final ValueChanged<Offset> onDrag;
  final VoidCallback onDragEnd;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.move,
      child: GestureDetector(
        onTap: onTap,
        onPanUpdate: (details) => onDrag(details.delta),
        onPanEnd: (_) => onDragEnd(),
        child: _NodeCard(node: node, selected: selected),
      ),
    );
  }
}

class _NodeCard extends StatelessWidget {
  const _NodeCard({required this.node, required this.selected});

  final MindMapCanvasNode node;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final accent = _colorFromHex(node.colorHex);
    final fill = accent;
    final foreground = _foregroundForNode(fill);
    final border = selected
        ? foreground.withValues(alpha: 0.96)
        : foreground.withValues(alpha: 0.26);

    final text = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Center(
        child: Text(
          node.label,
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: foreground,
          ),
        ),
      ),
    );

    switch (node.shape) {
      case MindMapNodeShape.rectangle:
        return Container(
          width: node.width,
          height: node.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: fill,
            border: Border.all(color: border, width: 1.4),
            boxShadow: _nodeShadow(accent, selected),
          ),
          child: text,
        );
      case MindMapNodeShape.rounded:
        return Container(
          width: node.width,
          height: node.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: fill,
            border: Border.all(color: border, width: 1.4),
            boxShadow: _nodeShadow(accent, selected),
          ),
          child: text,
        );
      case MindMapNodeShape.ellipse:
        return SizedBox(
          width: node.width,
          height: node.height,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: fill,
              shape: OvalBorder(side: BorderSide(color: border, width: 1.4)),
              shadows: _nodeShadow(accent, selected),
            ),
            child: text,
          ),
        );
      case MindMapNodeShape.diamond:
        final size = math.min(node.width, node.height);
        return SizedBox(
          width: size,
          height: size,
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              decoration: BoxDecoration(
                color: fill,
                border: Border.all(color: border, width: 1.4),
                boxShadow: _nodeShadow(accent, selected),
              ),
              child: Transform.rotate(angle: -math.pi / 4, child: text),
            ),
          ),
        );
    }
  }
}

class _MiniNodeCard extends StatelessWidget {
  const _MiniNodeCard({required this.node});

  final MindMapCanvasNode node;

  @override
  Widget build(BuildContext context) {
    final accent = _colorFromHex(node.colorHex);
    final foreground = _foregroundForNode(accent);
    final border = foreground.withValues(alpha: 0.22);

    final label = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Center(
        child: Text(
          node.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: context.textTheme.labelSmall?.copyWith(
            color: foreground,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );

    switch (node.shape) {
      case MindMapNodeShape.rectangle:
        return Container(
          width: node.width,
          height: node.height,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border),
          ),
          child: label,
        );
      case MindMapNodeShape.rounded:
        return Container(
          width: node.width,
          height: node.height,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: border),
          ),
          child: label,
        );
      case MindMapNodeShape.ellipse:
        return SizedBox(
          width: node.width,
          height: node.height,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: accent,
              shape: OvalBorder(side: BorderSide(color: border)),
            ),
            child: label,
          ),
        );
      case MindMapNodeShape.diamond:
        final size = math.min(node.width, node.height);
        return SizedBox(
          width: size,
          height: size,
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              decoration: BoxDecoration(
                color: accent,
                border: Border.all(color: border),
              ),
              child: Transform.rotate(angle: -math.pi / 4, child: label),
            ),
          ),
        );
    }
  }
}

class _MindMapGridPainter extends CustomPainter {
  const _MindMapGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final minor = Paint()
      ..color = const Color(0xFFCFD8E3).withValues(alpha: 0.24)
      ..strokeWidth = 1;
    final major = Paint()
      ..color = const Color(0xFFCFD8E3).withValues(alpha: 0.42)
      ..strokeWidth = 1.2;

    const minorStep = 40.0;
    const majorStep = 200.0;

    for (double x = 0; x <= size.width; x += minorStep) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        x % majorStep == 0 ? major : minor,
      );
    }
    for (double y = 0; y <= size.height; y += minorStep) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        y % majorStep == 0 ? major : minor,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MindMapConnectionsPainter extends CustomPainter {
  const _MindMapConnectionsPainter({
    required this.nodes,
    required this.connections,
    required this.selectedNodeId,
    required this.connectionSourceNodeId,
  });

  final List<MindMapCanvasNode> nodes;
  final List<MindMapCanvasConnection> connections;
  final String? selectedNodeId;
  final String? connectionSourceNodeId;

  @override
  void paint(Canvas canvas, Size size) {
    final nodeById = {for (final node in nodes) node.id: node};

    for (final connection in connections) {
      final source = nodeById[connection.sourceId];
      final target = nodeById[connection.targetId];
      if (source == null || target == null) continue;

      final sourceCenter = Offset(
        source.x + source.width / 2,
        source.y + source.height / 2,
      );
      final targetCenter = Offset(
        target.x + target.width / 2,
        target.y + target.height / 2,
      );
      final controlOffset = math.max(
        80.0,
        (targetCenter.dx - sourceCenter.dx).abs() * 0.35,
      );

      final active =
          selectedNodeId != null &&
          (connection.sourceId == selectedNodeId ||
              connection.targetId == selectedNodeId);
      final linking =
          connectionSourceNodeId != null &&
          (connection.sourceId == connectionSourceNodeId ||
              connection.targetId == connectionSourceNodeId);

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = active || linking ? 3.2 : 2.2
        ..strokeCap = StrokeCap.round
        ..color = active
            ? const Color(0xFF2EC5FF)
            : linking
            ? const Color(0xFF35D39A)
            : const Color(0xFF90A4AE).withValues(alpha: 0.72);

      final path = Path()
        ..moveTo(sourceCenter.dx, sourceCenter.dy)
        ..cubicTo(
          sourceCenter.dx + controlOffset,
          sourceCenter.dy,
          targetCenter.dx - controlOffset,
          targetCenter.dy,
          targetCenter.dx,
          targetCenter.dy,
        );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MindMapConnectionsPainter oldDelegate) {
    return oldDelegate.nodes != nodes ||
        oldDelegate.connections != connections ||
        oldDelegate.selectedNodeId != selectedNodeId ||
        oldDelegate.connectionSourceNodeId != connectionSourceNodeId;
  }
}

List<BoxShadow>? _nodeShadow(Color accent, bool selected) {
  if (!selected) return null;
  return [
    BoxShadow(
      color: accent.withValues(alpha: 0.22),
      blurRadius: 22,
      offset: const Offset(0, 12),
    ),
  ];
}

Size _sizeForShape(MindMapNodeShape shape) {
  switch (shape) {
    case MindMapNodeShape.rectangle:
      return const Size(220, 110);
    case MindMapNodeShape.rounded:
      return const Size(220, 116);
    case MindMapNodeShape.ellipse:
      return const Size(236, 132);
    case MindMapNodeShape.diamond:
      return const Size(164, 164);
  }
}

Offset _nextNodePosition(
  MindMapDocument document, {
  required double width,
  required double height,
  MindMapCanvasNode? baseNode,
}) {
  var candidate = Offset(
    baseNode == null ? 320 : baseNode.x + baseNode.width + 88,
    baseNode == null ? 440 : baseNode.y + 18,
  );

  for (var attempt = 0; attempt < 18; attempt++) {
    final candidateRect = Rect.fromLTWH(
      candidate.dx,
      candidate.dy,
      width,
      height,
    );
    final overlaps = document.nodes.any(
      (item) => candidateRect.overlaps(
        Rect.fromLTWH(item.x, item.y, item.width, item.height).inflate(24),
      ),
    );
    if (!overlaps) break;
    candidate = candidate.translate(46, 42);
  }

  return Offset(
    candidate.dx.clamp(0, _MindMapsScreenState._boardWidth - width),
    candidate.dy.clamp(0, _MindMapsScreenState._boardHeight - height),
  );
}

bool _isSameConnection(
  MindMapCanvasConnection connection, {
  required String sourceId,
  required String targetId,
}) {
  return (connection.sourceId == sourceId && connection.targetId == targetId) ||
      (connection.sourceId == targetId && connection.targetId == sourceId);
}

MindMapCanvasNode? _findNode(MindMapDocument document, String? nodeId) {
  if (nodeId == null) return null;
  for (final node in document.nodes) {
    if (node.id == nodeId) return node;
  }
  return null;
}

MindMapCanvasNode? _otherNode(
  MindMapDocument document,
  MindMapCanvasConnection connection,
  String currentNodeId,
) {
  final otherId = connection.sourceId == currentNodeId
      ? connection.targetId
      : connection.sourceId;
  return _findNode(document, otherId);
}

List<String> _mindMapContextLabels(
  MindMapEntity map, {
  required Map<String, String> trackNameById,
  required Map<String, String> moduleNameById,
  required Map<String, String> projectNameById,
}) {
  return [
    if (map.trackId != null && trackNameById.containsKey(map.trackId))
      trackNameById[map.trackId]!,
    if (map.moduleId != null && moduleNameById.containsKey(map.moduleId))
      moduleNameById[map.moduleId]!,
    if (map.projectId != null && projectNameById.containsKey(map.projectId))
      projectNameById[map.projectId]!,
  ];
}

TrackBlueprint? _findTrackBlueprint(
  List<TrackBlueprint> items,
  String? trackId,
) {
  if (trackId == null) return null;
  for (final item in items) {
    if (item.track.id == trackId) return item;
  }
  return null;
}

StudyModuleEntity? _findModule(
  List<StudyModuleEntity> items,
  String? moduleId,
) {
  if (moduleId == null) return null;
  for (final item in items) {
    if (item.id == moduleId) return item;
  }
  return null;
}

ProjectBundle? _findProjectBundle(
  List<ProjectBundle> items,
  String? projectId,
) {
  if (projectId == null) return null;
  for (final item in items) {
    if (item.project.id == projectId) return item;
  }
  return null;
}

String _formatShortDate(DateTime value) {
  final local = value.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  return '$day/$month';
}

String _formatDateTime(DateTime value) {
  final local = value.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$day/$month/${local.year} • $hour:$minute';
}

Color _colorFromHex(String value) {
  final normalized = value.replaceAll('#', '');
  final buffer = StringBuffer();
  if (normalized.length == 6) {
    buffer.write('FF');
  }
  buffer.write(normalized);
  return Color(int.parse(buffer.toString(), radix: 16));
}

Color _foregroundForNode(Color fill) {
  return fill.computeLuminance() > 0.58
      ? Colors.black.withValues(alpha: 0.82)
      : Colors.white.withValues(alpha: 0.96);
}

String _defaultColorForShape(MindMapNodeShape shape) {
  switch (shape) {
    case MindMapNodeShape.rectangle:
      return '#005F73';
    case MindMapNodeShape.rounded:
      return '#2EC5FF';
    case MindMapNodeShape.ellipse:
      return '#FFC857';
    case MindMapNodeShape.diamond:
      return '#35D39A';
  }
}

const _mindMapPalette = <String>[
  '#005F73',
  '#2EC5FF',
  '#35D39A',
  '#FFC857',
  '#EF476F',
  '#6C5CE7',
  '#0A9396',
  '#F4A261',
];
