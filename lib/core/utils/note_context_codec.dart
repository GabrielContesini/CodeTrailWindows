class NoteContextLink {
  const NoteContextLink({
    this.trackId,
    this.trackLabel,
    this.moduleId,
    this.moduleLabel,
    this.projectId,
    this.projectLabel,
  });

  final String? trackId;
  final String? trackLabel;
  final String? moduleId;
  final String? moduleLabel;
  final String? projectId;
  final String? projectLabel;

  bool get hasContext =>
      _hasValue(trackId) ||
      _hasValue(trackLabel) ||
      _hasValue(moduleId) ||
      _hasValue(moduleLabel) ||
      _hasValue(projectId) ||
      _hasValue(projectLabel);

  List<String> get labels => [
    if (_hasValue(trackLabel)) trackLabel!.trim(),
    if (_hasValue(moduleLabel)) moduleLabel!.trim(),
    if (_hasValue(projectLabel)) projectLabel!.trim(),
  ];

  static bool _hasValue(String? value) => value != null && value.trim().isNotEmpty;
}

class NoteContentDocument {
  const NoteContentDocument({
    required this.body,
    this.context = const NoteContextLink(),
  });

  final String body;
  final NoteContextLink context;

  String get searchableText => [
    body,
    ...context.labels,
  ].join(' ').trim();
}

class NoteContextCodec {
  const NoteContextCodec._();

  static const String _header = '[codetrail_context]';
  static const String _footer = '[/codetrail_context]';

  static NoteContentDocument decode(String rawContent) {
    final normalized = rawContent.replaceAll('\r\n', '\n').trim();
    if (!normalized.startsWith('$_header\n')) {
      return NoteContentDocument(body: normalized);
    }

    final footerIndex = normalized.indexOf('\n$_footer');
    if (footerIndex == -1) {
      return NoteContentDocument(body: normalized);
    }

    final metadataBlock = normalized.substring(_header.length + 1, footerIndex);
    final bodyStart = footerIndex + _footer.length + 2;
    final values = <String, String>{};

    for (final line in metadataBlock.split('\n')) {
      final separator = line.indexOf('=');
      if (separator <= 0) {
        continue;
      }
      final key = line.substring(0, separator).trim();
      final value = line.substring(separator + 1).trim();
      if (key.isNotEmpty && value.isNotEmpty) {
        values[key] = value;
      }
    }

    return NoteContentDocument(
      body: normalized.substring(bodyStart).trim(),
      context: NoteContextLink(
        trackId: values['track_id'],
        trackLabel: values['track_label'],
        moduleId: values['module_id'],
        moduleLabel: values['module_label'],
        projectId: values['project_id'],
        projectLabel: values['project_label'],
      ),
    );
  }

  static String encode({
    required String body,
    NoteContextLink context = const NoteContextLink(),
  }) {
    final normalizedBody = body.trim();
    if (!context.hasContext) {
      return normalizedBody;
    }

    final metadataLines = <String>[
      if (_hasValue(context.trackId)) 'track_id=${context.trackId!.trim()}',
      if (_hasValue(context.trackLabel))
        'track_label=${context.trackLabel!.trim()}',
      if (_hasValue(context.moduleId)) 'module_id=${context.moduleId!.trim()}',
      if (_hasValue(context.moduleLabel))
        'module_label=${context.moduleLabel!.trim()}',
      if (_hasValue(context.projectId))
        'project_id=${context.projectId!.trim()}',
      if (_hasValue(context.projectLabel))
        'project_label=${context.projectLabel!.trim()}',
    ];

    return <String>[
      _header,
      ...metadataLines,
      _footer,
      '',
      normalizedBody,
    ].join('\n');
  }

  static bool _hasValue(String? value) => value != null && value.trim().isNotEmpty;
}
