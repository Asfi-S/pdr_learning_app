import 'theory_item.dart';

class SectionModel {
  final String id;
  final String title;
  final String description;
  final List<TheoryItem> theory;
  final String? imagePath;

  SectionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.theory,
    this.imagePath,
  });
}
