import 'dart:math';
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:flutter/material.dart';

class AnimatedColorBox extends StatefulWidget {
  const AnimatedColorBox({
    super.key,
    this.index,
    this.child,
    this.millisecondes = colorAnimationDuration,
    this.isRepeat = true,
  });

  final int? index;
  final Widget? child;
  final int millisecondes;
  final bool isRepeat;

  @override
  State<AnimatedColorBox> createState() => _AnimatedColorBoxState();
}

class _AnimatedColorBoxState extends State<AnimatedColorBox>
    with SingleTickerProviderStateMixin {
  late Color singleColor;
  late AnimationController _controller;
  late Animation<Color?> _animationOne;
  late Animation<Color?> _animationTwo;
  late Color firstColor;
  late Color secondColor;

  @override
  void initState() {
    super.initState();
    final hasIndex = widget.index != null;
    final singleColorCount = hasIndex
        ? widget.index! % boxSingleColors.length
        : Random().nextInt(boxSingleColors.length);
    final gradientColorCount = hasIndex
        ? widget.index! % boxGradientColors.length
        : Random().nextInt(boxGradientColors.length);
    singleColor = boxSingleColors[singleColorCount];
    firstColor = boxGradientColors[gradientColorCount][0];
    secondColor = boxGradientColors[gradientColorCount][1];

    if (boxColorType == BoxColorType.animation) {
      _controller = AnimationController(
        duration: Duration(milliseconds: widget.millisecondes),
        vsync: this,
      );

      _animationOne = ColorTween(begin: firstColor, end: secondColor).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOutSine));
      _animationTwo = ColorTween(begin: secondColor, end: firstColor).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOutSine));

      widget.isRepeat
          ? _controller.repeat(reverse: true)
          : _controller.forward();
    }
  }

  @override
  void dispose() {
    if (boxColorType == BoxColorType.animation) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (boxColorType == BoxColorType.animation) {
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              gradient: LinearGradient(
                // stops: const [0.2, 0.6],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_animationOne.value!, _animationTwo.value!],
              ),
            ),
            child: Center(child: widget.child),
          );
        },
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: singleColor,
        gradient: boxColorType == BoxColorType.gradient
            ? LinearGradient(
                // stops: const [0.2, 0.6],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [firstColor, secondColor],
              )
            : null,
      ),
      child: Center(child: widget.child),
    );
  }
}
