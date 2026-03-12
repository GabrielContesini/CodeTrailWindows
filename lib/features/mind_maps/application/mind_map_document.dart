import 'package:equatable/equatable.dart';

import '../../../shared/models/app_enums.dart';

class MindMapDocument extends Equatable {
  const MindMapDocument({required this.nodes, required this.connections});

  factory MindMapDocument.initial({String rootLabel = 'Tema central'}) {
    return MindMapDocument(
      nodes: [
        MindMapCanvasNode(
          id: 'root-node',
          label: rootLabel,
          shape: MindMapNodeShape.rounded,
          colorHex: '#2EC5FF',
          x: 320,
          y: 260,
          width: 220,
          height: 116,
        ),
      ],
      connections: const [],
    );
  }

  final List<MindMapCanvasNode> nodes;
  final List<MindMapCanvasConnection> connections;

  MindMapDocument copyWith({
    List<MindMapCanvasNode>? nodes,
    List<MindMapCanvasConnection>? connections,
  }) {
    return MindMapDocument(
      nodes: nodes ?? this.nodes,
      connections: connections ?? this.connections,
    );
  }

  @override
  List<Object?> get props => [nodes, connections];
}

class MindMapCanvasNode extends Equatable {
  const MindMapCanvasNode({
    required this.id,
    required this.label,
    required this.shape,
    required this.colorHex,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  final String id;
  final String label;
  final MindMapNodeShape shape;
  final String colorHex;
  final double x;
  final double y;
  final double width;
  final double height;

  MindMapCanvasNode copyWith({
    String? id,
    String? label,
    MindMapNodeShape? shape,
    String? colorHex,
    double? x,
    double? y,
    double? width,
    double? height,
  }) {
    return MindMapCanvasNode(
      id: id ?? this.id,
      label: label ?? this.label,
      shape: shape ?? this.shape,
      colorHex: colorHex ?? this.colorHex,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  @override
  List<Object?> get props => [id, label, shape, colorHex, x, y, width, height];
}

class MindMapCanvasConnection extends Equatable {
  const MindMapCanvasConnection({
    required this.id,
    required this.sourceId,
    required this.targetId,
  });

  final String id;
  final String sourceId;
  final String targetId;

  @override
  List<Object?> get props => [id, sourceId, targetId];
}
