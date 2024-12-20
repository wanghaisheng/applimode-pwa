import 'package:flutter/material.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';

class PercentCircularIndicator extends StatelessWidget {
  const PercentCircularIndicator({
    super.key,
    this.strokeWidth = 2.0,
    this.backgroundColor,
    this.percentage = 0,
    this.index,
  });

  final double strokeWidth;
  final Color? backgroundColor;
  final int percentage;
  final int? index;

  @override
  Widget build(BuildContext context) {
    // final primary = Theme.of(context).colorScheme.primary;
    const defaultColor = Colors.white;
    // If not centered, padding left 28
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          borderRadius: const BorderRadius.all(Radius.circular(24))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 96,
                height: 96,
                child: CircularProgressIndicator(
                  strokeWidth: strokeWidth,
                  color: backgroundColor ?? defaultColor,
                  // backgroundColor: backgroundColor,
                ),
              ),
              Text(
                '$percentage%',
                style: TextStyle(
                    fontSize: 16,
                    color: backgroundColor ?? defaultColor,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          if (index != null) ...[
            const SizedBox(height: 24),
            Text(
              '${context.loc.uploadingFile} ${index! + 1}',
              textAlign: TextAlign.center,
              style: TextStyle(color: backgroundColor ?? defaultColor),
              overflow: TextOverflow.ellipsis,
            )
          ]
        ],
      ),
    );
  }
}
