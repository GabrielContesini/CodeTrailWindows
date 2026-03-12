import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/layout_utils.dart';
import '../../../domain/entities/app_entities.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/models/app_enums.dart';
import '../../../shared/models/app_view_models.dart';
import '../../../shared/models/page_tutorial.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/page_frame.dart';
import '../../auth/application/auth_controller.dart';
import '../../projects/application/projects_controller.dart';
import '../../tracks/application/tracks_controller.dart';
import '../application/mind_map_codec.dart';
import '../application/mind_map_document.dart';
import '../application/mind_maps_controller.dart';

class MindMapsScreen extends ConsumerStatefulWidget {
  const MindMapsScreen({super.key});

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

  String _selectedFolder = 'Todas';
  String? _selectedMapId;
  String _searchQuery = '';
  String? _selectedNodeId;
  MindMapDocument? _draftDocument;
  String? _loadedMapId;
  bool _connectMode = false;
  String? _connectionSourceNodeId;

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mindMapsAsync = ref.watch(mindMapsProvider);
    final trackBlueprints =
        ref.watch(trackBlueprintsProvider).asData?.value ??
        const <TrackBlueprint>[];
    final projectBundles =
        ref.watch(projectsProvider).asData?.value ?? const <ProjectBundle>[];

    return PageFrame(
      title: 'Mind Maps',
      subtitle:
          'Organize conceitos, dependências e trilhas visuais em um canvas com zoom, drag e conexões.',
      tutorial: const PageTutorialData(
        id: 'mind-maps',
        title: 'Como usar mind maps',
        description:
            'Crie um board, adicione formas e conecte os nós para construir seu mapa mental de estudo.',
        steps: [
          'Abra um mapa por trilha, módulo ou projeto.',
          'Adicione formas geométricas para conceitos, dúvidas e checkpoints.',
          'Arraste os blocos no canvas e use Conectar para ligar ideias.',
        ],
      ),
      actions: [
        FilledButton.icon(
          onPressed: () => _showMindMapDialog(
            context,
            trackBlueprints: trackBlueprints,
            projectBundles: projectBundles,
          ),
          icon: const Icon(Icons.account_tree_outlined),
          label: const Text('Novo mapa'),
        ),
      ],
      child: AsyncValueView(
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
                onPressed: () => _showMindMapDialog(
                  context,
                  trackBlueprints: trackBlueprints,
                  projectBundles: projectBundles,
                ),
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

          if (_selectedMapId == null ||
              filteredMaps.every((item) => item.id != _selectedMapId)) {
            _selectedMapId = filteredMaps.isNotEmpty
                ? filteredMaps.first.id
                : null;
          }

          MindMapEntity? selectedMap;
          for (final item in filteredMaps) {
            if (item.id == _selectedMapId) {
              selectedMap = item;
              break;
            }
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

          final library = _buildLibrary(
            context,
            filteredMaps,
            folderOptions,
            trackNameById,
            moduleNameById,
            projectNameById,
          );
          final workspace = selectedMap == null || selectedDocument == null
              ? AppCard(
                  child: EmptyState(
                    title: 'Nenhum mapa encontrado',
                    subtitle:
                        'Ajuste o filtro da biblioteca ou crie um novo board para continuar.',
                  ),
                )
              : _buildWorkspace(
                  context,
                  selectedMap,
                  selectedDocument,
                  selectedNode,
                  trackNameById,
                  moduleNameById,
                  projectNameById,
                  trackBlueprints,
                  projectBundles,
                );

          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 1360) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(width: 320, child: library),
                    const SizedBox(width: 16),
                    Expanded(child: workspace),
                  ],
                );
              }

              return Column(
                children: [
                  SizedBox(height: 300, child: library),
                  const SizedBox(height: 16),
                  Expanded(child: workspace),
                ],
              );
            },
          );
        },
      ),
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
            'Biblioteca visual',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${maps.length} mapa(s) visível(is) no filtro atual.',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _selectedFolder,
            decoration: const InputDecoration(labelText: 'Filtrar por pasta'),
            items: folderOptions
                .map(
                  (item) =>
                      DropdownMenuItem<String>(value: item, child: Text(item)),
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
          const SizedBox(height: 12),
          TextField(
            onChanged: (value) => setState(() {
              _searchQuery = value;
              _selectedMapId = null;
            }),
            decoration: InputDecoration(
              labelText: 'Buscar por título ou contexto',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _searchQuery.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () => setState(() => _searchQuery = ''),
                      icon: const Icon(Icons.close_rounded),
                    ),
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: maps.isEmpty
                ? Center(
                    child: Text(
                      'Nenhum mapa encontrado nesse filtro.',
                      style: context.textTheme.bodyMedium,
                    ),
                  )
                : ListView.separated(
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
        ],
      ),
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
    List<ProjectBundle> projectBundles,
  ) {
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
        final canvas = _buildCanvas(context, map, document);
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
            460.0,
            math.min(760.0, constraints.maxHeight * 0.62),
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

        return Column(
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
              compact: false,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: canvas),
                  const SizedBox(width: 16),
                  SizedBox(width: inspectorWidth, child: inspector),
                ],
              ),
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
    required bool compact,
  }) {
    final actions = Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
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
    setState(() => _draftDocument = updated);
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
    setState(() => _selectedNodeId = node.id);

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

  Future<void> _showMindMapDialog(
    BuildContext context, {
    required List<TrackBlueprint> trackBlueprints,
    required List<ProjectBundle> projectBundles,
    MindMapEntity? mindMap,
  }) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    final folderController = TextEditingController(
      text: mindMap?.folderName ?? 'Geral',
    );
    final titleController = TextEditingController(text: mindMap?.title ?? '');
    String? selectedTrackId = mindMap?.trackId;
    String? selectedModuleId = mindMap?.moduleId;
    String? selectedProjectId = mindMap?.projectId;

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
    final fill = accent.withValues(alpha: selected ? 0.26 : 0.16);
    final border = selected
        ? accent
        : context.colorScheme.outline.withValues(alpha: 0.82);

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
