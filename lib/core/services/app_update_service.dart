import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_constants.dart';
import '../../shared/models/app_update_models.dart';

class AppUpdateService {
  AppUpdateService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static Uri get _latestReleaseUri => Uri.https(
    'api.github.com',
    '/repos/${AppConstants.windowsReleaseOwner}/${AppConstants.windowsReleaseRepo}/releases/latest',
  );

  Future<String> currentVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  Future<AppUpdateInfo?> fetchLatestUpdate({
    required String currentVersion,
  }) async {
    final response = await _client.get(
      _latestReleaseUri,
      headers: const {
        'Accept': 'application/vnd.github+json',
        'X-GitHub-Api-Version': '2022-11-28',
      },
    );

    if (response.statusCode >= 400) {
      throw HttpException(
        'Nao foi possivel consultar o GitHub Releases (${response.statusCode}).',
      );
    }

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    final tagName = (payload['tag_name'] as String? ?? '').trim();
    if (tagName.isEmpty || !_isNewerVersion(tagName, currentVersion)) {
      return null;
    }

    final assets = (payload['assets'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>();
    final installer = assets
        .map(
          (asset) => ReleaseAssetInfo(
            name: (asset['name'] as String? ?? '').trim(),
            downloadUrl:
                (asset['browser_download_url'] as String? ?? '').trim(),
            sizeBytes: (asset['size'] as num?)?.toInt() ?? 0,
          ),
        )
        .firstWhereOrNull(
          (asset) =>
              asset.downloadUrl.isNotEmpty &&
              asset.name.toLowerCase().endsWith('.exe') &&
              asset.name.toLowerCase().contains('setup'),
        );

    if (installer == null) {
      throw const FormatException(
        'A release mais recente nao possui um instalador setup.exe anexado.',
      );
    }

    return AppUpdateInfo(
      version: _normalizedVersion(tagName),
      tagName: tagName,
      releaseName:
          (payload['name'] as String? ?? '').trim().isEmpty
              ? tagName
              : (payload['name'] as String).trim(),
      notes: (payload['body'] as String? ?? '').trim(),
      htmlUrl: (payload['html_url'] as String? ?? '').trim(),
      publishedAt:
          DateTime.tryParse(payload['published_at'] as String? ?? '') ??
          DateTime.now().toUtc(),
      installerAsset: installer,
    );
  }

  Future<void> downloadAndInstall(
    AppUpdateInfo update, {
    void Function(double progress)? onProgress,
  }) async {
    final request = http.Request(
      'GET',
      Uri.parse(update.installerAsset.downloadUrl),
    );
    final response = await _client.send(request);
    if (response.statusCode >= 400) {
      throw HttpException(
        'Falha ao baixar o instalador (${response.statusCode}).',
      );
    }

    final downloadDirectory = await getTemporaryDirectory();
    final targetPath = path.join(downloadDirectory.path, update.installerAsset.name);
    final targetFile = File(targetPath);
    if (await targetFile.exists()) {
      await targetFile.delete();
    }

    final sink = targetFile.openWrite();
    final total = response.contentLength ?? 0;
    var received = 0;

    try {
      await for (final chunk in response.stream) {
        sink.add(chunk);
        received += chunk.length;
        if (total > 0 && onProgress != null) {
          onProgress(received / total);
        }
      }
    } finally {
      await sink.flush();
      await sink.close();
    }

    await Process.start(
      targetFile.path,
      const [],
      mode: ProcessStartMode.detached,
    );
  }

  Future<void> openReleaseNotes(AppUpdateInfo update) async {
    final uri = Uri.tryParse(update.htmlUrl);
    if (uri == null) {
      throw const FormatException('URL da release invalida.');
    }
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      throw const OSError('Nao foi possivel abrir a release no navegador.');
    }
  }

  bool _isNewerVersion(String latestTag, String currentVersion) {
    final latest = _parseVersionParts(latestTag);
    final current = _parseVersionParts(currentVersion);
    final length = latest.length > current.length ? latest.length : current.length;

    for (var index = 0; index < length; index++) {
      final left = index < latest.length ? latest[index] : 0;
      final right = index < current.length ? current[index] : 0;
      if (left > right) return true;
      if (left < right) return false;
    }

    return false;
  }

  List<int> _parseVersionParts(String version) {
    return _normalizedVersion(version)
        .split('.')
        .map((segment) => int.tryParse(segment) ?? 0)
        .toList();
  }

  String _normalizedVersion(String version) {
    final cleaned = version.trim().replaceFirst(RegExp(r'^[vV]'), '');
    return cleaned.split('+').first.split('-').first;
  }
}
