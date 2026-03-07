import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/layout_utils.dart';
import '../../../domain/entities/app_entities.dart';
import '../../../shared/models/app_enums.dart';
import '../../../shared/models/page_tutorial.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/page_frame.dart';
import '../../auth/application/auth_controller.dart';
import '../application/tasks_controller.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider);

    return PageFrame(
      title: 'Tarefas',
      subtitle: 'Prioridades, prazos e execução diária.',
      tutorial: const PageTutorialData(
        id: 'tasks',
        title: 'Como usar tarefas',
        description:
            'Use tarefas para transformar intenção em ação de curto prazo.',
        steps: [
          'Crie tarefas pequenas e específicas para o dia.',
          'Defina prioridade e prazo só quando isso ajudar na execução.',
          'Atualize o status para o dashboard refletir a realidade.',
        ],
      ),
      actions: [
        FilledButton.icon(
          onPressed: () => _showTaskDialog(context, ref),
          icon: const Icon(Icons.add_rounded),
          label: const Text('Nova tarefa'),
        ),
      ],
      child: AsyncValueView(
        value: tasksAsync,
        data: (tasks) {
          return ListView.separated(
            itemCount: tasks.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final task = tasks[index];
              return AppCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(task.title),
                  subtitle: Text(
                    '${task.priority.label} • ${task.status.label}',
                  ),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      IconButton(
                        onPressed: () =>
                            _showTaskDialog(context, ref, initial: task),
                        icon: const Icon(Icons.edit_outlined),
                      ),
                      IconButton(
                        onPressed: () =>
                            ref.read(taskActionsProvider).delete(task.id),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

Future<void> _showTaskDialog(
  BuildContext context,
  WidgetRef ref, {
  TaskEntity? initial,
}) async {
  final userId = ref.read(currentUserIdProvider);
  if (userId == null) return;

  final titleController = TextEditingController(text: initial?.title);
  final descriptionController = TextEditingController(
    text: initial?.description,
  );
  var priority = initial?.priority ?? TaskPriority.medium;
  var status = initial?.status ?? TaskStatus.pending;
  DateTime? dueDate = initial?.dueDate;
  final uuid = const Uuid();

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (dialogContext, setState) {
          final dialogWidth = responsiveDialogWidth(
            dialogContext,
            ideal: 460,
            min: 300,
          );
          return AlertDialog(
            title: Text(initial == null ? 'Nova tarefa' : 'Editar tarefa'),
            content: SizedBox(
              width: dialogWidth,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Título'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      minLines: 3,
                      maxLines: 4,
                      decoration: const InputDecoration(labelText: 'Descrição'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<TaskPriority>(
                      initialValue: priority,
                      decoration: const InputDecoration(labelText: 'Prioridade'),
                      items: TaskPriority.values
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(item.label),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(
                        () => priority = value ?? TaskPriority.medium,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<TaskStatus>(
                      initialValue: status,
                      decoration: const InputDecoration(labelText: 'Status'),
                      items: TaskStatus.values
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(item.label),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => status = value ?? TaskStatus.pending),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: dialogContext,
                          firstDate: DateTime.now().subtract(
                            const Duration(days: 30),
                          ),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                          initialDate: dueDate ?? DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() => dueDate = picked);
                        }
                      },
                      child: Text(
                        dueDate == null
                            ? 'Definir prazo'
                            : 'Prazo: ${dueDate!.day}/${dueDate!.month}/${dueDate!.year}',
                      ),
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
                  final now = DateTime.now().toUtc();
                  await ref
                      .read(taskActionsProvider)
                      .save(
                        TaskEntity(
                          id: initial?.id ?? uuid.v4(),
                          userId: userId,
                          trackId: initial?.trackId,
                          moduleId: initial?.moduleId,
                          title: titleController.text.trim(),
                          description: descriptionController.text.trim(),
                          priority: priority,
                          status: status,
                          dueDate: dueDate,
                          completedAt: status == TaskStatus.completed
                              ? now
                              : initial?.completedAt,
                          createdAt: initial?.createdAt ?? now,
                          updatedAt: now,
                        ),
                      );
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
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
