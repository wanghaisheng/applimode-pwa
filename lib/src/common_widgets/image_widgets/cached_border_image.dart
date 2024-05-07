import 'dart:math';

import 'package:applimode_app/src/constants/color_palettes.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/utils/custom_headers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CachedBorderImage extends StatelessWidget {
  const CachedBorderImage({
    super.key,
    required this.imgUrl,
    this.borderRedius,
    this.hPadding,
    this.vPadding,
    this.width,
    this.height,
    this.index,
  });

  final String imgUrl;
  final double? borderRedius;
  final double? hPadding;
  final double? vPadding;
  final double? width;
  final double? height;
  final int? index;

  @override
  Widget build(BuildContext context) {
    final deviceRatio = MediaQuery.of(context).devicePixelRatio;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: hPadding ?? 0,
        vertical: vPadding ?? 0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
            Radius.circular(borderRedius ?? cachedBorderImageRedius)),
        child: kIsWeb
            ? Image.network(
                imgUrl,
                fit: BoxFit.cover,
                width: width ?? cachedBorderImageSize,
                height: height ?? cachedBorderImageSize,
                cacheWidth:
                    ((width ?? cachedBorderImageSize) * deviceRatio).round(),
                headers: useRTwoSecureGet ? rTwoSecureHeader : null,
                errorBuilder: (context, url, error) => _buildErrorWidget(),
              )
            : CachedNetworkImage(
                imageUrl: imgUrl,
                fit: BoxFit.cover,
                width: width ?? cachedBorderImageSize,
                height: height ?? cachedBorderImageSize,
                memCacheWidth:
                    ((width ?? cachedBorderImageSize) * deviceRatio).round(),
                // memCacheHeight: 112,
                httpHeaders: useRTwoSecureGet ? rTwoSecureHeader : null,
                errorWidget: (context, url, error) => _buildErrorWidget()
                // fit: BoxFit.cover,
                ),
      ),
    );
  }

  Widget _buildErrorWidget() => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular(borderRedius ?? cachedBorderImageRedius)),
            color: index != null
                ? pastelColorPalettes[index! % 24]
                : pastelColorPalettes[
                    Random().nextInt(pastelColorPalettes.length)]),
      );
}
