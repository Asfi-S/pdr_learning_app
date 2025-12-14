import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _slide = Tween(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("ПДР України 2025"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.account_circle_rounded, size: 30),
          onPressed: () => Navigator.pushNamed(context, "/profile"),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded, size: 26),
            onPressed: () => Navigator.pushNamed(context, "/settings"),
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        color: theme.scaffoldBackgroundColor,
        child: SafeArea(
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/pdr_logo.png",
                      width: 190,
                    ),
                    const SizedBox(height: 22),
                    Text(
                      "ПДР України 2025",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Актуальна підготовка до іспиту МВС",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onBackground.withOpacity(0.7),
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 44),
                    _btn(
                      icon: Icons.menu_book_rounded,
                      text: "Теорія ПДР",
                      route: "/theory",
                    ),
                    const SizedBox(height: 18),
                    _btn(
                      icon: Icons.quiz_rounded,
                      text: "Тестування",
                      route: "/test",
                      primary: true,
                    ),
                    const SizedBox(height: 18),
                    _btn(
                      icon: Icons.traffic_rounded,
                      text: "Дорожні знаки",
                      route: "/signs",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _btn({
    required IconData icon,
    required String text,
    required String route,
    bool primary = false,
  }) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 260,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.pushNamed(context, route),
        icon: Icon(icon, size: 22),
        label: Text(text, style: const TextStyle(fontSize: 18)),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          elevation: primary ? 10 : 6,
          shadowColor: primary
              ? theme.colorScheme.primary.withOpacity(0.45)
              : Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
      ),
    );
  }
}
