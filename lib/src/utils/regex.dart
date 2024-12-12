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

  static RegExp webImageUrlRegex = RegExp(
    r'''^(?:https:\/\/)(?:[\/|.|\w|\-|\%])*\.(?:jpg|jpeg|gif|png|webp)(\?[^\s[\"\,\>\<]*)?$''',
    multiLine: true,
  );
  static RegExp webVideoUrlRegex = RegExp(
    r'''^(?:https:\/\/)(?:[\/|.|\w|\-|\%])*\.(?:mp4|webm)(\?[^\s\[\"\,\>\<]*)?$''',
    multiLine: true,
  );

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
  static RegExp ytImageRegex = RegExp(
      r'''(?:https?:\/\/|\/\/)?img\.youtube\.com\/vi\/([\w-]{11})\/(?:maxresdefault|sddefault|hqdefault|mqdefault|default)\.jpg''');

  static RegExp iframeRegex =
      RegExp(r'''<iframe[^>]*src=[\"|']([^'\"]+)[\"|'][^>]*>''');
  static RegExp instaRegex = RegExp(
      r'''(?:https?:\/\/)?(?:www.)?instagram.com\/?(?:[a-zA-Z0-9\.\_\-]+)?\/(?:[p]+)?(?:[reel]+)?(?:[tv]+)?(?:[stories]+)?\/([a-zA-Z0-9\-\_\.]+)\/?([0-9]+)?''');
  static RegExp instaIframeRegex = RegExp(
      r'''<iframe(?:\b|_).*?(?:\b|_)src=\"(https:\/\/www.instagram.com\/.*\/)embed(?:\b|_).*?(?:\b|_)iframe>''');

  static RegExp hexColorRegex = RegExp(r'''([A-Fa-f0-9]{6})''');
  static RegExp hashtagRegex =
      RegExp(r'''(?:#)([^\s!@#$%^&*()=+.\/,\[{\]};:'"?><]+)''');
  static RegExp hashtagLinkRegex =
      RegExp(r'''\B(?:#)([^\s!@#$%^&*()=+.\/,\[{\]};:'"?><]+)''');
  static RegExp emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w-]{2,6}$');

  static RegExp urlWithHttp = RegExp(
      r'''https?:\/\/(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)''');
  static RegExp urlWithoutHttp = RegExp(
      '''[-a-zA-Z0-9@:%._+~#=]{1,256}.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_+.~#?&//=]*)''');
  static RegExp urlForPreview = RegExp(
    r'^(https?:\/\/)' // scheme
    r'((?!\b(youtu|youtube)\b)[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}' // domain excluding youtube, youtu
    r'(:\d+)?' // port number
    r'(\/(?!.*\b(jpg|jpeg|gif|png|webp|mp4|webm)\b)\S*)?$', // path excluding media ext
    caseSensitive: false,
    multiLine: true,
  );

  static RegExp searchRegex = RegExp(r'[^\p{Letter}0-9\n ]', unicode: true);

  static RegExp urlPathStringRegex = RegExp('[^a-z0-9-]');

  static RegExp blackVideoImageFileName =
      RegExp(r'''posts\%2F(.*)-needupdate''');
  static RegExp firebaseObjectPath = RegExp(r'''\/o\/(.*)\?''');

  static RegExp blobRegex = RegExp(r'''blob:[\/|.|\w|\-|\%|\:]*''');

  // for blob media files on web
  static RegExp blobMediaRegex = RegExp(
      r'''(blob:[\/|.|\w|\-|\%|\:]*)\?(jpeg|jpg|png|gif|webp|mp4|mov|webm)''');

  // for media files with ext
  static RegExp mediaWithExtRegex =
      RegExp(r'''(.*)\?(jpeg|jpg|png|gif|webp|mp4|mov|webm)''');

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
}
