import 'package:applimode_app/custom_settings.dart';

class Regex {
  static RegExp localImageRegex = RegExp(r'''\[localImage\]\[(.*)\]\[(.*)\]''');
  static RegExp localVideoRegex = RegExp(r'''\[localVideo\]\[(.*)\]\[(.*)\]''');
  static RegExp remoteImageRegex =
      RegExp(r'''\[remoteImage\]\[(.*)\]\[(.*)\]''');
  static RegExp remoteVideoRegex =
      RegExp(r'''\[remoteVideo\]\[(.*)\]\[(.*)\]''');
  static RegExp remoteRegex = RegExp(r'''\[.*\]\[(.*)\]\[(.*)\]''');
  static RegExp webImageRegex = RegExp(r'''\[image\]\[(.*)\]\[(.*)\]''');
  static RegExp webVideoRegex = RegExp(r'''\[video\]\[(.*)\]\[(.*)\]''');
  /*
  static RegExp webImageRegex = RegExp(
      r'''(?:https:\/\/)(?:[\/|.|\w|\s|-])*\.(?:jpg|jpeg|gif|png|webp)(\?[^\s[",><]*)?''');
  static RegExp webVideoRegex =
      RegExp(r'''(?:https:\/\/)(?:[\/|.|\w|\s|-])*\.(?:mp4)(\?[^\s[",><]*)?''');
      */

  static RegExp ytIframeRegex = RegExp(
      r'<iframe(?:\b|_).*?(?:\b|_)src=\"https:\/\/www.youtube.com\/(?:\b|_).*?(?:\b|_)iframe>');
  static RegExp ytIdRegex = RegExp(
      r'''(youtu\.be\/|youtube\.com\/(watch\?(.*&)?v=|(embed|v)\/))([^\?&"'>]+)''');
  static RegExp ytIdRegexB = RegExp(
      r'''(?:youtu\.be\/|youtube\.com\/(?:watch\?(?:.*&)?v=|(?:embed|v)\/))([^\?&"'>]+)''');
  static RegExp ytRegexA = RegExp(
      r'''(?:https?://|//)?(?:www\.|m\.|.+\.)?(?:youtu\.be/|youtube\.com/(?:embed/|v/|shorts/|feeds/api/videos/|watch\?v=|watch\?.+&v=))([\w-]{11})(?![\w-])''');
  static RegExp ytRegexB = RegExp(
      r'''(?:https?:\/\/|\/\/)?(?:www\.|m\.|.+\.)?(?:youtu\.be\/|youtube\.com\/(?:embed\/|v\/|shorts\/|live\/|feeds\/api\/videos\/|watch\?v=|watch\?.+&v=))([\w-]{11})(?![\w-])(?:.*)''');

  static RegExp iframeRegex =
      RegExp(r'''<iframe[^>]*src=[\"|']([^'\"]+)[\"|'][^>]*>''');
  static RegExp instaRegex = RegExp(
      r'''(?:https?:\/\/)?(?:www.)?instagram.com\/?(?:[a-zA-Z0-9\.\_\-]+)?\/(?:[p]+)?(?:[reel]+)?(?:[tv]+)?(?:[stories]+)?\/([a-zA-Z0-9\-\_\.]+)\/?([0-9]+)?''');
  static RegExp instaIframeRegex = RegExp(
      r'''<iframe(?:\b|_).*?(?:\b|_)src=\"(https:\/\/www.instagram.com\/.*\/)embed(?:\b|_).*?(?:\b|_)iframe>''');

  static RegExp hexColorRegex = RegExp(r'''([A-Fa-f0-9]{6})''');
  static RegExp hashtagRegex =
      RegExp(r'''(?:#)([^\s!@#$%^&*()=+.\/,\[{\]};:'"?><]+)''');
  static RegExp emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w-]{2,6}$');

  static RegExp urlWithHttp = RegExp(
      r'''https?:\/\/(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)''');
  static RegExp urlWithoutHttp = RegExp(
      '''[-a-zA-Z0-9@:%._+~#=]{1,256}.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_+.~#?&//=]*)''');

  static RegExp searchRegex = RegExp(searchRegExp);

  // old version
  static RegExp markDownImageRegex = RegExp(r'!\[(.*)\]\((.+)\)');
  static RegExp markDownUserImageRegex =
      RegExp(r'!\[(userUploadImage.*)\]\((.+)\)');
  static RegExp markDownRemoteImageRegex =
      RegExp(r'!\[(remoteUploadImage.*)\]\((.+)\)');
  static RegExp markDownUserVideoRegex =
      RegExp(r'!\[(userUploadVideo.*)\]\((.+)\)');
  static RegExp markDownRemoteVideoRegex =
      RegExp(r'!\[(remoteUploadVideo.*)\]\((.+)\)');
  static RegExp webImageRegexA = RegExp(
      r'''(?:https:\/\/)(?:[\/|.|\w|\s|-])*\.(?:jpg|jpeg|gif|png|webp)(\?[^\s[",><]*)?''');
  static RegExp webImageRegexB = RegExp(
      r'''(https:\/\/)([^\s(["<,>]*)(\/)[^\s[",><]*(.png|.jpg|.jpeg|.gif|.webp)(\?[^\s[",><]*)?''');
  static RegExp webVideoRegexA =
      RegExp(r'''(?:https:\/\/)(?:[\/|.|\w|\s|-])*\.(?:mp4)(\?[^\s[",><]*)?''');
}
