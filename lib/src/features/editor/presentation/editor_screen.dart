import 'dart:async';

import 'package:applimode_app/src/utils/regex.dart';
import 'package:applimode_app/src/utils/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:applimode_app/src/common_widgets/percent_circular_indicator.dart';
import 'package:applimode_app/src/common_widgets/web_back_button.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/editor/presentation/editor_bottom_bar.dart';
import 'package:applimode_app/src/features/editor/presentation/editor_field.dart';
import 'package:applimode_app/src/features/editor/presentation/editor_screen_controller.dart';
import 'package:applimode_app/src/features/editor/presentation/markdown_field.dart';
import 'package:applimode_app/src/features/posts/data/post_contents_repository.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/features/posts/domain/post_and_writer.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/async_value_ui.dart';
import 'package:applimode_app/src/utils/build_remote_media.dart';
import 'package:applimode_app/src/utils/show_adaptive_alert_dialog.dart';
import 'package:applimode_app/src/utils/show_image_picker.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:applimode_app/src/utils/upload_progress_state.dart';

// tabBar comp
class TabTitle {
  const TabTitle({
    this.icon,
    this.title,
  });

  final Icon? icon;
  final String? title;
}

class EditorScreen extends ConsumerStatefulWidget {
  const EditorScreen({
    super.key,
    this.postId,
    this.postAndWriter,
  });

  final String? postId;
  final PostAndWriter? postAndWriter;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  final _controller = TextEditingController();
  late FocusNode _focusNode;
  int currentCategory = 0;
  bool hasPostContent = false;
  List<String>? _remoteMedia;

  static const bottomBarHeight = 80.0;
  static const widthBreak = 800.0;

  // for auto save when writing a new post
  late Timer t;

  @override
  void initState() {
    t = Timer(const Duration(milliseconds: 0), () {});
    _focusNode = FocusNode();
    if (widget.postId != null) {
      if (widget.postAndWriter != null) {
        if (widget.postAndWriter!.post.isLongContent) {
          buildLongContent();
        } else {
          _controller.text = widget.postAndWriter?.post.content ?? '';
          currentCategory = widget.postAndWriter?.post.category ?? 0;
          _remoteMedia = buildRemoteMedia(_controller.text);
        }
      } else {
        buildCurrentPost();
      }
    } else {
      final tempNewPost =
          ref.read(sharedPreferencesProvider).getString('tempNewPost');
      if (tempNewPost != null && tempNewPost.trim().isNotEmpty) {
        _controller.text = tempNewPost;
      }
      _controller.addListener(_saveTemp);
    }
    super.initState();
  }

  void _saveTemp() {
    t.cancel();
    t = Timer(const Duration(milliseconds: 1000), () {
      final sharedPreferences = ref.read(sharedPreferencesProvider);
      // because the files selected in the image picker are temporarily saved
      final onlyText = _controller.text
          .replaceAll(Regex.localImageRegex, '')
          .replaceAll(Regex.localVideoRegex, '');
      sharedPreferences.setString('tempNewPost', onlyText);
    });
  }

  Future<void> buildLongContent() async {
    try {
      hasPostContent = true;
      final postContent =
          await ref.read(postContentFutureProvider(widget.postId!).future);
      _controller.text = postContent?.content ?? '';
      currentCategory = postContent?.category ?? 0;
      setState(() {});
      _remoteMedia = buildRemoteMedia(_controller.text);
    } catch (e) {
      debugPrint('buildLongContent: ${e.toString()}');
    }
  }

