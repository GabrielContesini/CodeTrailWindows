import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/layout_utils.dart';
import '../../../domain/entities/app_entities.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/models/app_enums.dart';
import '../../../shared/models/page_tutorial.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/page_frame.dart';
import '../../auth/application/auth_controller.dart';
import '../application/reviews_controller.dart';

class ReviewsScreen extends ConsumerWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(reviewsProvider);

    return PageFrame(
      title: 'Revisões',
      subtitle: 'Ciclos de revisão D+1, D+7, D+15 e D+30.',
      tutorial: const PageTutorialData(
        id: 'reviews',
        title: 'Como usar revisões',
        description:
            'Esta área gera e acompanha revisão espaçada com notificações locais.',
        steps: [
          'Gere um ciclo para o conteúdo que precisa ser lembrado.',
          'Edite data, notas e status quando o plano real mudar.',
          'Concluir ou excluir um item atualiza a fila e os lembretes.',
        ],
      ),
      actions: [
        FilledButton.icon(
          onPressed: () => _showReviewCycleDialog(context, ref),
          icon: const Icon(Icons.schedule_rounded),
          label: const Text('Gerar ciclo'),
        ),
      ],
      child: reviewsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => ListView(
          children: const [
            AppCard(
              child: Text('Não foi possível carregar as revisões.'),
            ),
          ],
        ),
        data: (reviews) {
          if (reviews.isEmpty) {
            return ListView(
              children: const [
                AppCard(
                  child: Text(
                    'Nenhuma revisão cadastrada ainda. Gere um ciclo para começar.',
                  ),
                ),
              ],
            );
          }

          return ListView.separated(
            itemCount: reviews.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final review = reviews[index];
              return AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review.title,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${review.intervalLabel} • ${review.status.label} • ${_formatDate(review.scheduledFor)}',
                              ),
                            ],
                          ),
                        ),
                        if (review.status == ReviewStatus.completed)
                          const Icon(Icons.check_circle_rounded)
                        else
                          FilledButton.tonal(
                            onPressed: () =>
                                ref.read(reviewActionsProvider).complete(review),
                            child: const Text('Concluir'),
                          ),
                      ],
                    ),
                    if ((review.notes ?? '').trim().isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        review.notes!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        FilledButton.tonalIcon(
                          onPressed: () => _showReviewEditDialog(
                            context,
                            ref,
                            initial: review,
                          ),
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Editar'),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton.icon(
                          onPressed: () =>
                              _confirmDelete(context, ref, review),
                          icon: const Icon(Icons.delete_outline_rounded),
                          label: const Text('Excluir'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

Future<void> _showReviewCycleDialog(BuildContext context, WidgetRef ref) async {
  final userId = ref.read(currentUserIdProvider);
  if (userId == null) return;

  final titleController = TextEditingController();
  final notesController = TextEditingController();
  final uuid = const Uuid();

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final dialogWidth = responsiveDialogWidth(
        dialogContext,
        ideal: 420,
        min: 300,
      );
      return AlertDialog(
        title: const Text('Gerar ciclo de revisão'),
        content: SizedBox(
          width: dialogWidth,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Conteúdo'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notas'),
                  minLines: 2,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              final title = titleController.text.trim();
              if (title.isEmpty) {
                dialogContext.showAppSnackBar('Informe o conteúdo da revisão.');
                return;
              }

              final now = DateTime.now().toUtc();
              final schedule = [1, 7, 15, 30];
              final items = schedule
                  .map(
                    (days) => ReviewEntity(
                      id: uuid.v4(),
                      userId: userId,
                      title: title,
                      scheduledFor: now.add(Duration(days: days)),
                      status: ReviewStatus.pending,
                      intervalLabel: 'D+$days',
                      notes: notesController.text.trim(),
                      createdAt: now,
                      updatedAt: now,
                    ),
                  )
                  .toList();

              await ref.read(reviewActionsProvider).saveBatch(items);
              if (dialogContext.mounted) Navigator.of(dialogContext).pop();
            },
            child: const Text('Gerar'),
          ),
        ],
      );
    },
  );
}

Future<void> _showReviewEditDialog(
  BuildContext context,
  WidgetRef ref, {
  required ReviewEntity initial,
}) async {
  final titleController = TextEditingController(text: initial.title);
  final notesController = TextEditingController(text: initial.notes ?? '');
  final intervalController = TextEditingController(text: initial.intervalLabel);
  var status = initial.status;
  var scheduledFor = initial.scheduledFor.toLocal();

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (dialogContext, setState) {
          final dialogWidth = responsiveDialogWidth(
            dialogContext,
            ideal: 480,
            min: 320,
          );
          return AlertDialog(
            title: const Text('Editar revisão'),
            content: SizedBox(
              width: dialogWidth,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Conteúdo'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: intervalController,
                      decoration: const InputDecoration(
                        labelText: 'Intervalo',
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<ReviewStatus>(
                      initialValue: status,
                      decoration: const InputDecoration(labelText: 'Status'),
                      items: ReviewStatus.values
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(item.label),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => status = value ?? status),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Data da revisão'),
                      subtitle: Text(_formatDate(scheduledFor)),
                      trailing: const Icon(Icons.event_outlined),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: dialogContext,
                          initialDate: scheduledFor,
                          firstDate: DateTime.now().subtract(
                            const Duration(days: 365),
                          ),
                          lastDate: DateTime.now().add(
                            const Duration(days: 3650),
                          ),
                        );
                        if (picked != null) {
                          setState(() {
                            scheduledFor = DateTime(
                              picked.year,
                              picked.month,
                              picked.day,
                              scheduledFor.hour,
                              scheduledFor.minute,
                            );
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notas',
                        alignLabelWithHint: true,
                      ),
                      minLines: 3,
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () async {
                  final title = titleController.text.trim();
                  final interval = intervalController.text.trim();
                  if (title.isEmpty || interval.isEmpty) {
                    dialogContext.showAppSnackBar(
                      'Preencha conteúdo e intervalo.',
                    );
                    return;
                  }

                  final now = DateTime.now().toUtc();
                  await ref.read(reviewActionsProvider).save(
                        initial.copyWith(
                          title: title,
                          intervalLabel: interval,
                          status: status,
                          scheduledFor: scheduledFor.toUtc(),
                          notes: notesController.text.trim(),
                          completedAt: status == ReviewStatus.completed
                              ? (initial.completedAt ?? now)
                              : null,
                          updatedAt: now,
                        ),
                      );
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                    context.showAppSnackBar('Revisão atualizada.');
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> _confirmDelete(
  BuildContext context,
  WidgetRef ref,
  ReviewEntity review,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Excluir revisão'),
        content: Text('Remover o item ${review.intervalLabel} de ${review.title}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      );
    },
  );

  if (confirmed != true) return;

  await ref.read(reviewActionsProvider).delete(review);
  if (context.mounted) {
    context.showAppSnackBar('Revisão removida.');
  }
}

String _formatDate(DateTime value) {
  final local = value.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  return '$day/$month/${local.year}';
}
