import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/section_model.dart';
import '../models/theory_item.dart';

class PdrLoader {
  static Future<List<SectionModel>> loadSections() async {
    final jsonString = await rootBundle.loadString('assets/pdr/sections.json');
    final List data = json.decode(jsonString);

    return data.map((sectionData) {
      final theoryList = (sectionData['theory'] as List).map((t) {
        return TheoryItem(
          number: t['number'],
          title: t['title'],
          text: t['text'],
          imagePath: t['imagePath'],
        );
      }).toList();

      return SectionModel(
        id: sectionData['id'],
        title: sectionData['title'],
        description: sectionData['description'],
        imagePath: sectionData['imagePath'],
        theory: theoryList,
      );
    }).toList();
  }
}
