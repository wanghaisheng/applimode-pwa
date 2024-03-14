import 'package:applimode_app/src/features/video_player/basic_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullVideoScreen extends StatelessWidget {
  const FullVideoScreen({
    super.key,
    required this.videoUrl,
    this.videoController,
  });

  final String videoUrl;
  final VideoPlayerController? videoController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: BasicVideoPlayer(
          videoUrl: videoUrl,
          videoController: videoController,
        ),
      ),
    );
  }
}
