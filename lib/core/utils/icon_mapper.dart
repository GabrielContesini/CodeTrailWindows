import 'package:flutter/material.dart';

class IconMapper {
  const IconMapper._();

  static IconData fromKey(String key) {
    switch (key) {
      case 'database':
        return Icons.storage_rounded;
      case 'server':
        return Icons.dns_rounded;
      case 'code':
        return Icons.code_rounded;
      case 'monitor':
        return Icons.monitor_rounded;
      case 'layers':
        return Icons.layers_rounded;
      case 'cloud':
        return Icons.cloud_queue_rounded;
      case 'chart':
        return Icons.query_stats_rounded;
      case 'book':
        return Icons.menu_book_rounded;
      case 'rocket':
        return Icons.history_edu_rounded;
      case 'notes':
        return Icons.note_alt_rounded;
      case 'cards':
        return Icons.style_rounded;
      case 'mindmap':
        return Icons.account_tree_rounded;
      default:
        return Icons.auto_awesome_rounded;
    }
  }
}
