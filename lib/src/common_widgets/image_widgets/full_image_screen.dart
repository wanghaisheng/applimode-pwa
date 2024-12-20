import 'package:applimode_app/src/common_widgets/image_widgets/platform_network_image.dart';
import 'package:applimode_app/src/utils/custom_headers.dart';
import 'package:flutter/foundation.dart';
import 'package:applimode_app/src/common_widgets/buttons/icon_back_button.dart';
import 'package:applimode_app/custom_settings.dart';
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
  PageController? controller;

  @override
  void initState() {
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: urls != null && urls.isNotEmpty && currentIndex != null
          ? PageView(
              controller: controller,
              children: urls.map((url) => FullImageStack(url: url)).toList(),
            )
          : FullImageStack(url: widget.imageUrl),
    );
  }
}

class FullImageStack extends StatelessWidget {
  const FullImageStack({
    super.key,
    required this.url,
  });

  final String url;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: InteractiveViewer(
            child: PlatformNetworkImage(
              imageUrl: url,
              headers: useRTwoSecureGet ? rTwoSecureHeader : null,
              errorWidget: Container(color: Colors.black),
            ),
            /*
            child: CachedNetworkImage(
              imageUrl: url,
              httpHeaders: useRTwoSecureGet ? rTwoSecureHeader : null,
            ),
            */
          ),
        ),
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
