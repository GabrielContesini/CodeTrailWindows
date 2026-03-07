import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TutorialService {
  const TutorialService(this._storage);

  final FlutterSecureStorage _storage;

  String _key(String tutorialId) => 'tutorial.seen.$tutorialId';

  Future<bool> shouldShow(String tutorialId) async {
    final value = await _storage.read(key: _key(tutorialId));
    return value != 'true';
  }

  Future<void> markSeen(String tutorialId) {
    return _storage.write(key: _key(tutorialId), value: 'true');
  }

  Future<void> resetTutorials() async {
    final items = await _storage.readAll();
    final tutorialKeys = items.keys
        .where((key) => key.startsWith('tutorial.seen.'))
        .toList();

    for (final key in tutorialKeys) {
      await _storage.delete(key: key);
    }
  }
}
