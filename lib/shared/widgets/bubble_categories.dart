import 'package:flutter/material.dart';

class BubbleCategory {
  const BubbleCategory({required this.label, required this.color, required this.size, required this.offset});
  final String label;
  final Color color;
  final double size;
  final Offset offset;
}

class BubbleCategories extends StatefulWidget {
  const BubbleCategories({super.key, required this.categories, required this.onTap, this.height = 280});
  final List<BubbleCategory> categories;
  final ValueChanged<String> onTap;
  final double height;

  @override
  State<BubbleCategories> createState() => _BubbleCategoriesState();
}

class _BubbleCategoriesState extends State<BubbleCategories> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: widget.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: widget.categories.asMap().entries.map((e) {
          final i = e.key;
          final cat = e.value;
          final delay = (i * 0.08).clamp(0.0, 0.4);
          final end = (delay + 0.5).clamp(0.0, 1.0);

          return AnimatedBuilder(
            animation: CurvedAnimation(
              parent: _controller,
              curve: Interval(delay, end, curve: Curves.elasticOut),
            ),
            builder: (context, child) {
              final scale = CurvedAnimation(
                parent: _controller,
                curve: Interval(delay, end, curve: Curves.elasticOut),
              ).value;

              return Positioned(
                left: cat.offset.dx - cat.size / 2,
                top: cat.offset.dy - cat.size / 2,
                child: Transform.scale(
                  scale: scale,
                  child: child,
                ),
              );
            },
            child: GestureDetector(
              onTap: () => widget.onTap(cat.label),
              child: Container(
                width: cat.size,
                height: cat.size,
                decoration: BoxDecoration(
                  color: cat.color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  cat.label,
                  style: TextStyle(
                    fontSize: cat.size * 0.16,
                    fontWeight: FontWeight.w700,
                    color: cat.color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
