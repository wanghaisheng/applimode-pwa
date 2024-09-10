import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:flutter/material.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mainColor = Theme.of(context).colorScheme.primaryFixedDim;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.maintenanceTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.build_circle_outlined,
              size: 64,
              color: mainColor,
            ),
            const SizedBox(height: 16),
            Text(
              context.loc.maintenanceMessage,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: mainColor),
            ),
          ],
        ),
      ),
    );
  }
}
