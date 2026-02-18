class SurvivalTipModel {
  const SurvivalTipModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.thumbnailUrl,
    required this.videoUrl,
  });

  final String id;
  final String title;
  final String description;
  final String category;
  final String thumbnailUrl;
  final String videoUrl;
}
