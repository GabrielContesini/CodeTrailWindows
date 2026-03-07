import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../errors/app_exception.dart';

class GitHubRepositorySummary {
  const GitHubRepositorySummary({
    required this.id,
    required this.name,
    required this.fullName,
    required this.description,
    required this.htmlUrl,
    required this.homepageUrl,
    required this.language,
    required this.isPrivate,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final String fullName;
  final String description;
  final String htmlUrl;
  final String? homepageUrl;
  final String? language;
  final bool isPrivate;
  final DateTime updatedAt;

  factory GitHubRepositorySummary.fromJson(Map<String, dynamic> json) {
    return GitHubRepositorySummary(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'repo',
      fullName: json['full_name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      htmlUrl: json['html_url'] as String? ?? '',
      homepageUrl: json['homepage'] as String?,
      language: json['language'] as String?,
      isPrivate: json['private'] as bool? ?? false,
      updatedAt:
          DateTime.tryParse(json['updated_at'] as String? ?? '')?.toUtc() ??
          DateTime.now().toUtc(),
    );
  }
}

class GitHubService {
  GitHubService(this._storage, {http.Client? client})
    : _client = client ?? http.Client();

  final FlutterSecureStorage _storage;
  final http.Client _client;

  static const _tokenKey = 'github.personal_access_token';

  Future<String?> readToken() => _storage.read(key: _tokenKey);

  Future<void> saveToken(String token) {
    return _storage.write(key: _tokenKey, value: token.trim());
  }

  Future<void> clearToken() {
    return _storage.delete(key: _tokenKey);
  }

  Future<List<GitHubRepositorySummary>> fetchRepositories({
    String? token,
  }) async {
    final effectiveToken = token?.trim().isNotEmpty == true
        ? token!.trim()
        : await readToken();

    if (effectiveToken == null || effectiveToken.isEmpty) {
      throw const AppException(
        'Informe um token pessoal do GitHub para sincronizar os repositórios.',
      );
    }

    if (token != null && token.trim().isNotEmpty) {
      await saveToken(token);
    }

    final response = await _client.get(
      Uri.parse('https://api.github.com/user/repos?per_page=100&sort=updated'),
      headers: {
        'Accept': 'application/vnd.github+json',
        'Authorization': 'Bearer $effectiveToken',
        'X-GitHub-Api-Version': '2022-11-28',
      },
    );

    if (response.statusCode == 200) {
      final items = jsonDecode(response.body) as List<dynamic>;
      return items
          .whereType<Map<String, dynamic>>()
          .map(GitHubRepositorySummary.fromJson)
          .toList();
    }

    final message = _extractErrorMessage(response.body);
    if (response.statusCode == 401) {
      throw AppException(
        message.isEmpty ? 'Token do GitHub inválido ou expirado.' : message,
      );
    }

    if (response.statusCode == 403) {
      throw AppException(
        message.isEmpty
            ? 'GitHub recusou a requisição. Verifique o escopo do token.'
            : message,
      );
    }

    throw AppException(
      message.isEmpty
          ? 'Não foi possível carregar os repositórios do GitHub.'
          : message,
    );
  }

  String _extractErrorMessage(String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      return json['message'] as String? ?? '';
    } catch (_) {
      return '';
    }
  }
}
