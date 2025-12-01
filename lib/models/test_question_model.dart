class TestQuestionModel {
  final String id;
  final String sectionId;
  final String question;
  final List<String> answers;
  final int correctIndex;
  final String? imagePath;

  final String? explanation;

  TestQuestionModel({
    required this.id,
    required this.sectionId,
    required this.question,
    required this.answers,
    required this.correctIndex,
    this.imagePath,
    this.explanation,
  });

  factory TestQuestionModel.fromJson(Map<String, dynamic> json) {
    return TestQuestionModel(
      id: json["id"].toString(),
      sectionId: json["sectionId"].toString(),
      question: json["question"],
      answers: List<String>.from(json["answers"]),
      correctIndex: json["correctIndex"],
      imagePath: json["imagePath"],
      explanation: json["explanation"],
    );
  }
}
