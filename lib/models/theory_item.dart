class TheoryItem {
  final String number;
  final String title;
  final String text;
  final String? imagePath;

  TheoryItem({
    required this.number,
    required this.title,
    required this.text,
    this.imagePath,
  });
}
