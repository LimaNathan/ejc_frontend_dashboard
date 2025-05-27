import 'package:flutter/material.dart';

class BaseViewBackground extends StatelessWidget {
  const BaseViewBackground({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme //
            .surfaceDim
            .withValues(
          alpha: 130,
          blue: 30,
          red: 300,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
        ),
      ),
      child: child,
    );
  }
}
