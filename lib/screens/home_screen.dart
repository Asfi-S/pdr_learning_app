import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDark;

  const HomeScreen({
    super.key,
    required this.toggleTheme,
    required this.isDark,
  });

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

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slide = Tween(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

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
        title: const Text("Вивчення ПДР"),
        actions: [
          IconButton(
            icon: Icon(
              widget.isDark ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: widget.toggleTheme,
          )
        ],
      ),

      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: theme.brightness == Brightness.dark
                ? const [Color(0xFF10101F), Color(0xFF181829)]
                : const [Color(0xFFFFECEC), Color(0xFFFFF6F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/pdr_logo.png',
                      width: 120, height: 120),

                  const SizedBox(height: 16),

                  Text(
                    "Вивчення ПДР",
                    style: theme.textTheme.titleLarge!.copyWith(
                      fontSize: 34,
                      shadows: const [
                        Shadow(
                          blurRadius: 8,
                          offset: Offset(2, 2),
                          color: Colors.black26,
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  _btn(Icons.menu_book_rounded, "Теорія ПДР", "/theory"),
                  const SizedBox(height: 20),

                  _btn(Icons.quiz_rounded, "Тестування", "/test"),
                  const SizedBox(height: 20),

                  _btn(Icons.traffic_rounded, "Дорожні знаки", "/signs"),

                  const SizedBox(height: 60),

                  Text(
                    "© 2025 Asfinian Studio",
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _btn(IconData icon, String text, String route) {
    final theme = Theme.of(context);

    return ElevatedButton.icon(
      onPressed: () => Navigator.pushNamed(context, route),
      icon: Icon(icon, size: 22),
      label: Text(text, style: const TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 6,
      ),
    );
  }
}