  Future<void> buildCurrentPost() async {
    try {
      final currentPost =
          await ref.read(postFutureProvider(widget.postId!).future);
      if (currentPost != null && currentPost.isLongContent) {
        buildLongContent();
      } else {
        _controller.text = currentPost?.content ?? '';
        currentCategory = currentPost?.category ?? 0;
        setState(() {});
        _remoteMedia = buildRemoteMedia(_controller.text);
      }
    } catch (e) {
      debugPrint('buildCurrentPost: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    t.cancel();
    if (widget.postId == null) {
      _controller.removeListener(_saveTemp);
    }
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _buildAppBarTitle(BuildContext context) => widget.postId == null
      ? context.loc.writeAppBarTitle
      : context.loc.editAppBarTitle;

  List<TabTitle> _buildTabTitles(BuildContext context) {
    return [
      TabTitle(title: context.loc.editor),
      TabTitle(title: context.loc.preview),
    ];
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(editorScreenControllerProvider, (_, state) {
      state.showAlertDialogOnError(context, content: state.error.toString());
    });

    final isLoading = ref.watch(editorScreenControllerProvider).isLoading;
    final uploadState = ref.watch(uploadProgressStateProvider);

    final screenWidth = MediaQuery.sizeOf(context).width;
    final tabTitles = _buildTabTitles(context);

    return DefaultTabController(
      length: tabTitles.length,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: kIsWeb ? false : true,
          leading: kIsWeb ? const WebBackButton() : null,
          title: Text(_buildAppBarTitle(context)),
        ),
        body: Column(
          children: [
            IgnorePointer(
              ignoring: screenWidth < widthBreak ? false : true,
              child: TabBar(
                physics: const NeverScrollableScrollPhysics(),
                tabs: tabTitles.map((e) => Tab(text: e.title)).toList(),
                onTap: (value) {
                  if (value == 1) {
                    FocusScope.of(context).unfocus();
                  }
                },
              ),
            ),
            if (screenWidth < widthBreak)
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    EditorField(
                      controller: _controller,
                      focusNode: _focusNode,
                    ),
                    MarkdownField(
                      controller: _controller,
                    ),
                  ],
                ),
              ),
            if (screenWidth >= widthBreak)
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Expanded(
                            child: EditorField(
                              controller: _controller,
                              focusNode: _focusNode,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const VerticalDivider(),
                    Expanded(
                      flex: 1,
                      child: MarkdownField(
                        controller: _controller,
                      ),
                    ),
                  ],
                ),
              ),
            const Divider(),
            EditorBottomBar(
              bottomBarHeight: bottomBarHeight,
              getMedia: _getMedia,
              controller: _controller,
              postId: widget.postId,
              catetory: currentCategory,
              hasPostContent: hasPostContent,
              remoteMedia: _remoteMedia,
              writer: widget.postAndWriter?.writer,
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: isLoading
            ? Center(
                child: PercentCircularIndicator(
                  strokeWidth: 8,
                  percentage: uploadState.percentage,
                  index: uploadState.index,
                ),
              )
            : null,
      ),
    );
  }

  Future<void> _getMedia(
      {bool isMedia = false,
      bool isVideo = false,
      required double mediaMaxMBSize}) async {
    final text = _controller.text;
    final selection = _controller.selection;
    final start = selection.start;
    final end = selection.end;

    final isThumbnail = start > 1 &&
        end + 1 < text.length &&
        text[start - 1] == r'[' &&
        text[start - 2] == r']' &&
        text[end] == r']' &&
        text[end + 1] == r'[';

    final XFile? pickedFile = await showImagePicker(
      isMedia: isThumbnail ? false : isMedia,
      isVideo: isThumbnail ? false : isVideo,
      maxWidth: postImageMaxWidth,
      imageQuality: postImageQuality,
      mediaMaxMBSize: mediaMaxMBSize,
    ).catchError((error) {
      debugPrint('showImagePicker: ${error.toString()}');
      if (mounted) {
        showAdaptiveAlertDialog(
            context: context,
            title: context.loc.maxFileSizeErrorTitle,
            content:
                '${context.loc.maxFileSizedErrorContent} (${mediaMaxMBSize}MB)');
      }
      return null;
    });

    if (pickedFile != null) {
      setState(
        () {
          final mediaType = lookupMimeType(pickedFile.path);
          // dev.log('mediaType: $mediaType');
          if (mediaType == null) {
            isVideo = isVideo;
          } else {
            isVideo = mediaType == contentTypeMp4 ||
                mediaType == contentTypeM4v ||
                mediaType == contentTypeWebm ||
                mediaType == contentTypeQv ||
                mediaType == contentTypeMp3 ||
                pickedFile.path.endsWith('.mp4') ||
                pickedFile.path.endsWith('.mp3') ||
                pickedFile.path.endsWith('.mov');
          }

          /*
          final inserted = isVideo
              ? '\n[localVideo][][${pickedFile.path}]\n'
              : '\n[localImage][${pickedFile.path}][]\n';
          */

          final inserted = isThumbnail
              ? pickedFile.path
              : isVideo
                  ? '\n[localVideo][][${pickedFile.path}]\n'
                  : '\n[localImage][${pickedFile.path}][]\n';

          final newText = text.replaceRange(
            start,
            end,
            inserted,
          );
          _controller.value = TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(
                offset: selection.baseOffset + inserted.length),
          );
          _focusNode.requestFocus();
        },
      );
    }
  }
}
