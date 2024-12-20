import 'package:flutter/material.dart';

class FadeInWidget extends StatefulWidget {
  const FadeInWidget({
    super.key,
    required this.child,
    this.millisecondes = 1000,
    this.isRepeat = false,
  });

  final Widget child;
  final int millisecondes;
  final bool isRepeat;

  @override
  State<FadeInWidget> createState() => _FadeInWidgetState();
}

class _FadeInWidgetState extends State<FadeInWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.millisecondes),
      vsync: this,
    );
    if (_controller != null) {
      _animation = CurvedAnimation(
        parent: _controller!,
        curve: Curves.easeIn,
      );
    }

    widget.isRepeat
        ? _controller?.repeat(reverse: true)
        : _controller?.forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _animation != null
        ? FadeTransition(
            opacity: _animation!,
            child: widget.child,
          )
        : widget.child;
  }
}
