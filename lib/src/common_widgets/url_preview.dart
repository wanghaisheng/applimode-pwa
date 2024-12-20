/*
import 'dart:developer' as dev;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:applimode_app/src/common_widgets/image_widgets/cached_border_image.dart';
import 'package:applimode_app/src/utils/empty_string.dart';

class UrlPreview extends StatelessWidget {
  const UrlPreview({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PreviewData>(
      future: fetchPreviewData(url),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (snapshot.hasData) {
          final previewData = snapshot.data;
          final isEmptyData = previewData == null || previewData.title == null;
          if (isEmptyData) {
            return _buildUrlLink();
          }

          return Card(
              margin: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  if (!emptyString(previewData.imageUrl))
                    CachedBorderImage(
                      imgUrl: previewData.imageUrl!,
                    ),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Column(
                    children: [
                      if (emptyString(previewData.domain))
                        Text(previewData.domain!),
                      Text(previewData.url),
                    ],
                  ))
                ],
              ));
        } else {
          return _buildUrlLink();
        }
      },
    );
  }

  Widget _buildUrlLink() {
    return Text(url);
  }
}

// PreviewData Class
class PreviewData {
  final String url;
  final String? domain;
  final String? title;
  final String? description;
  final String? imageUrl;

  PreviewData({
    required this.url,
    this.domain,
    this.title,
    this.description,
    this.imageUrl,
  });
}

/// the function to get the PreviceData
Future<PreviewData> fetchPreviewData(String url) async {
  try {
    final uri = Uri.parse(url);
    final response = await http.get(uri).timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      final document = parser.parse(response.body);
      final metaTags = document.getElementsByTagName('meta');

      final domain = uri.host;

      String? title;
      String? description;
      String? imageUrl;

      // Open Graph
      for (var tag in metaTags) {
        final property = tag.attributes['property'] ?? '';
        final content = tag.attributes['content'] ?? '';

        if (property == 'og:title') title = content;
        if (property == 'og:description') description = content;
        if (property == 'og:image') imageUrl = content;
      }

      // Twitter Card
      for (var tag in metaTags) {
        final name = tag.attributes['name'] ?? '';
        final content = tag.attributes['content'] ?? '';

        if (title == null && name == 'twitter:title') title = content;
        if (description == null && name == 'twitter:description') {
          description = content;
        }
        if (imageUrl == null && name == 'twitter:image') imageUrl = content;
      }

      // Page Title
      title ??= document.head?.querySelector('title')?.text;

      return PreviewData(
        url: url,
        domain: domain,
        title: title,
        description: description,
        imageUrl: imageUrl,
      );
    } else {
      dev.log('Failed to load URL');
      return PreviewData(url: url);
    }
  } catch (e) {
    dev.log('Error fetching metadata: $e');
    return PreviewData(url: url); // 빈 메타 데이터 반환
  }
}
*/
