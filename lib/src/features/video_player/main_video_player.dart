import 'package:applimode_app/src/app_settings/app_settings_controller.dart';
import 'package:applimode_app/src/common_widgets/image_widgets/platform_network_image.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/video_player/video_player_components/video_gesture_detector.dart';
import 'package:applimode_app/src/features/video_player/video_player_components/video_player_center_icon.dart';
import 'package:applimode_app/src/features/video_player/video_player_components/video_progress_bar.dart';
import 'package:applimode_app/src/features/video_player/video_player_components/video_volume_button.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/custom_headers.dart';
import 'package:applimode_app/src/utils/posts_item_mute_state.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/utils/posts_item_playing_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class MainVideoPlayer extends ConsumerStatefulWidget {
  const MainVideoPlayer({
    super.key,
    required this.videoUrl,
    this.videoImageUrl,
    this.aspectRatio,
    this.writer,
    this.post,
    this.index,
    this.isPage = false,
    this.showVideoTitle = true,
  });

  final String videoUrl;
  final String? videoImageUrl;
  final double? aspectRatio;
  final AppUser? writer;
  final Post? post;
  final int? index;
  final bool isPage;
  final bool showVideoTitle;

  @override
  ConsumerState<MainVideoPlayer> createState() => _MainVideoPlayerState();
}

class _MainVideoPlayerState extends ConsumerState<MainVideoPlayer> {
  late VideoPlayerController _controller;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
      httpHeaders: useRTwoSecureGet ? rTwoSecureHeader : const {},
    );
    _controller.addListener(_setState);
    final isMute = ref.read(postsItemMuteStateProvider);
    // _controller.setLooping(true);
    if (isMute) {
      _controller.setVolume(0.0);
    }
    if (widget.videoImageUrl == null || widget.videoImageUrl!.isEmpty) {
      isLoading = true;
      setState(() {});
      _controller.initialize().then((value) {
        isLoading = false;
        setState(() {});
      }, onError: (e) => debugPrint('videoInit: ${e.toString()}'));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    WakelockPlus.disable();
    _controller.removeListener(_setState);
    super.dispose();
  }

  void _setState() {
    setState(() {
      if (_controller.value.isPlaying) {
        WakelockPlus.enable();
      }
      if (!_controller.value.isPlaying) {
        WakelockPlus.disable();
      }
    });
  }

  Future<void> _initializeVideo() async {
    isLoading = true;
    setState(() {});
    _controller.initialize().then((value) {
      isLoading = false;
      setState(() {});
    }, onError: (e) => debugPrint('videoInit: ${e.toString()}'));
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    final appSetting = ref.watch(appSettingsControllerProvider);
    final adminSettings = ref.watch(adminSettingsProvider);
    ref.listen(postsItemPlayingStateProvider, (_, next) {
      if (next == false) {
        _controller.pause();
      }
    });
    return AspectRatio(
      aspectRatio: widget.aspectRatio ?? 1.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.videoImageUrl != null &&
              !_controller.value.isInitialized) ...[
            /*
            Positioned.fill(
              child: Container(
                color: Colors.black,
              ),
            ),
            */
            Positioned.fill(
              child: PlatformNetworkImage(
                imageUrl: widget.videoImageUrl!,
                headers: useRTwoSecureGet ? rTwoSecureHeader : null,
                fit: BoxFit.cover,
                errorWidget: Container(
                  color: Colors.black,
                ),
              ),
              /*
              child: CachedNetworkImage(
                imageUrl: widget.videoImageUrl!,
                httpHeaders: useRTwoSecureGet ? rTwoSecureHeader : null,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) {
                  return Container(
                    color: Colors.black,
                  );
                },
              ),
              */
            ),
            /*
            Positioned.fill(
              child: Container(
                color: Colors.black12,
              ),
            ),
            */
            if (!isLoading)
              IconButton(
                onPressed: _initializeVideo,
                icon: const Icon(Icons.play_arrow),
                iconSize: 80,
                color: Colors.white70,
              ),
            if (isLoading)
              const CupertinoActivityIndicator(
                color: Colors.white,
              ),
          ],
          // Positioned.fill(child: Container(color: Colors.black)),
          if (_controller.value.hasError)
            Positioned.fill(
              child: Container(
                color: Colors.black,
                child: Center(
                  child: Text(
                    context.loc.videoNotFound,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          if (_controller.value.isInitialized &&
              !_controller.value.hasError) ...[
            /*
            Positioned.fill(
              child: Container(
                color: Colors.black,
              ),
            ),
            */
            AspectRatio(
              aspectRatio: widget.aspectRatio ?? 1.0,
              child: FittedBox(
                clipBehavior: Clip.hardEdge,
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
            /*
            if (!_controller.value.isPlaying)
              Positioned.fill(
                child: Container(
                  color: Colors.black26,
                ),
              ),
              */
            if (isLoading ||
                _controller.value.isBuffering && !_controller.value.isCompleted)
              const Align(
                alignment: Alignment.center,
                child: CupertinoActivityIndicator(color: Colors.white),
              ),
            if (!_controller.value.isPlaying) const VideoPlayerCenterIcon(),
            VideoPlayerGestureDetector(
              controller: _controller,
            ),
            SafeArea(
              child: VideoVolumeButton(
                padding: widget.post != null &&
                        widget.post!.isHeader &&
                        (adminSettings.showAppStyleOption
                            ? appSetting.appStyle != 2
                            : adminSettings.postsListType != PostsListType.page)
                    ? const EdgeInsets.only(top: 64, left: 8)
                    : const EdgeInsets.only(top: 12, left: 8),
                controller: _controller,
              ),
            ),
            SafeArea(child: VideoProgressBar(controller: _controller)),
          ],
          /*
          if (widget.writer != null && widget.post != null)
            VideoContents(
              controller: _controller,
              post: widget.post!,
              writer: widget.writer!,
              index: widget.index,
              isPage: widget.isPage,
              showVideoTitle: widget.showVideoTitle,
            ),
          */
        ],
      ),
    );
  }
}
