import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/utils/custom_headers.dart';
import 'package:flutter/foundation.dart';
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
    // after watching memory consumption, decide to use clipoval and cacheWidth
    return Container(
      width: size ?? profileSizeMedium,
      height: size ?? profileSizeMedium,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: kIsWeb
              ? NetworkImage(
                  imageUrl,
                  headers: useRTwoSecureGet ? rTwoSecureHeader : null,
                )
              : CachedNetworkImageProvider(
                  imageUrl,
                  headers: useRTwoSecureGet ? rTwoSecureHeader : null,
                ) as ImageProvider,
          fit: BoxFit.cover,
          onError: (exception, stackTrace) => debugPrint('image not found'),
        ),
        shape: BoxShape.circle,
      ),
    );
    /*
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
    */
  }
}
