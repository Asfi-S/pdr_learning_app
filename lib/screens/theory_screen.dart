import 'package:flutter/material.dart';
import '../data/pdr_loader.dart';
import '../models/section_model.dart';

class TheoryScreen extends StatefulWidget {
  const TheoryScreen({super.key});

  @override
  State<TheoryScreen> createState() => _TheoryScreenState();
}

class _TheoryScreenState extends State<TheoryScreen> {
  List<SectionModel> sections = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    sections = await PdrLoader.loadSections();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Теорія ПДР')),
      body: sections.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sections.length,
        itemBuilder: (_, i) {
          final s = sections[i];

          return Card(
            color: theme.cardColor,
            elevation: 3,
            shadowColor: theme.shadowColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              title: Text(
                s.title,
                style: theme.textTheme.titleLarge,
              ),
              subtitle: Text(
                s.description,
                style: theme.textTheme.bodyMedium,
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded,
                  color: theme.colorScheme.onSurface),
              onTap: () => Navigator.pushNamed(
                context,
                '/section_details',
                arguments: s,
              ),
            ),
          );
        },
      ),
    );
  }
}
