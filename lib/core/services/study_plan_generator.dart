import '../../shared/models/app_view_models.dart';

class StudyPlanGenerator {
  const StudyPlanGenerator._();

  static String buildSummary(OnboardingInput input) {
    final totalWeeklyHours = input.hoursPerDay * input.daysPerWeek;

    return '''
Plano inicial gerado para ${input.selectedTrackName}:
- Priorizar módulos centrais nas primeiras 4 semanas
- Reservar ${input.hoursPerDay}h por dia, ${input.daysPerWeek} dias por semana
- Alternar teoria, prática e revisão curta
- Incluir um projeto prático incremental até ${input.targetDateLabel}
- Revisar conteúdos em D+1, D+7, D+15 e D+30

Carga semanal estimada: ${totalWeeklyHours}h.
'''
        .trim();
  }
}
