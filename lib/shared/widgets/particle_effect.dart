import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Particle effect widget for mystical ambiance
class ParticleEffect extends StatefulWidget {
  final int particleCount;
  final Color? particleColor;

  const ParticleEffect({
    super.key,
    this.particleCount = 20,
    this.particleColor,
  });

  @override
  State<ParticleEffect> createState() => _ParticleEffectState();
}

class _ParticleEffectState extends State<ParticleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _initParticles();
  }

  void _initParticles() {
    _particles = List.generate(widget.particleCount, (_) {
      return _Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: 1.5 + _random.nextDouble() * 3,
        speed: 0.2 + _random.nextDouble() * 0.5,
        opacity: 0.1 + _random.nextDouble() * 0.4,
        drift: _random.nextDouble() * 2 * pi,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final particleColor = widget.particleColor ??
        (isDark ? AppColors.goldLight : AppColors.rosePink);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _ParticlePainter(
            particles: _particles,
            progress: _controller.value,
            color: particleColor,
          ),
        );
      },
    );
  }
}

class _Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double opacity;
  final double drift;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.drift,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final Color color;

  _ParticlePainter({
    required this.particles,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final y = (particle.y - progress * particle.speed) % 1.0;
      final x = (particle.x + sin(progress * 2 + particle.drift) * 0.02) % 1.0;

      final paint = Paint()
        ..color = color.withValues(alpha: particle.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
