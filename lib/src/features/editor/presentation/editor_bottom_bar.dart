import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/features/editor/presentation/editor_screen_controller.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/check_category.dart';
import 'package:applimode_app/src/utils/remote_config_service.dart';
import 'package:applimode_app/src/utils/show_adaptive_alert_dialog.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:applimode_app/src/utils/web_back/web_back_stub.dart';

class EditorBottomBar extends ConsumerStatefulWidget {
  const EditorBottomBar({
    super.key,
    required this.bottomBarHeight,
    required this.getMedia,
    required this.controller,
    this.postId,
    this.catetory,
    this.hasPostContent,
    this.remoteMedia,
    this.writer,
  });

  final double bottomBarHeight;
  final Future<void> Function({
    bool isMedia,
    bool isVideo,
  }) getMedia;
  final TextEditingController controller;
  final String? postId;
  final int? catetory;
  final bool? hasPostContent;
  final List<String>? remoteMedia;
  final AppUser? writer;

  @override
  ConsumerState<EditorBottomBar> createState() => _EditorBottomBarState();
}

class _EditorBottomBarState extends ConsumerState<EditorBottomBar> {
  static const iconSizeForBottomBar = 32.0;
  late int category;

  @override
  void initState() {
    category = widget.catetory ?? 0;
    widget.controller.addListener(_setState);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant EditorBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.catetory != widget.catetory) {
      category = widget.catetory ?? 0;
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_setState);
    super.dispose();
  }

  void _setState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final categoryList = ref.watch(remoteConfigServiceProvider).mainCategory;
    final state = ref.watch(editorScreenControllerProvider);
    final goRouter = ref.watch(goRouterProvider);
    // final progressState = ref.watch(uploadProgressStateProvider);

    return SafeArea(
      child: GestureDetector(
        onVerticalDragDown: (details) => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          height: state.isLoading ? widget.bottomBarHeight : null,
          child: /* state.isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        '${context.loc.uploadingFile} ${progressState.index + 1}: ${progressState.percentage == 0 ? context.loc.initializing : progressState.percentage}${progressState.percentage == 0 ? '' : '%'}'),
                    const SizedBox(width: 12),
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    ),
                  ],
                )
              : */
              IgnorePointer(
            ignoring: state.isLoading,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // media
                    if (!kIsWeb)
                      IconButton(
                        onPressed: () => widget.getMedia(isMedia: true),
                        icon: const Icon(Icons.image_outlined),
                        iconSize: iconSizeForBottomBar,
                      ),
                    if (kIsWeb)
                      // image
                      ...[
                      IconButton(
                        onPressed: () => widget.getMedia(),
                        icon: const Icon(Icons.image_outlined),
                        iconSize: iconSizeForBottomBar,
                      ),
                      // video
                      IconButton(
                        onPressed: () => widget.getMedia(
                          isVideo: true,
                        ),
                        icon: const Icon(Icons.slideshow_outlined),
                        iconSize: iconSizeForBottomBar,
                      ),
                    ],
                    if (useCategory) ...[
                      const SizedBox(width: 12),
                      MenuAnchor(
                        builder: (context, controller, child) {
                          return FilledButton.tonal(
                            onPressed: () async {
                              if (controller.isOpen) {
                                controller.close();
                              } else {
                                FocusScope.of(context).unfocus();
                                await Future.delayed(
                                    const Duration(milliseconds: 250));
                                controller.open();
                              }
                            },
                            style: ButtonStyle(
                                padding: const MaterialStatePropertyAll(
                                  EdgeInsets.symmetric(
                                    horizontal: 24,
                                    // vertical: 12,
                                  ),
                                ),
                                backgroundColor: MaterialStatePropertyAll(
                                    checkCategory(categoryList, category)
                                        .color),
                                foregroundColor: const MaterialStatePropertyAll(
                                    Colors.white)),
                            child: Text(
                              checkCategory(categoryList, category).title,
                            ),
                          );
                        },
                        menuChildren: [
                          ...categoryList.map((item) => MenuItemButton(
                                onPressed: () {
                                  category = item.index;
                                  setState(() {});
                                },
                                child: Text(item.title),
                              )),
                        ],
                      ),
                    ],
                    const SizedBox(width: 12),
                  ],
                ),
                FilledButton(
                  onPressed: widget.controller.text.trim().isEmpty
                      ? null
                      : () async {
                          if (widget.controller.text.trim().isEmpty) {
                            showAdaptiveAlertDialog(
                              context: context,
                              title: context.loc.ooops,
                              content: context.loc.emptyContent,
                            );
                            return;
                          }
                          final result = await ref
                              .read(editorScreenControllerProvider.notifier)
                              .publish(
                                content: widget.controller.text,
                                category: category,
                                hasPostContent: widget.hasPostContent ?? false,
                                postId: widget.postId,
                                oldRemoteMedia: widget.remoteMedia,
                                needLogin: context.loc.needLogin,
                                needPermission: context.loc.needPermission,
                                faildPostSubmit: context.loc.failedPostSubmit,
                                initializing: context.loc.initializing,
                                uploadingFile: context.loc.uploadingFile,
                                completing: context.loc.completing,
                                writer: widget.writer,
                                postNotiString: context.loc.postNoti,
                              );
                          if (mounted && result) {
                            if (kIsWeb) {
                              WebBackStub().back();
                            } else {
                              if (goRouter.canPop()) {
                                goRouter.pop();
                              }
                            }
                          }
                        },
                  style: const ButtonStyle(
                    padding: MaterialStatePropertyAll(
                      EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                  ),
                  child: Text(
                    context.loc.submit,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
