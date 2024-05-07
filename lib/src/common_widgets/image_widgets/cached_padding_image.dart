import 'package:applimode_app/src/utils/custom_headers.dart';
import 'package:go_router/go_router.dart';
import 'package:applimode_app/src/common_widgets/image_widgets/error_image.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/utils/multi_images.dart';

class CachedPaddingImage extends StatelessWidget {
  const CachedPaddingImage({
    super.key,
    required this.imageUrl,
    this.hPadding = 0.0,
    this.vPadding = 0.0,
    this.width,
    this.height,
    this.errorHeight = 120.0,
    this.postId,
    this.imageUrlsList,
    this.currentIndex,
  });

  final String imageUrl;
  final double hPadding;
  final double vPadding;
  final double? width;
  final double? height;
  final double errorHeight;
  final String? postId;
  final List<String>? imageUrlsList;
  final int? currentIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
      child: InkWell(
        onTap: postId != null
            ? () => context.push(
                  ScreenPaths.image(imageUrl),
                  extra: MultiImages(
                    imageUrl: imageUrl,
                    imageUrlsList: imageUrlsList,
                    currentIndex: currentIndex,
                  ),
                )
            : null,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          httpHeaders: useRTwoSecureGet ? rTwoSecureHeader : null,
          width: width,
          height: height,
          errorWidget: (context, url, error) => ErrorImage(
            hPadding: hPadding,
            vPadding: vPadding,
            height: errorHeight,
          ),
        ),
      ),
    );
  }
}
