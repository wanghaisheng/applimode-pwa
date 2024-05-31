import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/common_widgets/image_widgets/platform_image.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/features/comments/presentation/post_comment_controller.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/async_value_ui.dart';
import 'package:applimode_app/src/utils/show_adaptive_alert_dialog.dart';
import 'package:applimode_app/src/utils/show_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class PostCommentsScreenBottomBar extends ConsumerStatefulWidget {
  const PostCommentsScreenBottomBar({
    super.key,
    required this.postId,
    this.parentCommentId,
    this.postWriter,
  });

  final String postId;
  final String? parentCommentId;
  final AppUser? postWriter;

  @override
  ConsumerState<PostCommentsScreenBottomBar> createState() =>
      _PostCommentsScreenBottomBarState();
}

class _PostCommentsScreenBottomBarState
    extends ConsumerState<PostCommentsScreenBottomBar> {
  final TextEditingController _controller = TextEditingController();
  XFile? _pickedFile;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_controller.text.trim().isEmpty && _pickedFile == null) {
      showAdaptiveAlertDialog(
        context: context,
        title: context.loc.ooops,
        content: context.loc.emptyContent,
      );
      return;
    }
    final success =
        await ref.read(postCommentControllerProvider.notifier).leaveComment(
              postId: widget.postId,
              parentCommentId: widget.parentCommentId,
              isReply: widget.parentCommentId != null,
              content: _controller.text,
              xFile: _pickedFile,
              postWriter: widget.postWriter,
              commentNotiString: context.loc.commentNoti,
              replyNotiString: context.loc.replyNoti,
            );
    if (success == true) {
      _controller.clear();
      if (mounted) {
        setState(() {
          _pickedFile = null;
        });
      }
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(postCommentControllerProvider, (_, state) {
      state.showAlertDialogOnError(context);
    });
    final mediaMaxMBSize = ref.watch(adminSettingsProvider).mediaMaxMBSize;
    final user = ref.watch(authStateChangesProvider).value;
    final isLoading = ref.watch(postCommentControllerProvider).isLoading;
    return InkWell(
      onTap: user == null
          ? () => showAdaptiveAlertDialog(
              context: context, content: context.loc.needLogin)
          : () {},
      child: IgnorePointer(
        ignoring: user == null || isLoading,
        child: GestureDetector(
          onVerticalDragDown: (details) => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.translucent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Theme.of(context).colorScheme.onInverseSurface,
            child: SafeArea(
              child: Row(
                children: [
                  if (_pickedFile != null)
                    Expanded(
                      child: Row(
                        children: [
                          FlatformImage(
                            xFile: _pickedFile!,
                            height: 96,
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _pickedFile = null;
                              });
                            },
                            icon: const Icon(
                              Icons.close,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (_pickedFile == null)
                    IconButton(
                      onPressed: () async {
                        _pickedFile = await showImagePicker(
                          maxWidth: postImageMaxWidth,
                          imageQuality: postImageQuality,
                          mediaMaxMBSize: mediaMaxMBSize,
                        );
                        setState(() {});
                      },
                      icon: const Icon(Icons.image_outlined),
                    ),
                  if (_pickedFile == null)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Center(
                          child: TextField(
                            controller: _controller,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                              hintText: context.loc.leaveComment,
                              // hintStyle: TextStyle(color: Colors.grey.shade400),
                            ),
                            onEditingComplete: _submit,
                          ),
                        ),
                      ),
                    ),
                  IconButton(
                    onPressed: _submit,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
