import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../models/sign_model.dart';

class TrafficSignsScreen extends StatefulWidget {
  const TrafficSignsScreen({super.key});

  @override
  State<TrafficSignsScreen> createState() => _TrafficSignsScreenState();
}

class _TrafficSignsScreenState extends State<TrafficSignsScreen> {
  List<SignCategory> categories = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadSigns();
  }

  Future<void> _loadSigns() async {
    final data = await rootBundle.loadString("assets/pdr/signs.json");
    final jsonData = json.decode(data);

    categories = (jsonData["categories"] as List)
        .map((e) => SignCategory.fromJson(e))
        .toList();

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Дорожні знаки")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: categories.length,
        itemBuilder: (_, i) {
          final c = categories[i];

          return Card(
            margin: const EdgeInsets.all(12),
            child: ExpansionTile(
              title: Text(c.title, style: theme.textTheme.titleLarge),
              children: c.signs.map((s) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Картинки (1 або більше)
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: s.images.map((img) {
                          return Image.asset(
                            "assets/pdr/$img",
                            width: 70,
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        s.title,
                        style: theme.textTheme.titleLarge!
                            .copyWith(fontSize: 18),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        s.description,
                        style: theme.textTheme.bodyMedium,
                      ),

                      const SizedBox(height: 12),
                      const Divider(),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
