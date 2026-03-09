import '../../shared/models/app_enums.dart';
import '../../shared/models/app_view_models.dart';

class StudyPlanGenerator {
  const StudyPlanGenerator._();

  static StudyPlanPreview buildPreview(
    OnboardingInput input, {
    TrackBlueprint? blueprint,
    DateTime? referenceDate,
  }) {
    final totalWeeklyHours = input.hoursPerDay * input.daysPerWeek;
    final now = (referenceDate ?? DateTime.now()).toUtc();
    final daysUntilDeadline = input.deadline.toUtc().difference(now).inDays;
    final horizonWeeks = ((daysUntilDeadline <= 0 ? 7 : daysUntilDeadline) / 7)
        .ceil();
    final trackEffortHours = blueprint == null
        ? totalWeeklyHours * 4
        : blueprint.modules.fold<int>(
            0,
            (sum, module) => sum + module.estimatedHours,
          );
    final availableHours = totalWeeklyHours * horizonWeeks;
    final loadFactor = trackEffortHours == 0
        ? 1.0
        : availableHours / trackEffortHours;

    final confidenceLabel = loadFactor >= 1.4
        ? 'Ritmo confortável'
        : loadFactor >= 1.0
            ? 'Ritmo sustentável'
            : 'Ritmo apertado';

    final milestones = <String>[
      if (blueprint != null && blueprint.modules.isNotEmpty)
        'Começar por ${blueprint.modules.first.title} e fechar o bloco base nas 2 primeiras semanas.',
      if (blueprint != null && blueprint.modules.length > 1)
        'Conectar ${blueprint.modules[1].title} com prática aplicada até a semana ${horizonWeeks > 3 ? 4 : horizonWeeks}.',
      'Entregar um projeto incremental de ${input.selectedTrackName} até ${input.targetDateLabel}.',
    ];

    return StudyPlanPreview(
      headline:
          'Plano para ${input.focusType.label.toLowerCase()} em ${input.selectedTrackName}',
      confidenceLabel: confidenceLabel,
      weeklyHours: totalWeeklyHours,
      horizonWeeks: horizonWeeks,
      trackEffortHours: trackEffortHours,
      milestones: milestones,
      weeklyPlaybook: [
        'Separar ${input.hoursPerDay}h por dia em blocos curtos e previsíveis.',
        'Alternar teoria, prática e revisão para não acumular contexto morto.',
        'Fechar a semana com uma entrega tangível: nota, etapa de projeto ou revisão concluída.',
      ],
    );
  }

  static String buildSummary(
    OnboardingInput input, {
    TrackBlueprint? blueprint,
    DateTime? referenceDate,
  }) {
    final preview = buildPreview(
      input,
      blueprint: blueprint,
      referenceDate: referenceDate,
    );

    return '''
${preview.headline}
- Priorizar módulos centrais nas primeiras ${preview.horizonWeeks > 4 ? 4 : preview.horizonWeeks} semanas
- Reservar ${input.hoursPerDay}h por dia, ${input.daysPerWeek} dias por semana
- Alternar teoria, prática e revisão curta
- Incluir um projeto prático incremental até ${input.targetDateLabel}
- Revisar conteúdos em D+1, D+7, D+15 e D+30

Carga semanal estimada: ${preview.weeklyHours}h.
Ritmo sugerido: ${preview.confidenceLabel}.
'''
        .trim();
  }
}
