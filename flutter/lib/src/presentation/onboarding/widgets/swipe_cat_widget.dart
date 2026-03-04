import 'package:flutter/material.dart';

class SwipeCatWidget extends StatefulWidget {
  final Color color;

  const SwipeCatWidget({super.key, required this.color});

  @override
  State<SwipeCatWidget> createState() => _SwipeCatWidgetState();
}

class _SwipeCatWidgetState extends State<SwipeCatWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pawOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _pawOffset = Tween<double>(
      begin: -12,
      end: 12,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;
        // Адаптивный размер, чтобы не налезать на текст при низкой высоте
        final catSize = maxHeight.isFinite
            ? (maxHeight * 0.5).clamp(80.0, 160.0)
            : 160.0;
        final pawSize = catSize * 0.32;
        final bottomOffset = catSize * 0.2;
        final rightOffset = catSize * 0.25;

        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.pets, size: catSize, color: widget.color),
            Positioned(
              right: rightOffset,
              bottom: bottomOffset,
              child: AnimatedBuilder(
                animation: _pawOffset,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_pawOffset.value, 0),
                    child: Transform.rotate(
                      angle: _pawOffset.value * 0.02,
                      child: child,
                    ),
                  );
                },
                child: Icon(
                  Icons.touch_app_rounded,
                  size: pawSize,
                  color: widget.color.withValues(alpha: 0.9),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
