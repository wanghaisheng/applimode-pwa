import 'dart:io';

import 'package:applimode_app/src/common_widgets/image_widgets/cached_padding_image.dart';
import 'package:applimode_app/src/common_widgets/image_widgets/file_padding_image.dart';
import 'package:applimode_app/src/common_widgets/string_html.dart';
import 'package:applimode_app/src/common_widgets/string_markdown.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/video_player/post_video_player.dart';
import 'package:applimode_app/src/utils/regex.dart';
import 'package:applimode_app/src/utils/url_converter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StringConverter {
  const StringConverter();

  static bool isYoutube(String content) {
    return content.contains(Regex.ytRegexB);
  }

  static bool isIframe(String content) {
    return content.contains(Regex.iframeRegex);
  }

  static bool isYoutubeOrIframe(String content) {
    return content.contains(Regex.ytRegexB) ||
        content.contains(Regex.iframeRegex);
  }

  static String buildYtIf(String videoId) {
    return '$splitTag<iframe width="560" height="315" src="https://www.youtube.com/embed/$videoId" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>$splitTag';
  }

  static String buildYtIfWithoutSplit(String videoId) {
    return '<iframe width="560" height="315" src="https://www.youtube.com/embed/$videoId" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>';
  }

  static String buildYtThumbnail(String videoId) {
    // maxresdefault (1280), sddefault (640), hqdefault (480), mqdefault (320), default (120)
    return 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
  }

  static String buildYtProxyThumbnail(String videoId) {
    // maxresdefault (1280), sddefault (640), hqdefault (480), mqdefault (320), default (120)
    return 'https://yt-thumbnail-worker.jongsukoh80.workers.dev/?q=https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
  }

  static String buildYtUrl(String videoId) {
    return 'https://www.youtube.com/watch?v=$videoId';
  }

  static String buildInstaIf(String instaUrl) {
    return '$splitTag<iframe src="${instaUrl}embed" width="400" scrolling="auto" frameborder="0"></iframe>$splitTag';
  }

  static String buildIf(String iframe) {
    return '$splitTag$iframe$splitTag';
  }

  static List<Widget> _splitsToElements({
    required List<String> splits,
    String? postId,
  }) {
    final List<Widget> elements = [];
    final List<String> imageUrlsList = [];

    // for image page view
    for (String split in splits) {
      if (split.contains(Regex.remoteImageRegex)) {
        imageUrlsList.add(Regex.remoteImageRegex.firstMatch(split)![1]!);
      } else if (split.contains(Regex.webImageRegex)) {
        imageUrlsList.add(Regex.webImageRegex.firstMatch(split)![1]!);
      }
    }

    for (String split in splits) {
      if (split.contains(Regex.ytIframeRegex)) {
        // youtube
        elements.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: StringHtml(data: split),
        ));
      } else if (split.contains(Regex.localImageRegex)) {
        if (kIsWeb) {
          // local image for web
          elements.add(CachedPaddingImage(
            imageUrl: Regex.localImageRegex.firstMatch(split)![1]!,
            vPadding: 12,
            postId: postId,
          ));
        } else {
          // local image for mobile
          elements.add(FilePaddingImage(
            file: File(Regex.localImageRegex.firstMatch(split)![1]!),
            vPadding: 12,
          ));
        }
      } else if (split.contains(Regex.localVideoRegex)) {
        // local video
        elements.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: PostVideoPlayer(
            videoUrl:
                getIosWebVideoUrl(Regex.localVideoRegex.firstMatch(split)![2]!),
            isIosLocal: kIsWeb ? false : Platform.isIOS,
          ),
        ));
      } else if (split.contains(Regex.remoteImageRegex)) {
        // remote image
        final imageUrl = Regex.remoteImageRegex.firstMatch(split)![1]!;
        elements.add(CachedPaddingImage(
          imageUrl: imageUrl,
          vPadding: 12,
          postId: postId,
          imageUrlsList: imageUrlsList,
          currentIndex: imageUrlsList.indexOf(imageUrl),
        ));
      } else if (split.contains(Regex.remoteVideoRegex)) {
        // remote video
        elements.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: PostVideoPlayer(
            videoUrl: Regex.remoteVideoRegex.firstMatch(split)![2]!,
            videoImageUrl: Regex.remoteVideoRegex.firstMatch(split)![1],
          ),
        ));
      } else if (split.contains(Regex.webImageRegex)) {
        final imageUrl = Regex.webImageRegex.firstMatch(split)![1]!;
        // web image
        elements.add(CachedPaddingImage(
          imageUrl: imageUrl,
          vPadding: 12,
          postId: postId,
          imageUrlsList: imageUrlsList,
          currentIndex: imageUrlsList.indexOf(imageUrl),
        ));
      } else if (split.contains(Regex.webVideoRegex)) {
        // web video
        elements.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: PostVideoPlayer(
            videoUrl:
                getIosWebVideoUrl(Regex.webVideoRegex.firstMatch(split)![2]!),
            videoImageUrl: Regex.webVideoRegex.firstMatch(split)![1],
          ),
        ));
      } else if (split.contains(Regex.instaIframeRegex)) {
        // insta
        elements.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: StringHtml(data: split),
        ));
      } else {
        // markdown
        elements.add(StringMarkdown(
          data: split,
          shrinkWrap: true,
        ));
      }
    }
    return elements;
  }

  static List<Widget> stringToElements({
    required String content,
    String? postId,
  }) {
    final splits = content
        // youtube url and iframe
        .replaceAllMapped(Regex.ytRegexB, (match) => buildYtIf(match[1]!))
        // local image
        .replaceAllMapped(
            Regex.localImageRegex, (match) => '$splitTag${match[0]}$splitTag')
        // local video
        .replaceAllMapped(
            Regex.localVideoRegex, (match) => '$splitTag${match[0]}$splitTag')
        // remote image
        .replaceAllMapped(
            Regex.remoteImageRegex, (match) => '$splitTag${match[0]}$splitTag')
        // remote video
        .replaceAllMapped(
            Regex.remoteVideoRegex, (match) => '$splitTag${match[0]}$splitTag')
        // web image
        .replaceAllMapped(
            Regex.webImageRegex, (match) => '$splitTag${match[0]}$splitTag')
        // web video
        .replaceAllMapped(
            Regex.webVideoRegex, (match) => '$splitTag${match[0]}$splitTag')
        // instagram
        .replaceAllMapped(Regex.instaRegex, (match) => buildInstaIf(match[0]!))
        // get split list
        .split(splitTag);
    return _splitsToElements(splits: splits, postId: postId);
  }

  static String toTitle(String content) {
    return content
        .replaceAll(Regex.remoteRegex, '')
        .replaceAll(Regex.iframeRegex, '')
        .replaceAll(Regex.urlWithHttp, '')
        .replaceAll(Regex.urlWithoutHttp, '')
        .replaceAll(RegExp(r'\#|\~|\*|!\[.*\]\(.*\)'), '')
        // .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'\n+\s+'), '\n')
        .trim();
  }

  static String toSearch(String content) {
    String searchString = '';
    final preProcess = content
        .replaceAll(Regex.remoteRegex, '')
        .replaceAll(Regex.iframeRegex, '')
        .replaceAll(Regex.urlWithHttp, '')
        .replaceAll(Regex.urlWithoutHttp, '')
        .replaceAll(Regex.searchRegex, '')
        .toLowerCase()
        .replaceAll('\n', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    final wordsList = preProcess.split(' ');
    for (final word in wordsList) {
      if (word.length > 1 && !searchString.contains(word)) {
        searchString += '$word ';
      }
    }
    return searchString.trim();
  }
}
