import 'package:flutter/material.dart';

class LazyLoadingWidget extends StatelessWidget {
  const LazyLoadingWidget({
    super.key,
    this.lazyDuration = 400,
    required this.child,
    this.loadingWidget = const SizedBox.shrink(),
  });

  final int lazyDuration;
  final Widget child;
  final Widget loadingWidget;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future(() async {
        await Future.delayed(Duration(milliseconds: lazyDuration));
        return child;
      }),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.requireData;
        }
        return loadingWidget;
      },
    );
  }
}
