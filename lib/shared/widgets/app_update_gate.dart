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

    if (_requestedForSession) return;
    _requestedForSession = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appUpdateControllerProvider.notifier).checkForUpdates();
    });
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
    return widget.child;
  }
}
