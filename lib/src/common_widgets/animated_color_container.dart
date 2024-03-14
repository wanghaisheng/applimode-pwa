import 'dart:math';

import 'package:applimode_app/env/env.dart';
import 'package:applimode_app/src/constants/color_palettes.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AnimatedColorContainer extends StatefulWidget {
  const AnimatedColorContainer({
    super.key,
    required this.child,
    this.millisecondes = colorAnimationDuration,
    this.isRepeat = true,
    this.storyImageUrl,
  });

  final Widget child;
  final int millisecondes;
  final bool isRepeat;
  final String? storyImageUrl;

  @override
  State<AnimatedColorContainer> createState() => _AnimatedColorContainerState();
}

class _AnimatedColorContainerState extends State<AnimatedColorContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animationOne;
  late Animation<Color?> _animationTwo;

  @override
  void initState() {
    super.initState();
    final colorCount = Random().nextInt(25);
    final firstColor = gradientColorPalettes[colorCount][0];
    final secondColor = gradientColorPalettes[colorCount][1];

    _controller = AnimationController(
      duration: Duration(milliseconds: widget.millisecondes),
      vsync: this,
    );

    _animationOne = ColorTween(begin: firstColor, end: secondColor).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutSine));
    _animationTwo = ColorTween(begin: secondColor, end: firstColor).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutSine));

    widget.isRepeat ? _controller.repeat(reverse: true) : _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SingleChildScrollView(
          child: Container(
            constraints:
                BoxConstraints(minHeight: MediaQuery.sizeOf(context).height),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              gradient: widget.storyImageUrl != null
                  ? null
                  : LinearGradient(
                      // stops: const [0.2, 0.6],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [_animationOne.value!, _animationTwo.value!],
                    ),
              image: widget.storyImageUrl == null
                  ? null
                  : DecorationImage(
                      image: CachedNetworkImageProvider(
                        widget.storyImageUrl!,
                        headers: useRTwoSecureGet
                            ? {
                                "X-Custom-Auth-Key": Env.workerKey,
                              }
                            : null,
                      ),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) =>
                          debugPrint(exception.toString()),
                    ),
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}
