import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/utils/custom_headers.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CachedCircleImage extends StatelessWidget {
  const CachedCircleImage({
    super.key,
    required this.imageUrl,
    this.size,
  });

  final String imageUrl;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      httpHeaders: useRTwoSecureGet ? rTwoSecureHeader : null,
      width: size ?? profileSizeMedium,
      height: size ?? profileSizeMedium,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
          shape: BoxShape.circle,
        ),
      ),
      errorWidget: (context, url, error) => Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black12,
        ),
      ),
    );
  }
}
