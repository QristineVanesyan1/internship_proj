import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.scale(
        scale: size,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
