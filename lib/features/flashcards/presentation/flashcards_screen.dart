import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

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
import '../../projects/application/projects_controller.dart';
import '../../tracks/application/tracks_controller.dart';
import '../application/flashcards_controller.dart';

class FlashcardsScreen extends ConsumerStatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  ConsumerState<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends ConsumerState<FlashcardsScreen> {
  String _selectedDeck = 'Todas';
  String? _selectedCardId;
  String _searchQuery = '';
  bool _showAnswer = false;

  @override
  Widget build(BuildContext context) {
    final flashcardsAsync = ref.watch(flashcardsProvider);
    final trackBlueprints =
        ref.watch(trackBlueprintsProvider).asData?.value ??
        const <TrackBlueprint>[];
    final projectBundles =
        ref.watch(projectsProvider).asData?.value ?? const <ProjectBundle>[];

    return PageFrame(
      title: 'Flashcards',
      subtitle:
          'Crie decks por tema, revise com repetição espaçada e mantenha a memória de trabalho sempre ativa.',
      tutorial: const PageTutorialData(
        id: 'flashcards',
        title: 'Como usar flashcards',
        description:
            'Abra o card, revele a resposta e escolha o nível de lembrança para reagendar a próxima revisão.',
        steps: [
          'Separe decks por stack, módulo, projeto ou sprint.',
          'Use Errei, Difícil, Bom e Fácil para ajustar a próxima aparição.',
          'Mantenha a fila do dia curta e priorize o que já venceu.',
        ],
      ),
      actions: [
        FilledButton.icon(
          onPressed: () => _showFlashcardDialog(
            context,
            ref,
            trackBlueprints: trackBlueprints,
            projectBundles: projectBundles,
            initialDeck: _selectedDeck == 'Todas' ? 'Geral' : _selectedDeck,
          ),
          icon: const Icon(Icons.add_card_rounded),
          label: const Text('Novo card'),
        ),
      ],
      child: AsyncValueView(
        value: flashcardsAsync,
        loadingMessage: 'Preparando decks e fila de revisão...',
        data: (flashcards) {
          final trackNameById = {
            for (final item in trackBlueprints) item.track.id: item.track.name,
          };
          final moduleNameById = {
            for (final item in trackBlueprints)
              for (final module in item.modules) module.id: module.title,
          };
          final projectNameById = {
            for (final item in projectBundles)
              item.project.id: item.project.title,
          };

          if (flashcards.isEmpty) {
            return EmptyState(
              title: 'Nenhum flashcard criado ainda',
              subtitle:
                  'Monte um primeiro deck curto para revisar conceitos, comandos ou perguntas técnicas da sua trilha.',
              action: FilledButton.icon(
                onPressed: () => _showFlashcardDialog(
                  context,
                  ref,
                  trackBlueprints: trackBlueprints,
                  projectBundles: projectBundles,
                  initialDeck: 'Geral',
                ),
                icon: const Icon(Icons.add_card_rounded),
                label: const Text('Criar primeiro card'),
              ),
            );
          }

          final decks = <String>{
            'Geral',
            ...flashcards.map((item) => _normalizedDeckName(item.deckName)),
          }..removeWhere((item) => item.trim().isEmpty);
          final deckOptions = ['Todas', ...(decks.toList()..sort())];
          if (!deckOptions.contains(_selectedDeck)) {
            _selectedDeck = 'Todas';
          }

          final localNow = DateTime.now();
          final endOfToday = DateTime(
            localNow.year,
            localNow.month,
            localNow.day,
            23,
            59,
            59,
            999,
          );
          final normalizedQuery = _searchQuery.trim().toLowerCase();
          final deckFiltered = _selectedDeck == 'Todas'
              ? flashcards
              : flashcards
                    .where(
                      (item) =>
                          _normalizedDeckName(item.deckName) == _selectedDeck,
                    )
                    .toList();
          final filteredCards = normalizedQuery.isEmpty
              ? deckFiltered
              : deckFiltered.where((card) {
                  final haystack =
                      '${card.deckName} ${card.question} ${card.answer}'
                          .toLowerCase();
                  return haystack.contains(normalizedQuery);
                }).toList();
          final dueNowCards = filteredCards
              .where((item) => !_toLocal(item.dueAt).isAfter(localNow))
              .toList();
          final dueTodayCount = flashcards
              .where((item) => !_toLocal(item.dueAt).isAfter(endOfToday))
              .length;
          final reviewedCount = flashcards
              .where((item) => item.reviewCount > 0)
              .length;
          final masteredCount = flashcards
              .where(
                (item) => item.correctStreak >= 3 || item.intervalDays >= 15,
              )
              .length;

          if (filteredCards.isEmpty) {
            _selectedCardId = null;
          } else {
            _selectedCardId ??= dueNowCards.isNotEmpty
                ? dueNowCards.first.id
                : filteredCards.first.id;
            if (filteredCards.every((item) => item.id != _selectedCardId)) {
              _selectedCardId = dueNowCards.isNotEmpty
                  ? dueNowCards.first.id
                  : filteredCards.first.id;
              _showAnswer = false;
            }
          }

          FlashcardEntity? selectedCard;
          for (final card in filteredCards) {
            if (card.id == _selectedCardId) {
              selectedCard = card;
              break;
            }
          }

          final summary = [
            _SummaryMetricData(
              label: 'Na fila agora',
              value: '${dueNowCards.length}',
              helper: dueNowCards.isEmpty ? 'Tudo em dia' : 'Cards vencidos',
              icon: Icons.bolt_rounded,
            ),
            _SummaryMetricData(
              label: 'Até hoje',
              value: '$dueTodayCount',
              helper: 'Liberados até o fim do dia',
              icon: Icons.today_rounded,
            ),
            _SummaryMetricData(
              label: 'Já revisados',
              value: '$reviewedCount',
              helper: 'Biblioteca em movimento',
              icon: Icons.history_toggle_off_rounded,
            ),
            _SummaryMetricData(
              label: 'Retenção forte',
              value: '$masteredCount',
              helper: 'Streak alta ou intervalo longo',
              icon: Icons.workspace_premium_rounded,
            ),
          ];

          return LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 1460;

              if (!wide) {
                return ListView(
                  children: [
                    Wrap(
                      spacing: 14,
                      runSpacing: 14,
                      children: summary
                          .map(
                            (item) => SizedBox(
                              width: constraints.maxWidth >= 760
                                  ? (constraints.maxWidth - 14) / 2
                                  : constraints.maxWidth,
                              child: _SummaryMetricCard(data: item),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    _StudyPanel(
                      card: selectedCard,
                      showAnswer: _showAnswer,
                      dueNow: selectedCard == null
                          ? false
                          : !_toLocal(selectedCard.dueAt).isAfter(localNow),
                      trackNameById: trackNameById,
                      moduleNameById: moduleNameById,
                      projectNameById: projectNameById,
                      onToggleAnswer: selectedCard == null
                          ? null
                          : () => setState(() => _showAnswer = !_showAnswer),
                      onRevealAnswer: selectedCard == null
                          ? null
                          : () => setState(() => _showAnswer = true),
                      onEdit: selectedCard == null
                          ? null
                          : () => _showFlashcardDialog(
                              context,
                              ref,
                              trackBlueprints: trackBlueprints,
                              projectBundles: projectBundles,
                              card: selectedCard,
                            ),
                      onReview: selectedCard == null
                          ? null
                          : (grade) => _handleReview(selectedCard!, grade),
                    ),
                    const SizedBox(height: 16),
                    _DeckRail(
                      compact: true,
                      deckOptions: deckOptions,
                      selectedDeck: _selectedDeck,
                      dueNowCards: dueNowCards,
                      onSelectDeck: (value) {
                        setState(() {
                          _selectedDeck = value;
                          _selectedCardId = null;
                          _showAnswer = false;
                        });
                      },
                      onSelectCard: (card) {
                        setState(() {
                          _selectedCardId = card.id;
                          _showAnswer = false;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _LibraryPanel(
                      compact: true,
                      cards: filteredCards,
                      selectedCardId: _selectedCardId,
                      searchQuery: _searchQuery,
                      trackNameById: trackNameById,
                      moduleNameById: moduleNameById,
                      projectNameById: projectNameById,
                      onSearchChanged: (value) =>
                          setState(() => _searchQuery = value),
                      onSelectCard: (card) {
                        setState(() {
                          _selectedCardId = card.id;
                          _showAnswer = false;
                        });
                      },
                      onEditCard: (card) => _showFlashcardDialog(
                        context,
                        ref,
                        trackBlueprints: trackBlueprints,
                        projectBundles: projectBundles,
                        card: card,
                      ),
                      onDeleteCard: _confirmDelete,
                    ),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 320,
                    child: _DeckRail(
                      compact: false,
                      deckOptions: deckOptions,
                      selectedDeck: _selectedDeck,
                      dueNowCards: dueNowCards,
                      onSelectDeck: (value) {
                        setState(() {
                          _selectedDeck = value;
                          _selectedCardId = null;
                          _showAnswer = false;
                        });
                      },
                      onSelectCard: (card) {
                        setState(() {
                          _selectedCardId = card.id;
                          _showAnswer = false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 136,
                          child: Row(
                            children: [
                              for (
                                var index = 0;
                                index < summary.length;
                                index++
                              )
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right: index == summary.length - 1
                                          ? 0
                                          : 12,
                                    ),
                                    child: _SummaryMetricCard(
                                      data: summary[index],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Expanded(
                          child: _StudyPanel(
                            card: selectedCard,
                            showAnswer: _showAnswer,
                            dueNow: selectedCard == null
                                ? false
                                : !_toLocal(
                                    selectedCard.dueAt,
                                  ).isAfter(localNow),
                            trackNameById: trackNameById,
                            moduleNameById: moduleNameById,
                            projectNameById: projectNameById,
                            onToggleAnswer: selectedCard == null
                                ? null
                                : () => setState(
                                    () => _showAnswer = !_showAnswer,
                                  ),
                            onRevealAnswer: selectedCard == null
                                ? null
                                : () => setState(() => _showAnswer = true),
                            onEdit: selectedCard == null
                                ? null
                                : () => _showFlashcardDialog(
                                    context,
                                    ref,
                                    trackBlueprints: trackBlueprints,
                                    projectBundles: projectBundles,
                                    card: selectedCard,
                                  ),
                            onReview: selectedCard == null
                                ? null
                                : (grade) =>
                                      _handleReview(selectedCard!, grade),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 18),
                  SizedBox(
                    width: 430,
                    child: _LibraryPanel(
                      compact: false,
                      cards: filteredCards,
                      selectedCardId: _selectedCardId,
                      searchQuery: _searchQuery,
                      trackNameById: trackNameById,
                      moduleNameById: moduleNameById,
                      projectNameById: projectNameById,
                      onSearchChanged: (value) =>
                          setState(() => _searchQuery = value),
                      onSelectCard: (card) {
                        setState(() {
                          _selectedCardId = card.id;
                          _showAnswer = false;
                        });
                      },
                      onEditCard: (card) => _showFlashcardDialog(
                        context,
                        ref,
                        trackBlueprints: trackBlueprints,
                        projectBundles: projectBundles,
                        card: card,
                      ),
                      onDeleteCard: _confirmDelete,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _handleReview(
    FlashcardEntity card,
    FlashcardReviewGrade grade,
  ) async {
    final updated = await ref
        .read(flashcardActionsProvider)
        .review(card, grade);
    if (!mounted) return;

    setState(() {
      _selectedCardId = null;
      _showAnswer = false;
    });
    context.showAppSnackBar(
      'Próxima revisão ${_formatNextReview(updated.dueAt)}.',
    );
  }

  Future<void> _confirmDelete(FlashcardEntity card) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Remover flashcard'),
          content: Text(
            'Excluir o card "${card.question.trim()}" da biblioteca?',
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

    if (shouldDelete != true) return;

    await ref.read(flashcardActionsProvider).delete(card.id);
    if (!mounted) return;

    setState(() {
      if (_selectedCardId == card.id) {
        _selectedCardId = null;
        _showAnswer = false;
      }
    });
    context.showAppSnackBar('Flashcard removido.');
  }
}

class _SummaryMetricData {
  const _SummaryMetricData({
    required this.label,
    required this.value,
    required this.helper,
    required this.icon,
  });

  final String label;
  final String value;
  final String helper;
  final IconData icon;
}

class _SummaryMetricCard extends StatelessWidget {
  const _SummaryMetricCard({required this.data});

  final _SummaryMetricData data;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: context.colorScheme.primary.withValues(alpha: 0.12),
            ),
            child: Icon(data.icon, color: context.colorScheme.primary),
          ),
          const SizedBox(height: 16),
          Text(
            data.value,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            data.label,
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.helper,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeckRail extends StatelessWidget {
  const _DeckRail({
    required this.compact,
    required this.deckOptions,
    required this.selectedDeck,
    required this.dueNowCards,
    required this.onSelectDeck,
    required this.onSelectCard,
  });

  final bool compact;
  final List<String> deckOptions;
  final String selectedDeck;
  final List<FlashcardEntity> dueNowCards;
  final ValueChanged<String> onSelectDeck;
  final ValueChanged<FlashcardEntity> onSelectCard;

  @override
  Widget build(BuildContext context) {
    final queue = compact ? dueNowCards.take(6).toList() : dueNowCards;
    final queueView = queue.isEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              'Nenhum card vencido neste filtro. Você pode adiantar um card da biblioteca.',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.72),
              ),
            ),
          )
        : ListView.separated(
            shrinkWrap: compact,
            physics: compact
                ? const NeverScrollableScrollPhysics()
                : const AlwaysScrollableScrollPhysics(),
            itemCount: queue.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final card = queue[index];
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => onSelectCard(card),
                  child: Ink(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: context.colorScheme.outline.withValues(
                          alpha: 0.78,
                        ),
                      ),
                      color: context.colorScheme.errorContainer.withValues(
                        alpha: 0.22,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.question,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _normalizedDeckName(card.deckName),
                          style: context.textTheme.labelMedium?.copyWith(
                            color: context.colorScheme.error,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Decks e fila',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Troque o foco por deck e puxe primeiro o que já venceu.',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: deckOptions.map((deck) {
              return ChoiceChip(
                label: Text(deck),
                selected: deck == selectedDeck,
                onSelected: (_) => onSelectDeck(deck),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Text(
            'Vencendo agora',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          if (compact) queueView else Expanded(child: queueView),
        ],
      ),
    );
  }
}

class _StudyPanel extends StatelessWidget {
  const _StudyPanel({
    required this.card,
    required this.showAnswer,
    required this.dueNow,
    required this.trackNameById,
    required this.moduleNameById,
    required this.projectNameById,
    required this.onToggleAnswer,
    required this.onRevealAnswer,
    required this.onEdit,
    required this.onReview,
  });

  final FlashcardEntity? card;
  final bool showAnswer;
  final bool dueNow;
  final Map<String, String> trackNameById;
  final Map<String, String> moduleNameById;
  final Map<String, String> projectNameById;
  final VoidCallback? onToggleAnswer;
  final VoidCallback? onRevealAnswer;
  final VoidCallback? onEdit;
  final ValueChanged<FlashcardReviewGrade>? onReview;

  @override
  Widget build(BuildContext context) {
    if (card == null) {
      return const AppCard(
        child: EmptyState(
          title: 'Nenhum card neste filtro',
          subtitle:
              'Troque de deck ou ajuste a busca para retomar a sessão de revisão.',
        ),
      );
    }

    final labels = _contextLabels(
      card!,
      trackNameById: trackNameById,
      moduleNameById: moduleNameById,
      projectNameById: projectNameById,
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _PillLabel(
                label: _normalizedDeckName(card!.deckName),
                icon: Icons.style_rounded,
              ),
              _PillLabel(
                label: dueNow
                    ? 'Disponível agora'
                    : 'Próxima revisão ${_formatNextReview(card!.dueAt)}',
                icon: dueNow ? Icons.bolt_rounded : Icons.schedule_rounded,
              ),
              _PillLabel(
                label:
                    '${card!.reviewCount} revisão(ões) • intervalo ${card!.intervalDays}d',
                icon: Icons.timelapse_rounded,
              ),
            ],
          ),
          if (labels.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: labels
                  .map((label) => _ContextBadge(label: label))
                  .toList(),
            ),
          ],
          const SizedBox(height: 18),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(28),
                onTap: onToggleAnswer,
                child: Ink(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: LinearGradient(
                      colors: [
                        context.colorScheme.primary.withValues(alpha: 0.16),
                        context.colorScheme.surface.withValues(alpha: 0.38),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: context.colorScheme.outline.withValues(
                        alpha: 0.82,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          showAnswer ? 'Resposta' : 'Pergunta',
                          style: context.textTheme.labelLarge?.copyWith(
                            color: context.colorScheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: Center(
                            child: SingleChildScrollView(
                              child: Text(
                                showAnswer ? card!.answer : card!.question,
                                textAlign: TextAlign.center,
                                style: context.textTheme.headlineSmall
                                    ?.copyWith(
                                      height: 1.3,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          showAnswer
                              ? 'Clique no card para voltar à frente.'
                              : 'Clique para revelar a resposta.',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurface.withValues(
                              alpha: 0.70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              if (!showAnswer)
                FilledButton.icon(
                  onPressed: onRevealAnswer,
                  icon: const Icon(Icons.visibility_outlined),
                  label: const Text('Revelar resposta'),
                ),
              if (showAnswer)
                for (final grade in FlashcardReviewGrade.values)
                  _ReviewGradeButton(
                    grade: grade,
                    onPressed: onReview == null ? null : () => onReview!(grade),
                  ),
              OutlinedButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Editar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReviewGradeButton extends StatelessWidget {
  const _ReviewGradeButton({required this.grade, required this.onPressed});

  final FlashcardReviewGrade grade;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (grade) {
      FlashcardReviewGrade.again => (
        context.colorScheme.errorContainer.withValues(alpha: 0.84),
        context.colorScheme.onErrorContainer,
      ),
      FlashcardReviewGrade.hard => (
        Colors.orange.withValues(alpha: 0.18),
        Colors.orange.shade800,
      ),
      FlashcardReviewGrade.good => (
        Colors.green.withValues(alpha: 0.18),
        Colors.green.shade800,
      ),
      FlashcardReviewGrade.easy => (
        Colors.teal.withValues(alpha: 0.18),
        Colors.teal.shade800,
      ),
    };

    return FilledButton.tonal(
      style: FilledButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
      ),
      onPressed: onPressed,
      child: Text(grade.label),
    );
  }
}

class _LibraryPanel extends StatelessWidget {
  const _LibraryPanel({
    required this.compact,
    required this.cards,
    required this.selectedCardId,
    required this.searchQuery,
    required this.trackNameById,
    required this.moduleNameById,
    required this.projectNameById,
    required this.onSearchChanged,
    required this.onSelectCard,
    required this.onEditCard,
    required this.onDeleteCard,
  });

  final bool compact;
  final List<FlashcardEntity> cards;
  final String? selectedCardId;
  final String searchQuery;
  final Map<String, String> trackNameById;
  final Map<String, String> moduleNameById;
  final Map<String, String> projectNameById;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<FlashcardEntity> onSelectCard;
  final ValueChanged<FlashcardEntity> onEditCard;
  final ValueChanged<FlashcardEntity> onDeleteCard;

  @override
  Widget build(BuildContext context) {
    final listView = cards.isEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 18),
            child: Text(
              'Nenhum flashcard encontrado com esse filtro.',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.72),
              ),
            ),
          )
        : ListView.separated(
            shrinkWrap: compact,
            physics: compact
                ? const NeverScrollableScrollPhysics()
                : const AlwaysScrollableScrollPhysics(),
            itemCount: cards.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final card = cards[index];
              return _FlashcardListTile(
                card: card,
                selected: card.id == selectedCardId,
                trackNameById: trackNameById,
                moduleNameById: moduleNameById,
                projectNameById: projectNameById,
                onTap: () => onSelectCard(card),
                onEdit: () => onEditCard(card),
                onDelete: () => onDeleteCard(card),
              );
            },
          );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Biblioteca',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${cards.length} card(s) visível(is) no filtro atual.',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: searchQuery,
            onChanged: onSearchChanged,
            decoration: const InputDecoration(
              labelText: 'Buscar na biblioteca',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          const SizedBox(height: 18),
          if (compact) listView else Expanded(child: listView),
        ],
      ),
    );
  }
}

class _FlashcardListTile extends StatelessWidget {
  const _FlashcardListTile({
    required this.card,
    required this.selected,
    required this.trackNameById,
    required this.moduleNameById,
    required this.projectNameById,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final FlashcardEntity card;
  final bool selected;
  final Map<String, String> trackNameById;
  final Map<String, String> moduleNameById;
  final Map<String, String> projectNameById;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final contextLabels = _contextLabels(
      card,
      trackNameById: trackNameById,
      moduleNameById: moduleNameById,
      projectNameById: projectNameById,
    );
    final localDue = _toLocal(card.dueAt);
    final dueNow = !localDue.isAfter(DateTime.now());

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: selected
                  ? context.colorScheme.primary
                  : context.colorScheme.outline.withValues(alpha: 0.78),
            ),
            color: selected
                ? context.colorScheme.primary.withValues(alpha: 0.10)
                : context.colorScheme.surface.withValues(alpha: 0.18),
          ),
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
                          card.question,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${_normalizedDeckName(card.deckName)} • ${dueNow ? 'Disponível agora' : DateFormat('dd/MM • HH:mm').format(localDue)}',
                          style: context.textTheme.labelMedium?.copyWith(
                            color: dueNow
                                ? context.colorScheme.primary
                                : context.colorScheme.onSurface.withValues(
                                    alpha: 0.72,
                                  ),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined, size: 20),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline_rounded, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                card.answer,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodyMedium?.copyWith(height: 1.45),
              ),
              if (contextLabels.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: contextLabels
                      .map((label) => _ContextBadge(label: label))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PillLabel extends StatelessWidget {
  const _PillLabel({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: context.colorScheme.primary.withValues(alpha: 0.10),
        border: Border.all(
          color: context.colorScheme.primary.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: context.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: context.textTheme.labelMedium?.copyWith(
              color: context.colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContextBadge extends StatelessWidget {
  const _ContextBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: context.colorScheme.surface.withValues(alpha: 0.20),
        border: Border.all(
          color: context.colorScheme.outline.withValues(alpha: 0.78),
        ),
      ),
      child: Text(label, style: context.textTheme.labelMedium),
    );
  }
}

Future<void> _showFlashcardDialog(
  BuildContext context,
  WidgetRef ref, {
  required List<TrackBlueprint> trackBlueprints,
  required List<ProjectBundle> projectBundles,
  FlashcardEntity? card,
  String? initialDeck,
}) async {
  final userId = ref.read(currentUserIdProvider);
  if (userId == null) return;

  final deckController = TextEditingController(
    text: card?.deckName ?? initialDeck ?? 'Geral',
  );
  final questionController = TextEditingController(text: card?.question ?? '');
  final answerController = TextEditingController(text: card?.answer ?? '');
  final uuid = const Uuid();

  String? selectedTrackId = card?.trackId;
  String? selectedModuleId = card?.moduleId;
  String? selectedProjectId = card?.projectId;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          final selectedTrack = _findTrackBlueprint(
            trackBlueprints,
            selectedTrackId,
          );
          final availableModules =
              selectedTrack?.modules ?? const <StudyModuleEntity>[];

          return AlertDialog(
            title: Text(card == null ? 'Novo flashcard' : 'Editar flashcard'),
            content: SizedBox(
              width: 560,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: deckController,
                      decoration: const InputDecoration(labelText: 'Deck'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: questionController,
                      minLines: 3,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Pergunta / frente do card',
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: answerController,
                      minLines: 4,
                      maxLines: 7,
                      decoration: const InputDecoration(
                        labelText: 'Resposta / verso do card',
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String?>(
                      initialValue:
                          trackBlueprints.any(
                            (item) => item.track.id == selectedTrackId,
                          )
                          ? selectedTrackId
                          : null,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Relacionar trilha',
                      ),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('Sem trilha'),
                        ),
                        ...trackBlueprints.map(
                          (item) => DropdownMenuItem<String?>(
                            value: item.track.id,
                            child: Text(item.track.name),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          selectedTrackId = value;
                          if (!availableModules.any(
                            (item) => item.id == selectedModuleId,
                          )) {
                            selectedModuleId = null;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String?>(
                      initialValue:
                          availableModules.any(
                            (item) => item.id == selectedModuleId,
                          )
                          ? selectedModuleId
                          : null,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Relacionar módulo',
                      ),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('Sem módulo'),
                        ),
                        ...availableModules.map(
                          (item) => DropdownMenuItem<String?>(
                            value: item.id,
                            child: Text(item.title),
                          ),
                        ),
                      ],
                      onChanged: (value) =>
                          setDialogState(() => selectedModuleId = value),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String?>(
                      initialValue:
                          projectBundles.any(
                            (item) => item.project.id == selectedProjectId,
                          )
                          ? selectedProjectId
                          : null,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Relacionar projeto',
                      ),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('Sem projeto'),
                        ),
                        ...projectBundles.map(
                          (item) => DropdownMenuItem<String?>(
                            value: item.project.id,
                            child: Text(item.project.title),
                          ),
                        ),
                      ],
                      onChanged: (value) =>
                          setDialogState(() => selectedProjectId = value),
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
                  final deck = deckController.text.trim().isEmpty
                      ? 'Geral'
                      : deckController.text.trim();
                  final question = questionController.text.trim();
                  final answer = answerController.text.trim();

                  if (question.isEmpty || answer.isEmpty) {
                    dialogContext.showAppSnackBar(
                      'Preencha pergunta e resposta do card.',
                    );
                    return;
                  }

                  final now = DateTime.now().toUtc();
                  final selectedTrack = _findTrackBlueprint(
                    trackBlueprints,
                    selectedTrackId,
                  );
                  final selectedModule = _findModule(
                    selectedTrack?.modules ?? const <StudyModuleEntity>[],
                    selectedModuleId,
                  );
                  final selectedProject = _findProjectBundle(
                    projectBundles,
                    selectedProjectId,
                  );

                  await ref
                      .read(flashcardActionsProvider)
                      .save(
                        FlashcardEntity(
                          id: card?.id ?? uuid.v4(),
                          userId: userId,
                          deckName: deck,
                          question: question,
                          answer: answer,
                          trackId: selectedTrack?.track.id,
                          moduleId: selectedModule?.id,
                          projectId: selectedProject?.project.id,
                          dueAt: card?.dueAt ?? now,
                          lastReviewedAt: card?.lastReviewedAt,
                          reviewCount: card?.reviewCount ?? 0,
                          correctStreak: card?.correctStreak ?? 0,
                          easeFactor: card?.easeFactor ?? 2.3,
                          intervalDays: card?.intervalDays ?? 0,
                          createdAt: card?.createdAt ?? now,
                          updatedAt: now,
                        ),
                      );
                  if (!dialogContext.mounted) return;
                  Navigator.of(dialogContext).pop();
                },
                child: Text(card == null ? 'Criar' : 'Salvar'),
              ),
            ],
          );
        },
      );
    },
  );
}

TrackBlueprint? _findTrackBlueprint(
  List<TrackBlueprint> items,
  String? trackId,
) {
  if (trackId == null) return null;
  for (final item in items) {
    if (item.track.id == trackId) return item;
  }
  return null;
}

StudyModuleEntity? _findModule(
  List<StudyModuleEntity> items,
  String? moduleId,
) {
  if (moduleId == null) return null;
  for (final item in items) {
    if (item.id == moduleId) return item;
  }
  return null;
}

ProjectBundle? _findProjectBundle(
  List<ProjectBundle> items,
  String? projectId,
) {
  if (projectId == null) return null;
  for (final item in items) {
    if (item.project.id == projectId) return item;
  }
  return null;
}

List<String> _contextLabels(
  FlashcardEntity card, {
  required Map<String, String> trackNameById,
  required Map<String, String> moduleNameById,
  required Map<String, String> projectNameById,
}) {
  return [
    if (card.trackId != null && trackNameById.containsKey(card.trackId))
      trackNameById[card.trackId]!,
    if (card.moduleId != null && moduleNameById.containsKey(card.moduleId))
      moduleNameById[card.moduleId]!,
    if (card.projectId != null && projectNameById.containsKey(card.projectId))
      projectNameById[card.projectId]!,
  ];
}

String _normalizedDeckName(String deckName) {
  final normalized = deckName.trim();
  return normalized.isEmpty ? 'Geral' : normalized;
}

DateTime _toLocal(DateTime value) => value.toLocal();

String _formatNextReview(DateTime dueAt) {
  final local = dueAt.toLocal();
  final now = DateTime.now();
  if (!local.isAfter(now)) {
    return 'disponível agora';
  }
  final difference = local.difference(now);
  if (difference.inDays >= 1) {
    return 'em ${difference.inDays}d';
  }
  if (difference.inHours >= 1) {
    return 'em ${difference.inHours}h';
  }
  return 'em ${difference.inMinutes.clamp(1, 59)}min';
}
