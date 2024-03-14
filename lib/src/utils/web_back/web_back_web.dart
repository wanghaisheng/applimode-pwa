// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:applimode_app/src/utils/web_back/web_back_stub.dart';

WebBackStub getInstance() => WebBackWeb();

/// A web implementation of the VideoThumbnailPlatform of the VideoThumbnail plugin.
class WebBackWeb implements WebBackStub {
  WebBackWeb();

  @override
  void back() {
    window.history.back();
  }
}
