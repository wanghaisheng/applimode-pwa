import 'package:flutter/material.dart';

class VideoLoadingWidget extends StatelessWidget {
  const VideoLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: const Center(
          child: Icon(
            Icons.play_arrow,
            size: 80,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
