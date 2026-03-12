import 'dart:convert';

import '../../../shared/models/app_enums.dart';
import 'mind_map_document.dart';

class MindMapCodec {
  const MindMapCodec._();

  static String encode(MindMapDocument document) {
    return jsonEncode({
      'schema_version': 1,
      'nodes': document.nodes
          .map(
            (node) => {
              'id': node.id,
              'label': node.label,
              'shape': node.shape.name,
              'color_hex': node.colorHex,
              'x': node.x,
              'y': node.y,
              'width': node.width,
              'height': node.height,
            },
          )
          .toList(),
      'connections': document.connections
          .map(
            (connection) => {
              'id': connection.id,
              'source_id': connection.sourceId,
              'target_id': connection.targetId,
            },
          )
          .toList(),
    });
  }

  static MindMapDocument decode(
    String? raw, {
    String fallbackLabel = 'Tema central',
  }) {
    if (raw == null || raw.trim().isEmpty) {
      return MindMapDocument.initial(rootLabel: fallbackLabel);
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return MindMapDocument.initial(rootLabel: fallbackLabel);
      }

      final nodes = (decoded['nodes'] as List<dynamic>? ?? const <dynamic>[])
          .map((item) => _decodeNode(item))
          .whereType<MindMapCanvasNode>()
          .toList();

      if (nodes.isEmpty) {
        return MindMapDocument.initial(rootLabel: fallbackLabel);
      }

      final nodeIds = nodes.map((item) => item.id).toSet();
      final connections =
          (decoded['connections'] as List<dynamic>? ?? const <dynamic>[])
              .map((item) => _decodeConnection(item))
              .whereType<MindMapCanvasConnection>()
              .where(
                (item) =>
                    item.sourceId != item.targetId &&
                    nodeIds.contains(item.sourceId) &&
                    nodeIds.contains(item.targetId),
              )
              .toList();

      return MindMapDocument(nodes: nodes, connections: connections);
    } catch (_) {
      return MindMapDocument.initial(rootLabel: fallbackLabel);
    }
  }

  static MindMapCanvasNode? _decodeNode(dynamic item) {
    if (item is! Map<String, dynamic>) return null;

    final shapeName =
        item['shape']?.toString() ?? MindMapNodeShape.rounded.name;

    MindMapNodeShape shape;
    try {
      shape = MindMapNodeShape.values.byName(shapeName);
    } catch (_) {
      shape = MindMapNodeShape.rounded;
    }

    final width = (item['width'] as num?)?.toDouble() ?? 220;
    final height = (item['height'] as num?)?.toDouble() ?? 116;

    return MindMapCanvasNode(
      id: item['id']?.toString() ?? '',
      label: item['label']?.toString() ?? 'Novo conceito',
      shape: shape,
      colorHex: item['color_hex']?.toString() ?? '#2EC5FF',
      x: (item['x'] as num?)?.toDouble() ?? 320,
      y: (item['y'] as num?)?.toDouble() ?? 260,
      width: width,
      height: height,
    );
  }

  static MindMapCanvasConnection? _decodeConnection(dynamic item) {
    if (item is! Map<String, dynamic>) return null;

    return MindMapCanvasConnection(
      id: item['id']?.toString() ?? '',
      sourceId: item['source_id']?.toString() ?? '',
      targetId: item['target_id']?.toString() ?? '',
    );
  }
}
