import 'package:code_trail_windows/features/mind_maps/application/mind_map_codec.dart';
import 'package:code_trail_windows/features/mind_maps/application/mind_map_document.dart';
import 'package:code_trail_windows/shared/models/app_enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MindMapCodec', () {
    test('decode invalid content falls back to initial document', () {
      final document = MindMapCodec.decode('invalido');

      expect(document.nodes, hasLength(1));
      expect(document.connections, isEmpty);
      expect(document.nodes.single.label, 'Tema central');
    });

    test('encode and decode preserve nodes and connections', () {
      final document = MindMapDocument(
        nodes: const [
          MindMapCanvasNode(
            id: 'node-1',
            label: 'API',
            shape: MindMapNodeShape.rounded,
            colorHex: '#2EC5FF',
            x: 320,
            y: 240,
            width: 220,
            height: 116,
          ),
          MindMapCanvasNode(
            id: 'node-2',
            label: 'Banco',
            shape: MindMapNodeShape.diamond,
            colorHex: '#35D39A',
            x: 680,
            y: 420,
            width: 164,
            height: 164,
          ),
        ],
        connections: const [
          MindMapCanvasConnection(
            id: 'edge-1',
            sourceId: 'node-1',
            targetId: 'node-2',
          ),
        ],
      );

      final encoded = MindMapCodec.encode(document);
      final decoded = MindMapCodec.decode(encoded);

      expect(decoded, document);
    });
  });
}
