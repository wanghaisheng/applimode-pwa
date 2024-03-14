import 'dart:math';

import 'package:applimode_app/src/constants/color_palettes.dart';
import 'package:flutter/material.dart';

class GradientBox extends StatelessWidget {
  const GradientBox({
    super.key,
    this.index,
    this.child,
  });

  final int? index;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final hasIndex = index != null;
    final colorCount = hasIndex ? index! % 25 : Random().nextInt(25);
    final firstColor = gradientColorPalettes[colorCount][0];
    final secondColor = gradientColorPalettes[colorCount][1];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        gradient: LinearGradient(
          // stops: const [0.2, 0.6],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [firstColor, secondColor],
        ),
      ),
      child: Center(child: child),
    );
  }
}
