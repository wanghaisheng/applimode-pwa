/*
import 'package:applimode_app/src/common_widgets/image_widgets/error_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_webview/fwfh_webview.dart';

class StringHtml extends StatelessWidget {
  const StringHtml({super.key, required this.data});

  final String data;

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      data,
      factoryBuilder: () => MyWidgetFactory(),
      onErrorBuilder: (context, element, error) => const ErrorImage(),
      onLoadingBuilder: (context, element, loadingProgress) =>
          const CupertinoActivityIndicator(),
    );
  }
}

class MyWidgetFactory extends WidgetFactory with WebViewFactory {}
*/
