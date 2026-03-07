import 'app_enums.dart';

class TrackSeedBundle {
  const TrackSeedBundle({required this.tracks});

  final List<TrackSeed> tracks;
}

class TrackSeed {
  const TrackSeed({
    required this.id,
    required this.name,
    required this.description,
    required this.iconKey,
    required this.colorHex,
    required this.roadmapSummary,
    required this.skills,
    required this.modules,
  });

  final String id;
  final String name;
  final String description;
  final String iconKey;
  final String colorHex;
  final String roadmapSummary;
  final List<SkillSeed> skills;
  final List<ModuleSeed> modules;
}

class SkillSeed {
  const SkillSeed({
    required this.id,
    required this.name,
    required this.description,
    required this.targetLevel,
    required this.sortOrder,
  });

  final String id;
  final String name;
  final String description;
  final SkillLevel targetLevel;
  final int sortOrder;
}

class ModuleSeed {
  const ModuleSeed({
    required this.id,
    required this.title,
    required this.summary,
    required this.estimatedHours,
    required this.sortOrder,
    required this.isCore,
  });

  final String id;
  final String title;
  final String summary;
  final int estimatedHours;
  final int sortOrder;
  final bool isCore;
}
