import 'package:flutter/material.dart';

class VideoPlayerCenterIcon extends StatelessWidget {
  const VideoPlayerCenterIcon({
    super.key,
    this.iconData,
    this.size,
    this.color,
    this.semanticLabel,
  });

  final IconData? iconData;
  final double? size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        iconData ?? Icons.play_arrow,
        size: size ?? 80,
        color: color ?? Colors.white70,
        semanticLabel: semanticLabel,
      ),
    );
  }
}
