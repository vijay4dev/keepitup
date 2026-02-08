import 'package:flutter/material.dart';
import 'package:keepitup/utils/Appcolors.dart';

class RotatingFab extends StatefulWidget {
  final VoidCallback onTap;
  const RotatingFab({super.key, required this.onTap});

  @override
  State<RotatingFab> createState() => _RotatingFabState();
}

class _RotatingFabState extends State<RotatingFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0);
    widget.onTap(); // 🔥 delegate responsibility
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _handleTap,
      shape: CircleBorder(),
      elevation: 0,
      backgroundColor: Appcolors.app_blue_color,
      child: RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
        child: const Icon(Icons.sync),
      ),
    );
  }
}
