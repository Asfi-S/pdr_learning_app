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
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

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
            icon: Icon(widget.isDark ? Icons.dark_mode : Icons.light_mode),
            onPressed: widget.toggleTheme,
          )
        ],
      ),

      /// 🔥 Адаптивний фон (тема → градієнт)
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: theme.brightness == Brightness.dark
                ? const [Color(0xFF10101F), Color(0xFF181829)]
                : const [Color(0xFFFFE9E9), Color(0xFFFFF5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/pdr_logo.png',
                      width: 120, height: 120),

                  Text(
                    'Вивчення ПДР',
                    style: theme.textTheme.titleLarge!.copyWith(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
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

                  _button(
                    icon: Icons.menu_book_rounded,
                    text: 'Теорія ПДР',
                    route: '/theory',
                  ),
                  const SizedBox(height: 20),

                  _button(
                    icon: Icons.quiz_rounded,
                    text: 'Тестування',
                    route: '/test',
                  ),
                  const SizedBox(height: 20),

                  _button(
                    icon: Icons.traffic_rounded,
                    text: 'Дорожні знаки',
                    route: '/signs',
                  ),

                  const SizedBox(height: 60),
                  Text(
                    '© 2025 Asfinian Studio',
                    style: theme.textTheme.bodyMedium!
                        .copyWith(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _button({
    required IconData icon,
    required String text,
    required String route,
  }) {
    final theme = Theme.of(context);

    return ElevatedButton.icon(
      onPressed: () => Navigator.pushNamed(context, route),
      icon: Icon(icon, size: 24),
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
