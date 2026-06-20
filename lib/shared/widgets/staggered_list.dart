import 'package:flutter/material.dart';

class StaggeredList extends StatefulWidget {
  const StaggeredList({super.key, required this.children});
  final List<Widget> children;

  @override
  State<StaggeredList> createState() => _StaggeredListState();
}

class _StaggeredListState extends State<StaggeredList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.children.asMap().entries.map((e) {
        final delay = (e.key * 0.1).clamp(0.0, 0.5);
        final end = (delay + 0.5).clamp(0.0, 1.0);
        final curve = CurvedAnimation(
          parent: _controller,
          curve: Interval(delay, end, curve: Curves.easeOutCubic),
        );
        return AnimatedBuilder(
          animation: curve,
          builder: (context, _) => Opacity(
            opacity: curve.value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - curve.value)),
              child: e.value,
            ),
          ),
        );
      }).toList(),
    );
  }
}
