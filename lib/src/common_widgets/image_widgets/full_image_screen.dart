import 'package:applimode_app/src/utils/custom_headers.dart';
import 'package:flutter/foundation.dart';
import 'package:applimode_app/src/common_widgets/buttons/icon_back_button.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:applimode_app/src/common_widgets/web_back_button.dart';

class FullImageScreen extends StatefulWidget {
  const FullImageScreen({
    super.key,
    required this.imageUrl,
    this.imageUrlsList,
    this.currentIndex,
  });

  final String imageUrl;
  final List<String>? imageUrlsList;
  final int? currentIndex;

  @override
  State<FullImageScreen> createState() => _FullImageScreenState();
}

class _FullImageScreenState extends State<FullImageScreen> {
  late bool showOverlay;
  late PageController? controller;

  @override
  void initState() {
    showOverlay = false;
    if (widget.currentIndex != null && widget.imageUrlsList != null) {
      controller = PageController(initialPage: widget.currentIndex!);
    }
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final urls = widget.imageUrlsList;
    final currentIndex = widget.currentIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          showOverlay = !showOverlay;
        });
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: urls != null && urls.isNotEmpty && currentIndex != null
            ? PageView(
                controller: controller,
                children: urls
                    .map((url) =>
                        FullImageStack(url: url, showOverlay: showOverlay))
                    .toList(),
              )
            : FullImageStack(url: widget.imageUrl, showOverlay: showOverlay),
      ),
    );
  }
}

class FullImageStack extends StatelessWidget {
  const FullImageStack({
    super.key,
    required this.url,
    required this.showOverlay,
  });

  final String url;
  final bool showOverlay;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: InteractiveViewer(
            child: CachedNetworkImage(
              imageUrl: url,
              httpHeaders: useRTwoSecureGet ? rTwoSecureHeader : null,
            ),
          ),
        ),
        // if (showOverlay && !kIsWeb)
        const Positioned(
          top: 12,
          left: 12,
          child: SafeArea(
            child: kIsWeb
                ? WebBackButton(color: Colors.white)
                : IconBackButton(
                    color: Colors.white,
                  ),
          ),
        )
      ],
    );
  }
}
