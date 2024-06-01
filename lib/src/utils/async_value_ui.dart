import 'dart:developer' as dev;

import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/show_adaptive_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueUI on AsyncValue {
  void showAlertDialogOnError(
    BuildContext context, {
    String? content,
  }) {
    dev.log('AsyncValueUi - isLoading: $isLoading, hasError: $hasError');
    if (!isLoading && hasError) {
      final message = error.toString();
      debugPrint('AsyncValueUIError: $message');
      showAdaptiveAlertDialog(
        context: context,
        title: context.loc.error,
        content: content ?? context.loc.tryLater,
      );
      /*
      final message = error.toString();
      showExceptionAlertDialog(
        context: context,
        title: 'Error',
        exception: message,
      );
      */
    }
  }
}
