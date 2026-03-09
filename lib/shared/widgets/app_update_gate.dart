import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../features/auth/application/auth_controller.dart';
import '../../features/settings/application/app_update_controller.dart';
import '../extensions/context_extensions.dart';
import '../models/app_update_models.dart';

class AppUpdateGate extends ConsumerStatefulWidget {
  const AppUpdateGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppUpdateGate> createState() => _AppUpdateGateState();
}

class _AppUpdateGateState extends ConsumerState<AppUpdateGate> {
  bool _dialogOpen = false;
  bool _requestedForSession = false;
  late final ProviderSubscription<AsyncValue<dynamic>> _authSubscription;
  late final ProviderSubscription<AsyncValue<AppUpdateState>> _updateSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription = ref.listenManual(
      authSessionProvider,
      _handleSessionChange,
    );
    _updateSubscription = ref.listenManual(
      appUpdateControllerProvider,
      _handleUpdateChange,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestUpdateCheckIfNeeded();
    });
  }

  @override
  void dispose() {
    _authSubscription.close();
    _updateSubscription.close();
    super.dispose();
  }

  void _handleSessionChange(
    AsyncValue<dynamic>? previous,
    AsyncValue<dynamic> next,
  ) {
    final session = next.asData?.value;
    if (session == null) {
      _requestedForSession = false;
      _dialogOpen = false;
      return;
    }

    _requestUpdateCheckIfNeeded();
  }

  void _handleUpdateChange(
    AsyncValue<AppUpdateState>? previous,
    AsyncValue<AppUpdateState> next,
  ) {
    final snapshot = next.asData?.value;
    if (snapshot == null || !snapshot.shouldPrompt || _dialogOpen) return;

    final session = ref.read(authSessionProvider).asData?.value;
    if (session == null) return;

    _dialogOpen = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await ref.read(appUpdateControllerProvider.notifier).markPromptShown();
      await _showUpdateDialog(snapshot);
      _dialogOpen = false;
    });
  }

  Future<void> _showUpdateDialog(AppUpdateState snapshot) async {
    final update = snapshot.availableUpdate;
    if (update == null) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Nova versão disponível'),
          content: SizedBox(
            width: 520,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'A versão ${update.version} do CodeTrail Windows já está publicada no GitHub Releases.',
                ),
                const SizedBox(height: 12),
                Text(
                  'Versão atual: ${snapshot.currentVersion}\nPublicada em: ${DateFormat('dd/MM/yyyy HH:mm').format(update.publishedAt.toLocal())}',
                ),
                if (update.notes.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    update.notes.length > 280
                        ? '${update.notes.substring(0, 280)}...'
                        : update.notes,
                    style: Theme.of(dialogContext).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await ref
                    .read(appUpdateControllerProvider.notifier)
                    .dismissCurrentUpdate();
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('Ignorar esta versão'),
            ),
            TextButton(
              onPressed: () async {
                await ref.read(appUpdateControllerProvider.notifier).openReleaseNotes();
              },
              child: const Text('Ver mudanças'),
            ),
            FilledButton(
              onPressed: () async {
                final started = await ref
                    .read(appUpdateControllerProvider.notifier)
                    .downloadAndInstall();
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
                if (mounted && started) {
                  context.showAppSnackBar(
                    'Instalador iniciado. Conclua a atualização para aplicar a nova versão.',
                  );
                }
              },
              child: const Text('Atualizar agora'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = ref.watch(currentUserIdProvider);
    final updateState = ref.watch(appUpdateControllerProvider).asData?.value;
    final session = ref.watch(authSessionProvider).asData?.value;
    final visibleUpdate = updateState?.availableUpdate;
    if (currentUserId != null && !_requestedForSession) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _requestUpdateCheckIfNeeded();
      });
    }
    final showBanner =
        session != null &&
        updateState != null &&
        visibleUpdate != null &&
        visibleUpdate.tagName != updateState.dismissedVersion;

    return Stack(
      children: [
        widget.child,
        if (showBanner)
          Positioned(
            top: 14,
            left: 24,
            right: 24,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 920),
                child: _UpdateBanner(
                  state: updateState,
                  onDismiss: () async {
                    await ref
                        .read(appUpdateControllerProvider.notifier)
                        .dismissCurrentUpdate();
                  },
                  onOpenNotes: () async {
                    await ref
                        .read(appUpdateControllerProvider.notifier)
                        .openReleaseNotes();
                  },
                  onInstall: () async {
                    final started = await ref
                        .read(appUpdateControllerProvider.notifier)
                        .downloadAndInstall();
                    if (!mounted || !started) return;
                    this.context.showAppSnackBar(
                      'Instalador iniciado. Conclua a atualização para aplicar a nova versão.',
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _requestUpdateCheckIfNeeded() {
    if (!mounted || _requestedForSession) return;
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;
    _requestedForSession = true;
    unawaited(ref.read(appUpdateControllerProvider.notifier).checkForUpdates());
  }
}

class _UpdateBanner extends StatelessWidget {
  const _UpdateBanner({
    required this.state,
    required this.onDismiss,
    required this.onOpenNotes,
    required this.onInstall,
  });

  final AppUpdateState state;
  final Future<void> Function() onDismiss;
  final Future<void> Function() onOpenNotes;
  final Future<void> Function() onInstall;

  @override
  Widget build(BuildContext context) {
    final update = state.availableUpdate!;
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 16, 16, 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: scheme.surface.withValues(alpha: 0.96),
          border: Border.all(color: scheme.primary.withValues(alpha: 0.32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.24),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scheme.primary.withValues(alpha: 0.14),
                  ),
                  child: Icon(
                    state.isDownloading
                        ? Icons.downloading_rounded
                        : Icons.system_update_alt_rounded,
                    color: scheme.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.isDownloading
                            ? 'Baixando atualização ${update.version}'
                            : 'Atualização disponível: ${update.version}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Versão atual ${state.currentVersion} • publicada em ${DateFormat('dd/MM/yyyy HH:mm').format(update.publishedAt.toLocal())}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: scheme.onSurface.withValues(alpha: 0.72),
                            ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Ignorar esta versão',
                  onPressed: state.isDownloading ? null : onDismiss,
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            if (update.notes.isNotEmpty) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  update.notes.length > 180
                      ? '${update.notes.substring(0, 180)}...'
                      : update.notes,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.76),
                      ),
                ),
              ),
            ],
            if (state.isDownloading) ...[
              const SizedBox(height: 14),
              LinearProgressIndicator(
                value: state.downloadProgress,
                minHeight: 8,
                borderRadius: BorderRadius.circular(999),
              ),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: state.isDownloading ? null : onOpenNotes,
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: const Text('Ver mudanças'),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: state.isDownloading ? null : onInstall,
                  icon: Icon(
                    state.isDownloading
                        ? Icons.hourglass_top_rounded
                        : Icons.download_rounded,
                  ),
                  label: Text(
                    state.isDownloading
                        ? 'Baixando...'
                        : 'Atualizar agora',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
