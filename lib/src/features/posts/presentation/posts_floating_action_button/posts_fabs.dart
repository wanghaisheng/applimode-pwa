import 'package:applimode_app/src/common_widgets/percent_circular_indicator.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_floating_action_button/direct_upload_button.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_floating_action_button/direct_upload_button_controller.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_floating_action_button/posts_floating_action_button.dart';
import 'package:applimode_app/src/utils/async_value_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:applimode_app/src/utils/upload_progress_state.dart';

class PostsFabs extends ConsumerWidget {
  const PostsFabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(directUploadButtonControllerProvider, (_, state) {
      state.showAlertDialogOnError(context);
    });
    final isLoading = ref.watch(directUploadButtonControllerProvider).isLoading;
    final uploadState = ref.watch(uploadProgressStateProvider);
    return kIsWeb
        ? const PostsFloatingActionButton()
        : isLoading
            ? Center(
                child: PercentCircularIndicator(
                  // backgroundColor: Colors.white,
                  strokeWidth: 8,
                  percentage: uploadState.percentage,
                ),
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DirectUploadButton(
                    heroTag: 'uploadFab',
                  ),
                  SizedBox(height: 12),
                  PostsFloatingActionButton(heroTag: 'publishFab'),
                ],
              );
  }
}
