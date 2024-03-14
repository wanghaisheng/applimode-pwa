import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerGestureDetector extends StatelessWidget {
  const VideoPlayerGestureDetector({
    super.key,
    required this.controller,
  });

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (controller.value.isPlaying) {
          controller.pause();
        } else {
          controller.play();
        }
      },
    );
  }
}
