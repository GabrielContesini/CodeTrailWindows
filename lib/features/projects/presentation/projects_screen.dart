import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../../../core/router/app_router.dart';
import '../../../core/services/github_service.dart';
import '../../../core/services/service_providers.dart';
import '../../../core/utils/layout_utils.dart';
import '../../../domain/entities/app_entities.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/models/app_enums.dart';
import '../../../shared/models/app_view_models.dart';
import '../../../shared/models/page_tutorial.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/page_frame.dart';
import '../../auth/application/auth_controller.dart';
import '../application/projects_controller.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);

    return PageFrame(
      title: 'Projetos práticos',
      subtitle:
          'Transforme estudo em entrega real com etapas, escopo e links para GitHub.',
      tutorial: const PageTutorialData(
        id: 'projects',
        title: 'Como usar projetos',
        description:
            'Use esta área para tirar o estudo do plano e levá-lo para portfólio e entrega prática.',
        steps: [
          'Crie um projeto manual ou importe do GitHub.',
          'Vincule links para ter contexto rápido e fácil.',
          'Quebre em etapas pequenas e marque progresso ao concluir.',
        ],
      ),
      actions: [
        FilledButton.tonalIcon(
          onPressed: () => _showProjectDialog(
            context,
            ref,
            initialSource: ProjectCreationSource.github,
            existingProjects: projectsAsync.asData?.value ?? const [],
          ),
          icon: const Icon(Icons.sync_rounded),
          label: const Text('Sincronizar GitHub'),
        ),
        FilledButton.icon(
          onPressed: () => _showProjectDialog(
            context,
            ref,
            initialSource: ProjectCreationSource.manual,
            existingProjects: projectsAsync.asData?.value ?? const [],
          ),
          icon: const Icon(Icons.add_rounded),
          label: const Text('Novo projeto'),
        ),
      ],
      child: AsyncValueView(
        value: projectsAsync,
        data: (projects) {
          if (projects.isEmpty) {
            return const EmptyState(
              title: 'Nenhum projeto cadastrado',
              subtitle:
                  'Crie um projeto manualmente ou sincronize repositórios do GitHub para começar.',
            );
          }

          return _ProjectsGrid(projects: projects);
        },
      ),
    );
  }
}

class ProjectDetailsScreen extends ConsumerWidget {
  const ProjectDetailsScreen({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);

    return PageFrame(
      title: 'Detalhes do projeto',
      subtitle: 'Escopo, links e evolução prática em um espaço dedicado.',
      actions: [
        OutlinedButton.icon(
          onPressed: () => context.go(AppRoutes.projects),
          icon: const Icon(Icons.arrow_back_rounded),
          label: const Text('Voltar'),
        ),
      ],
      child: AsyncValueView(
        value: projectsAsync,
        data: (projects) {
          ProjectBundle? selected;
          for (final item in projects) {
            if (item.project.id == projectId) {
              selected = item;
              break;
            }
          }

          if (selected == null) {
            return const EmptyState(
              title: 'Projeto não encontrado',
              subtitle:
                  'Esse projeto não está mais disponível. Volte para a lista e escolha outro item.',
            );
          }

          return _ProjectDetailContent(
            bundle: selected,
            existingProjects: projects,
          );
        },
      ),
    );
  }
}

enum ProjectCreationSource { manual, github }

class _ProjectsGrid extends StatelessWidget {
  const _ProjectsGrid({required this.projects});

