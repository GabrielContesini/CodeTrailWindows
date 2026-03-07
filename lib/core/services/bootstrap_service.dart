import 'package:flutter/widgets.dart';

import 'supabase_service.dart';

class BootstrapService {
  const BootstrapService._();

  static bool _initialized = false;

  static Future<void> ensureInitialized() async {
    if (_initialized) return;

    WidgetsFlutterBinding.ensureInitialized();
    await SupabaseService.initialize();
    _initialized = true;
  }
}
