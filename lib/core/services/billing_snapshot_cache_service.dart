import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/entities/billing_entities.dart';

class BillingSnapshotCacheService {
  const BillingSnapshotCacheService(this._storage);

  final FlutterSecureStorage _storage;

  String _keyFor(String userId) => 'billing_snapshot_$userId';

  Future<BillingSnapshot?> read(String userId) async {
    final raw = await _storage.read(key: _keyFor(userId));
    if (raw == null || raw.isEmpty) return null;

    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      return null;
    }
    return BillingSnapshot.fromJson(decoded);
  }

  Future<void> write(String userId, BillingSnapshot snapshot) {
    return _storage.write(
      key: _keyFor(userId),
      value: jsonEncode(snapshot.toJson()),
    );
  }

  Future<void> clear(String userId) {
    return _storage.delete(key: _keyFor(userId));
  }
}
