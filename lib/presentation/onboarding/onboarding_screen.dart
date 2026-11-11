import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _isLoading = false;

  Future<void> _selectRole(String role) async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role', role);
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF0FDFD),
              Color(0xFFFAFAFA),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Header
                Column(
                  children: [
                    const Text('👋', style: TextStyle(fontSize: 60))
                        .animate()
                        .scale(duration: 500.ms, curve: Curves.elasticOut),
                    const SizedBox(height: 16),
                    Text(
                      'Kamu siapa?',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onBackground,
                        letterSpacing: -1,
                      ),
                      textAlign: TextAlign.center,
                    )
                        .animate(delay: 200.ms)
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 10),
                    Text(
                      'Pilih peran kamu untuk pengalaman\nyang sesuai dengan kebutuhanmu',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    )
                        .animate(delay: 300.ms)
                        .fadeIn(duration: 400.ms),
                  ],
                ),

                const SizedBox(height: 48),

                // UMKM Card
                _RoleCard(
                  emoji: '🏪',
                  title: 'Pelaku UMKM',
                  description:
                      'Kamu punya usaha dan butuh bantuan desain produk yang keren',
                  color: const Color(0xFF167D8D),
                  onTap: _isLoading ? null : () => _selectRole('umkm'),
                  delay: 400,
                ),

                const SizedBox(height: 16),

                // Kreator Card
                _RoleCard(
                  emoji: '🎨',
                  title: 'Kreator',
                  description:
                      'Kamu punya keahlian desain dan ingin membantu UMKM lokal',
                  color: const Color(0xFF6C63FF),
                  onTap: _isLoading ? null : () => _selectRole('kreator'),
                  delay: 500,
                ),

                const Spacer(),

                // Footer
                Text(
                  'KriyaLink • Kolaborasi Kreatif untuk UMKM Lokal',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.35),
                  ),
                  textAlign: TextAlign.center,
                ).animate(delay: 600.ms).fadeIn(duration: 400.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatefulWidget {
  final String emoji;
  final String title;
  final String description;
  final Color color;
  final VoidCallback? onTap;
  final int delay;

  const _RoleCard({
    required this.emoji,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
    required this.delay,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.color,
                widget.color.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Text(widget.emoji, style: const TextStyle(fontSize: 48)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.85),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white.withOpacity(0.7),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: Duration(milliseconds: widget.delay))
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.2, end: 0);
  }
}
