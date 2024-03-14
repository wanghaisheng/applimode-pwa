import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:flutter/material.dart';

class MainLabel extends StatelessWidget {
  const MainLabel({
    super.key,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.containerColor,
    this.labelColor,
  });

  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final Color? containerColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(64)),
          color: containerColor ?? theme.colorScheme.primaryContainer,
        ),
        child: Text(
          context.loc.mainLabel,
          style: theme.textTheme.titleSmall,
        ),
      ),
    );
  }
}
