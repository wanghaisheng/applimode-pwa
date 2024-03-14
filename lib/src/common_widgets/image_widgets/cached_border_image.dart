import 'dart:math';

import 'package:applimode_app/env/env.dart';
import 'package:applimode_app/src/constants/color_palettes.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: hPadding ?? 0,
        vertical: vPadding ?? 0,
      ),
      child: CachedNetworkImage(
        imageUrl: imgUrl,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(borderRedius ?? cachedBorderImageRedius)),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              )),
        ),
        httpHeaders: useRTwoSecureGet
            ? {
                "X-Custom-Auth-Key": Env.workerKey,
              }
            : null,
        width: width ?? cachedBorderImageSize,
        height: height ?? cachedBorderImageSize,
        errorWidget: (context, url, error) => Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(borderRedius ?? cachedBorderImageRedius)),
              color: index != null
                  ? pastelColorPalettes[index! % 24]
                  : pastelColorPalettes[
                      Random().nextInt(pastelColorPalettes.length)]),
        ),
        // fit: BoxFit.cover,
      ),
    );
  }
}