  final List<ProjectBundle> projects;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1360
            ? 3
            : constraints.maxWidth >= 920
            ? 2
            : 1;
        final spacing = 12.0;
        final cardWidth = columns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        final remainder = projects.length % columns;
        final lastRowCount = remainder == 0 ? columns : remainder;
        final lastRowWidth = lastRowCount == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - (spacing * (lastRowCount - 1))) /
                  lastRowCount;

        return ListView(
          children: [
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: projects.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isInLastRow =
                    index >= projects.length - lastRowCount && lastRowCount > 0;
                return SizedBox(
                  width: isInLastRow ? lastRowWidth : cardWidth,
                  child: _ProjectSummaryCard(bundle: item),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}

class _ProjectSummaryCard extends StatelessWidget {
  const _ProjectSummaryCard({required this.bundle});

  final ProjectBundle bundle;

  @override
  Widget build(BuildContext context) {
    final project = bundle.project;
    final githubProject = _isGitHubProject(project);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => context.go('${AppRoutes.projectDetails}/${project.id}'),
        child: AppCard(
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
                          project.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (githubProject) ...[
                          const SizedBox(height: 6),
                          Text(
                            'Importado do GitHub',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _ProjectStatusBadge(status: project.status),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                project.scope,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(value: project.progressPercent / 100),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${bundle.steps.where((step) => step.isDone).length}/${bundle.steps.length} etapas',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text('${project.progressPercent.toStringAsFixed(0)}%'),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.60),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectDetailContent extends ConsumerWidget {
  const _ProjectDetailContent({
    required this.bundle,
    required this.existingProjects,
  });

  final ProjectBundle bundle;
  final List<ProjectBundle> existingProjects;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = bundle.project;

    return AppCard(
      child: Scrollbar(
        child: ListView(
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.title,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 6),
                      Text(project.scope),
                    ],
                  ),
                ),
                _ProjectStatusBadge(status: project.status),
                if (project.repositoryUrl != null &&
                    project.repositoryUrl!.isNotEmpty)
                  FilledButton.tonalIcon(
                    onPressed: () => _openProjectUrl(
                      context,
                      project.repositoryUrl!,
                    ),
                    icon: const Icon(Icons.open_in_new_rounded),
                    label: Text(
                      _isGitHubProject(project)
                          ? 'Abrir no GitHub'
                          : 'Abrir link',
                    ),
                  ),
                FilledButton.tonalIcon(
                  onPressed: () => _showProjectDialog(
                    context,
                    ref,
                    initialSource: ProjectCreationSource.manual,
                    existingProjects: existingProjects,
                    initialProject: project,
                  ),
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Editar'),
                ),
                IconButton(
                  tooltip: 'Excluir projeto',
                  onPressed: () =>
                      _confirmDeleteProject(context, ref, project.id),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(project.description),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                if (project.repositoryUrl != null &&
                    project.repositoryUrl!.isNotEmpty)
                  _ProjectLinkChip(
                    label: _isGitHubProject(project)
                        ? 'Repositório GitHub'
                        : 'Repositório',
                    icon: Icons.code_rounded,
                    url: project.repositoryUrl!,
                  ),
                if (project.documentationUrl != null &&
                    project.documentationUrl!.isNotEmpty)
                  _ProjectLinkChip(
                    label: 'Documentação',
                    icon: Icons.menu_book_rounded,
                    url: project.documentationUrl!,
                  ),
                if (project.videoUrl != null && project.videoUrl!.isNotEmpty)
                  _ProjectLinkChip(
                    label: 'Vídeo',
                    icon: Icons.play_circle_outline_rounded,
                    url: project.videoUrl!,
                  ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Etapas',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: () => _showProjectStepDialog(
                    context,
                    ref,
                    project,
                    bundle.steps.length + 1,
                  ),
                  icon: const Icon(Icons.add_task_rounded),
                  label: const Text('Adicionar etapa'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (bundle.steps.isEmpty)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Theme.of(context).colorScheme.outline),
                ),
                child: const Text(
                  'Nenhuma etapa cadastrada ainda. Adicione pequenos marcos para deixar o progresso visível.',
                ),
              )
            else
              ...bundle.steps.map(
                (step) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ProjectStepTile(
                    project: project,
                    step: step,
                    sortOrder: bundle.steps.length + 1,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProjectStatusBadge extends StatelessWidget {
  const _ProjectStatusBadge({required this.status});

  final ProjectStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      ProjectStatus.planned => Theme.of(context).colorScheme.tertiary,
      ProjectStatus.active => Theme.of(context).colorScheme.primary,
      ProjectStatus.blocked => Theme.of(context).colorScheme.error,
      ProjectStatus.completed => Theme.of(context).colorScheme.secondary,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color.withValues(alpha: 0.12),
      ),
      child: Text(
        status.label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ProjectLinkChip extends StatelessWidget {
  const _ProjectLinkChip({
    required this.label,
    required this.icon,
    required this.url,
  });

  final String label;
  final IconData icon;
  final String url;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: () => _openProjectUrl(context, url),
    );
  }
}

class _ProjectStepTile extends ConsumerWidget {
  const _ProjectStepTile({
    required this.project,
    required this.step,
    required this.sortOrder,
  });

  final ProjectEntity project;
  final ProjectStepEntity step;
  final int sortOrder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.28),
      ),
      child: Column(
        children: [
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: step.isDone,
            title: Text(step.title),
            subtitle: Text(step.description),
            onChanged: (value) async {
              await ref
                  .read(projectActionsProvider)
                  .saveStep(
                    step.copyWith(
                      isDone: value ?? false,
                      completedAt: value == true ? DateTime.now().toUtc() : null,
                      updatedAt: DateTime.now().toUtc(),
                    ),
                  );
            },
          ),
          Row(
            children: [
              FilledButton.tonalIcon(
                onPressed: () => _showProjectStepDialog(
                  context,
                  ref,
                  project,
                  sortOrder,
                  initialStep: step,
                ),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Editar'),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () => _confirmDeleteStep(context, ref, step),
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Excluir'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SourceSelectionCard extends StatelessWidget {
  const _SourceSelectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
          ),
          color: selected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
              : Colors.transparent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(subtitle),
          ],
        ),
      ),
    );
  }
}

class _ProjectCreationDialog extends ConsumerStatefulWidget {
  const _ProjectCreationDialog({
    required this.initialSource,
    required this.existingProjects,
    this.initialProject,
  });

  final ProjectCreationSource initialSource;
  final List<ProjectBundle> existingProjects;
  final ProjectEntity? initialProject;

  @override
  ConsumerState<_ProjectCreationDialog> createState() =>
      _ProjectCreationDialogState();
}

class _ProjectCreationDialogState
    extends ConsumerState<_ProjectCreationDialog> {
  final _uuid = const Uuid();
  final _titleController = TextEditingController();
  final _scopeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _repositoryController = TextEditingController();
  final _documentationController = TextEditingController();
  final _videoController = TextEditingController();
  final _githubTokenController = TextEditingController();
  final _searchController = TextEditingController();

  late ProjectCreationSource _source;
  ProjectStatus _status = ProjectStatus.active;
  bool _loadingRepos = false;
  bool _saving = false;
  bool _obscureToken = true;
  String? _githubError;
  List<GitHubRepositorySummary> _repos = const [];
  final Set<int> _selectedRepoIds = <int>{};

  @override
  void initState() {
    super.initState();
    _source = widget.initialProject == null
        ? widget.initialSource
        : ProjectCreationSource.manual;
    _status = widget.initialProject?.status ?? ProjectStatus.active;
    _titleController.text = widget.initialProject?.title ?? '';
    _scopeController.text = widget.initialProject?.scope ?? '';
    _descriptionController.text = widget.initialProject?.description ?? '';
    _repositoryController.text = widget.initialProject?.repositoryUrl ?? '';
    _documentationController.text =
        widget.initialProject?.documentationUrl ?? '';
    _videoController.text = widget.initialProject?.videoUrl ?? '';
    Future.microtask(_loadSavedToken);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _scopeController.dispose();
    _descriptionController.dispose();
    _repositoryController.dispose();
    _documentationController.dispose();
    _videoController.dispose();
    _githubTokenController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedToken() async {
    final token = await ref.read(githubServiceProvider).readToken();
    if (!mounted || token == null || token.isEmpty) {
      return;
    }

    _githubTokenController.text = token;
    if (_source == ProjectCreationSource.github) {
      await _fetchRepositories();
    }
  }

  Future<void> _fetchRepositories() async {
    setState(() {
      _loadingRepos = true;
      _githubError = null;
    });

    try {
      final repos = await ref
          .read(githubServiceProvider)
          .fetchRepositories(token: _githubTokenController.text.trim());
      if (!mounted) {
        return;
      }
      setState(() => _repos = repos);
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() => _githubError = error.toString());
    } finally {
      if (mounted) {
        setState(() => _loadingRepos = false);
      }
    }
  }

  Future<void> _saveManualProject() async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) {
      return;
    }

    setState(() => _saving = true);
    final now = DateTime.now().toUtc();
    try {
      final initial = widget.initialProject;
      await ref
          .read(projectActionsProvider)
          .saveProject(
            ProjectEntity(
              id: initial?.id ?? _uuid.v4(),
              userId: userId,
              trackId: initial?.trackId,
              title: _titleController.text.trim(),
              scope: _scopeController.text.trim(),
              description: _descriptionController.text.trim(),
              repositoryUrl: _normalizeUrl(_repositoryController.text),
              documentationUrl: _normalizeUrl(_documentationController.text),
              videoUrl: _normalizeUrl(_videoController.text),
              status: _status,
              progressPercent: initial?.progressPercent ?? 0,
              createdAt: initial?.createdAt ?? now,
              updatedAt: now,
            ),
          );
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<void> _importSelectedRepositories() async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) {
      return;
    }

    final selectedRepos = _filteredRepos
        .where((repo) => _selectedRepoIds.contains(repo.id))
        .toList();
    if (selectedRepos.isEmpty) {
      setState(() {
        _githubError = 'Selecione pelo menos um repositório para importar.';
      });
      return;
    }

    final existingByUrl = <String, ProjectEntity>{
      for (final item in widget.existingProjects)
        if (item.project.repositoryUrl != null &&
            item.project.repositoryUrl!.isNotEmpty)
          item.project.repositoryUrl!: item.project,
    };

    setState(() {
      _saving = true;
      _githubError = null;
    });

    try {
      final now = DateTime.now().toUtc();
      final projects = selectedRepos.map((repo) {
        final existing = existingByUrl[repo.htmlUrl];
        return ProjectEntity(
          id: existing?.id ?? _uuid.v4(),
          userId: userId,
          trackId: existing?.trackId,
          title: repo.name,
          scope: 'GitHub • ${repo.fullName}',
          description: repo.description.isEmpty
              ? 'Repositório importado do GitHub.'
              : repo.description,
          repositoryUrl: repo.htmlUrl,
          documentationUrl: repo.homepageUrl,
          videoUrl: existing?.videoUrl,
          status: existing?.status ?? ProjectStatus.active,
          progressPercent: existing?.progressPercent ?? 0,
          createdAt: existing?.createdAt ?? now,
          updatedAt: now,
        );
      }).toList();

      await ref.read(projectActionsProvider).saveProjects(projects);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  List<GitHubRepositorySummary> get _filteredRepos {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      return _repos;
    }
    return _repos.where((repo) {
      return repo.name.toLowerCase().contains(query) ||
          repo.fullName.toLowerCase().contains(query) ||
          repo.description.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final dialogWidth = responsiveDialogWidth(
      context,
      ideal: 760,
      min: 360,
      horizontalMargin: 120,
    );

    return AlertDialog(
      title: Text(
        widget.initialProject == null ? 'Novo projeto' : 'Editar projeto',
      ),
      content: SizedBox(
        width: dialogWidth,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.initialProject == null) ...[
                Text(
                  'Escolha como deseja criar o projeto',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 620;
                    final githubCard = _SourceSelectionCard(
                      title: 'Importar do GitHub',
                      subtitle:
                          'Use seu token pessoal, carregue os repositórios e importe os que quiser.',
                      icon: Icons.code_rounded,
                      selected: _source == ProjectCreationSource.github,
                      onTap: () => setState(
                        () => _source = ProjectCreationSource.github,
                      ),
                    );
                    final manualCard = _SourceSelectionCard(
                      title: 'Criar manualmente',
                      subtitle:
                          'Cadastre um projeto direto na plataforma com links opcionais.',
                      icon: Icons.edit_note_rounded,
                      selected: _source == ProjectCreationSource.manual,
                      onTap: () => setState(
                        () => _source = ProjectCreationSource.manual,
                      ),
                    );
                    if (compact) {
                      return Column(
                        children: [
                          githubCard,
                          const SizedBox(height: 12),
                          manualCard,
                        ],
                      );
                    }
                    return Row(
                      children: [
                        Expanded(child: githubCard),
                        const SizedBox(width: 12),
                        Expanded(child: manualCard),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 18),
              ],
              if (_source == ProjectCreationSource.manual)
                _buildManualFields()
              else
                _buildGitHubFields(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _saving
              ? null
              : _source == ProjectCreationSource.manual
              ? _saveManualProject
              : _importSelectedRepositories,
          child: Text(
            _saving
                ? 'Salvando...'
                : _source == ProjectCreationSource.manual
                ? widget.initialProject == null
                      ? 'Salvar projeto'
                      : 'Salvar alterações'
                : 'Importar selecionados',
          ),
        ),
      ],
    );
  }

  Widget _buildManualFields() {
    return Column(
      children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(labelText: 'Título'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _scopeController,
          decoration: const InputDecoration(labelText: 'Escopo resumido'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _descriptionController,
          minLines: 3,
          maxLines: 4,
          decoration: const InputDecoration(labelText: 'Descrição'),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<ProjectStatus>(
          initialValue: _status,
          decoration: const InputDecoration(labelText: 'Status'),
          items: ProjectStatus.values
              .map(
                (item) =>
                    DropdownMenuItem(value: item, child: Text(item.label)),
              )
              .toList(),
          onChanged: (value) =>
              setState(() => _status = value ?? ProjectStatus.active),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _repositoryController,
          decoration: const InputDecoration(labelText: 'Link do GitHub'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _documentationController,
          decoration: const InputDecoration(labelText: 'Link de documentação'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _videoController,
          decoration: const InputDecoration(labelText: 'Link de vídeo'),
        ),
      ],
    );
  }

  Widget _buildGitHubFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _githubTokenController,
          obscureText: _obscureToken,
          decoration: InputDecoration(
            labelText: 'Token pessoal do GitHub',
            hintText: 'ghp_...',
            suffixIcon: IconButton(
              onPressed: () => setState(() => _obscureToken = !_obscureToken),
              icon: Icon(
                _obscureToken
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            FilledButton.tonalIcon(
              onPressed: _loadingRepos ? null : _fetchRepositories,
              icon: const Icon(Icons.sync_rounded),
              label: Text(
                _loadingRepos ? 'Sincronizando...' : 'Buscar repositórios',
              ),
            ),
            const SizedBox(width: 12),
            TextButton(
              onPressed: () async {
                await ref.read(githubServiceProvider).clearToken();
                if (!mounted) {
                  return;
                }
                setState(() {
                  _githubTokenController.clear();
                  _repos = const [];
                  _selectedRepoIds.clear();
                });
              },
              child: const Text('Limpar token'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _searchController,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            labelText: 'Filtrar repositórios',
            prefixIcon: Icon(Icons.search_rounded),
          ),
        ),
        const SizedBox(height: 12),
        if (_githubError != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              _githubError!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        Container(
          constraints: const BoxConstraints(maxHeight: 340),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Theme.of(context).colorScheme.outline),
          ),
          child: _loadingRepos
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                )
              : _repos.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Nenhum repositório carregado ainda. Informe o token e sincronize.',
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: _filteredRepos.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final repo = _filteredRepos[index];
                    final selected = _selectedRepoIds.contains(repo.id);
                    return CheckboxListTile(
                      value: selected,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _selectedRepoIds.add(repo.id);
                          } else {
                            _selectedRepoIds.remove(repo.id);
                          }
                        });
                      },
                      title: Text(repo.fullName),
                      subtitle: Text(
                        repo.description.isEmpty
                            ? 'Sem descrição'
                            : repo.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      secondary: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            repo.isPrivate
                                ? Icons.lock_outline_rounded
                                : Icons.public_rounded,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            repo.language ?? 'N/A',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

Future<void> _showProjectDialog(
  BuildContext context,
  WidgetRef ref, {
  required ProjectCreationSource initialSource,
  required List<ProjectBundle> existingProjects,
  ProjectEntity? initialProject,
}) async {
  await showDialog<bool>(
    context: context,
    builder: (_) => _ProjectCreationDialog(
      initialSource: initialSource,
      existingProjects: existingProjects,
      initialProject: initialProject,
    ),
  );
}

Future<void> _showProjectStepDialog(
  BuildContext context,
  WidgetRef ref,
  ProjectEntity project,
  int sortOrder,
  {ProjectStepEntity? initialStep,}
) async {
  final titleController = TextEditingController(text: initialStep?.title ?? '');
  final descriptionController = TextEditingController(
    text: initialStep?.description ?? '',
  );
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
        title: Text(initialStep == null ? 'Adicionar etapa' : 'Editar etapa'),
        content: SizedBox(
          width: dialogWidth,
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
                decoration: const InputDecoration(labelText: 'Descrição'),
                minLines: 2,
                maxLines: 3,
              ),
            ],
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
              final title = titleController.text.trim();
              final description = descriptionController.text.trim();
              if (title.isEmpty || description.isEmpty) {
                dialogContext.showAppSnackBar(
                  'Preencha título e descrição da etapa.',
                );
                return;
              }
              await ref
                  .read(projectActionsProvider)
                  .saveStep(
                    ProjectStepEntity(
                      id: initialStep?.id ?? uuid.v4(),
                      projectId: project.id,
                      title: title,
                      description: description,
                      isDone: initialStep?.isDone ?? false,
                      sortOrder: initialStep?.sortOrder ?? sortOrder,
                      completedAt: initialStep?.completedAt,
                      createdAt: initialStep?.createdAt ?? now,
                      updatedAt: now,
                    ),
                  );
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
              }
            },
            child: Text(initialStep == null ? 'Adicionar' : 'Salvar'),
          ),
        ],
      );
    },
  );
}

