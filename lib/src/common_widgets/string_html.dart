import 'package:applimode_app/src/common_widgets/image_widgets/error_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class StringHtml extends StatelessWidget {
  const StringHtml({super.key, required this.data});

  final String data;

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      data,
      onErrorBuilder: (context, element, error) => const ErrorImage(),
      onLoadingBuilder: (context, element, loadingProgress) =>
          const CupertinoActivityIndicator(),
    );
  }
}
