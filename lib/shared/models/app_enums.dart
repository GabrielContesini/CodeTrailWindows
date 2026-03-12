import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum SkillLevel { beginner, junior, midLevel, senior }

@JsonEnum(fieldRename: FieldRename.snake)
enum SessionType { theory, practice, review, project, exercises }

@JsonEnum(fieldRename: FieldRename.snake)
enum TaskPriority { low, medium, high, critical }

@JsonEnum(fieldRename: FieldRename.snake)
enum TaskStatus { pending, inProgress, completed }

@JsonEnum(fieldRename: FieldRename.snake)
enum ReviewStatus { pending, completed, overdue }

@JsonEnum(fieldRename: FieldRename.snake)
enum ProjectStatus { planned, active, blocked, completed }

@JsonEnum(fieldRename: FieldRename.snake)
enum FocusType { job, promotion, freelance, solidFoundation, careerTransition }

@JsonEnum(fieldRename: FieldRename.snake)
enum ThemePreference { system, dark, light }

enum FlashcardReviewGrade { again, hard, good, easy }

enum MindMapNodeShape { rectangle, rounded, ellipse, diamond }

extension SkillLevelX on SkillLevel {
  String get label {
    switch (this) {
      case SkillLevel.beginner:
        return 'Iniciante';
      case SkillLevel.junior:
        return 'Júnior';
      case SkillLevel.midLevel:
        return 'Pleno';
      case SkillLevel.senior:
        return 'Sênior';
    }
  }
}

extension ThemePreferenceX on ThemePreference {
  ThemeMode get themeMode {
    switch (this) {
      case ThemePreference.system:
        return ThemeMode.system;
      case ThemePreference.dark:
        return ThemeMode.dark;
      case ThemePreference.light:
        return ThemeMode.light;
    }
  }

  String get label {
    switch (this) {
      case ThemePreference.system:
        return 'Sistema';
      case ThemePreference.dark:
        return 'Escuro';
      case ThemePreference.light:
        return 'Claro';
    }
  }
}

extension FocusTypeX on FocusType {
  String get label {
    switch (this) {
      case FocusType.job:
        return 'Conseguir vaga';
      case FocusType.promotion:
        return 'Promoção';
      case FocusType.freelance:
        return 'Freelas';
      case FocusType.solidFoundation:
        return 'Base sólida';
      case FocusType.careerTransition:
        return 'Transição de carreira';
    }
  }
}

extension TaskPriorityX on TaskPriority {
  String get label {
    switch (this) {
      case TaskPriority.low:
        return 'Baixa';
      case TaskPriority.medium:
        return 'Média';
      case TaskPriority.high:
        return 'Alta';
      case TaskPriority.critical:
        return 'Crítica';
    }
  }
}

extension TaskStatusX on TaskStatus {
  String get label {
    switch (this) {
      case TaskStatus.pending:
        return 'Pendente';
      case TaskStatus.inProgress:
        return 'Em andamento';
      case TaskStatus.completed:
        return 'Concluída';
    }
  }
}

extension SessionTypeX on SessionType {
  String get label {
    switch (this) {
      case SessionType.theory:
        return 'Teoria';
      case SessionType.practice:
        return 'Prática';
      case SessionType.review:
        return 'Revisão';
      case SessionType.project:
        return 'Projeto';
      case SessionType.exercises:
        return 'Exercícios';
    }
  }
}

extension ReviewStatusX on ReviewStatus {
  String get label {
    switch (this) {
      case ReviewStatus.pending:
        return 'Pendente';
      case ReviewStatus.completed:
        return 'Concluída';
      case ReviewStatus.overdue:
        return 'Atrasada';
    }
  }
}

extension ProjectStatusX on ProjectStatus {
  String get label {
    switch (this) {
      case ProjectStatus.planned:
        return 'Planejado';
      case ProjectStatus.active:
        return 'Ativo';
      case ProjectStatus.blocked:
        return 'Bloqueado';
      case ProjectStatus.completed:
        return 'Concluído';
    }
  }
}

extension FlashcardReviewGradeX on FlashcardReviewGrade {
  String get label {
    switch (this) {
      case FlashcardReviewGrade.again:
        return 'Errei';
      case FlashcardReviewGrade.hard:
        return 'Difícil';
      case FlashcardReviewGrade.good:
        return 'Bom';
      case FlashcardReviewGrade.easy:
        return 'Fácil';
    }
  }
}

extension MindMapNodeShapeX on MindMapNodeShape {
  String get label {
    switch (this) {
      case MindMapNodeShape.rectangle:
        return 'Retângulo';
      case MindMapNodeShape.rounded:
        return 'Bloco';
      case MindMapNodeShape.ellipse:
        return 'Elipse';
      case MindMapNodeShape.diamond:
        return 'Losango';
    }
  }
}