Future<void> _confirmDeleteProject(
  BuildContext context,
  WidgetRef ref,
  String projectId,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Excluir projeto'),
        content: const Text(
          'Isso removerá o projeto e todas as etapas vinculadas.',
        ),
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

  await ref.read(projectActionsProvider).deleteProject(projectId);
  if (context.mounted) {
    context.go(AppRoutes.projects);
  }
}

Future<void> _confirmDeleteStep(
  BuildContext context,
  WidgetRef ref,
  ProjectStepEntity step,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Excluir etapa'),
        content: Text('Remover a etapa "${step.title}"?'),
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

  await ref.read(projectActionsProvider).deleteStep(step.id);
  if (context.mounted) {
    context.showAppSnackBar('Etapa removida.');
  }
}

Future<void> _openProjectUrl(BuildContext context, String rawUrl) async {
  final normalized = _normalizeUrl(rawUrl);
  if (normalized == null) {
    context.showAppSnackBar('Link inválido.');
    return;
  }

  final uri = Uri.tryParse(normalized);
  if (uri == null ||
      !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    await Clipboard.setData(ClipboardData(text: normalized));
    if (context.mounted) {
      context.showAppSnackBar(
        'Não foi possível abrir o link. URL copiada para a área de transferência.',
      );
    }
  }
}

bool _isGitHubProject(ProjectEntity project) {
  return (project.repositoryUrl?.contains('github.com') ?? false) &&
      project.scope.startsWith('GitHub');
}

String? _normalizeUrl(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return null;
  }
  if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
    return trimmed;
  }
  return 'https://$trimmed';
}
