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
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(left: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 96,
                height: 96,
                child: CircularProgressIndicator(
                  strokeWidth: strokeWidth,
                  color: backgroundColor ?? primary,
                  // backgroundColor: backgroundColor,
                ),
              ),
              Text(
                '$percentage%',
                style: TextStyle(
                    fontSize: 16,
                    color: backgroundColor ?? primary,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          if (index != null) ...[
            const SizedBox(height: 12),
            Text(
              '${context.loc.uploadingFile} ${index! + 1}',
              textAlign: TextAlign.center,
              style: TextStyle(color: backgroundColor ?? primary),
            )
          ]
        ],
      ),
    );
  }
}
