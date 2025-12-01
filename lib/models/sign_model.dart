class SignCategory {
  final String id;
  final String title;
  final List<RoadSign> signs;

  SignCategory({
    required this.id,
    required this.title,
    required this.signs,
  });

  factory SignCategory.fromJson(Map<String, dynamic> json) {
    return SignCategory(
      id: json['id'],
      title: json['title'],
      signs: (json['signs'] as List)
          .map((e) => RoadSign.fromJson(e))
          .toList(),
    );
  }
}

class RoadSign {
  final String id;
  final String title;

  final List<String> images;

  final String description;

  RoadSign({
    required this.id,
    required this.title,
    required this.images,
    required this.description,
  });

  factory RoadSign.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("image")) {
      return RoadSign(
        id: json['id'],
        title: json['title'],
        images: [json['image']],
        description: json['description'],
      );
    }

    return RoadSign(
      id: json['id'],
      title: json['title'],
      images: (json['images'] as List).map((e) => e.toString()).toList(),
      description: json['description'],
    );
  }
}
