import 'package:flutter/material.dart';
import '../data/user_name_manager.dart';
import '../data/user_profile_manager.dart';
import 'home_screen.dart';

class SetNameScreen extends StatefulWidget {
  final bool firstSetup;
  const SetNameScreen({super.key, this.firstSetup = false});

  @override
  State<SetNameScreen> createState() => _SetNameScreenState();
}

class _SetNameScreenState extends State<SetNameScreen> {
  final TextEditingController _controller = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  Future<void> _loadName() async {
    final profile = await UserProfileManager.loadProfile();
    _controller.text = profile.username;
    setState(() {});
  }

  Future<void> _save() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;

    setState(() => loading = true);

    await UserNameManager.saveName(name);

    final profile = await UserProfileManager.loadProfile();
    profile.username = name;
    await UserProfileManager.saveProfile(profile);

    if (!mounted) return;

    if (widget.firstSetup) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Вкажи імʼя"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Як тебе звати?",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Введи своє ім'я",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: loading ? null : _save,
                  child: loading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text("Зберегти"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
