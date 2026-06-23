import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

/// 3D card flip animation widget
class CardFlipAnimation extends StatefulWidget {
  final Widget frontChild;
  final Widget backChild;
  final bool isFlipped;
  final VoidCallback? onFlipComplete;

  const CardFlipAnimation({
    super.key,
    required this.frontChild,
    required this.backChild,
    this.isFlipped = false,
    this.onFlipComplete,
  });

  @override
  State<CardFlipAnimation> createState() => CardFlipAnimationState();
}

class CardFlipAnimationState extends State<CardFlipAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showFront = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppConstants.cardFlipDuration,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _showFront = widget.isFlipped;
    if (widget.isFlipped) {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(CardFlipAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped && widget.isFlipped) {
      _controller.forward().then((_) {
        widget.onFlipComplete?.call();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Programmatically trigger flip
  void flip() {
    _controller.forward().then((_) {
      widget.onFlipComplete?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final angle = _animation.value * 3.14159;
        final isFront = angle < 3.14159 / 2;
        if (isFront != _showFront) {
          // Use callback to avoid build-time setState
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _showFront = isFront);
          });
        }

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          child: isFront ? widget.frontChild : widget.backChild,
        );
      },
    );
  }
}
