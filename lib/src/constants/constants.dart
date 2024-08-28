import 'package:flutter/material.dart';

// admin settings keys
const String homeBarTitleKey = 'homeBarTitle';
const String homeBarImageUrlKey = 'homeBarImageUrl';
const String homeBarStyleKey = 'homeBarStyle';
const String mainColorKey = 'mainColor';
const String mainCategoryKey = 'mainCategory';
const String adminSettingsModifiedTimeKey = 'adminSettingsModifiedTime';
const String showAppStyleOptionKey = 'showAppStyleOption';
const String postsListTypeKey = 'postsListType';
const String boxColorTypeKey = 'boxColorType';
const String mediaMaxMBSizeKey = 'mediaMaxMBSize';
const String useRecommendationKey = 'useRecommendation';
const String useRankingKey = 'useRanking';
const String useCategoryKey = 'useCategory';
const String showLogoutOnDrawerKey = 'showLogoutOnDrawer';
const String showLikeCountKey = 'showLikeCount';
const String showDislikeCountKey = 'showDislikeCount';
const String showCommentCountKey = 'showCommentCount';
const String showSumCountKey = 'showSumCount';
const String showCommentPlusLikeCountKey = 'showCommentPlusLikeCount';
const String isThumbUpToHeartKey = 'isThumbUpToHeart';
const String showUserAdminLabelKey = 'showUserAdminLabel';
const String showUserLikeCountKey = 'showUserLikeCount';
const String showUserDislikeCountKey = 'showUserDislikeCount';
const String showUserSumCountKey = 'showUserSumCount';

// media max sizes for admin settings
const List<double> mediaMaxMBSizesList = [
  5.0,
  10.0,
  50.0,
  100.0,
  150.0,
  200.0,
  250.0,
  300.0,
  350.0,
  400.0,
  450.0,
  500.0,
  550.0,
  600.0,
  650.0,
  700.0,
  750.0,
  800.0,
  850.0,
  900.0,
  950.0,
  1000.0,
];

// split tag in text to create widget. Dont touch.
// 절대 만지지 말 것. 변경 시 직접 코드 수정 필요
const String splitTag = '<split>';

const String noTitleTag = '#!title';
const String noWriterTag = '#!writer';

// firestore path
// 절대 만지지 말 것. 변경 시 직접 코드 수정 필요
const String postsPath = 'posts';
const String commentsPath = 'comments';

// storage path
// 절대 만지지 말 것. 변경 시 직접 코드 수정 필요
const String postPath = 'post';
const String profilePath = 'profile';
const String storyPath = 'story';
const String appBarTitlePath = 'title';

// mime type
// image
const String contentTypeJpeg = 'image/jpeg';
const String contentTypeGif = 'image/gif';
const String contentTypePng = 'image/png';
const String contentTypeWebp = 'image/webp';

// video
const String contentTypeMp4 = 'video/mp4';
const String contentTypeM4v = 'video/x-m4v';
const String contentTypeWebm = 'video/webm';
const String contentTypeQv = 'video/quicktime';

// audio
const String contentTypeMp3 = 'audio/mpeg';
const String contentTypeWave = 'audio/x-wav';

// text
const String contentTextPlain = 'text/plain';
const String contentTextHtml = 'text/html';
const String contentJson = 'application/json';

// id for a deleted or unknown user
const String deleted = 'deleted';
const String unknown = 'unknown';

const String firebaseStorageUrlHead = 'https://firebasestorage.googleapis.com';
const String gcpStorageUrlHead = 'https://storage.googleapis.com';

// no use. but we can use this file name when save a youtube thumbnail
const String youtubeThumbnailName = 'yt-thumbnail.jpeg';

// Used when the ranking screen fails to analyze the current year.
const int rankingCurrentYear = 2024;

const divider16 = Divider(
  indent: 16,
  endIndent: 16,
  thickness: 0,
);

// 메인화면 서랍의 디바이더 세팅
const divider24 = Divider(
  indent: 24,
  endIndent: 24,
  thickness: 0,
);
const zeroDivider16 = Divider(
  indent: 16,
  endIndent: 16,
  thickness: 0,
  height: 0,
);
const zeroDivider24 = Divider(
  indent: 24,
  endIndent: 24,
  thickness: 0,
  height: 0,
);

// colors for the color picker slide. don't change this.
const List<Color> colorPickerColors = [
  Color.fromARGB(255, 255, 0, 0),
  Color.fromARGB(255, 255, 128, 0),
  Color.fromARGB(255, 255, 255, 0),
  Color.fromARGB(255, 128, 255, 0),
  Color.fromARGB(255, 0, 255, 0),
  Color.fromARGB(255, 0, 255, 128),
  Color.fromARGB(255, 0, 255, 255),
  Color.fromARGB(255, 0, 128, 255),
  Color.fromARGB(255, 0, 0, 255),
  Color.fromARGB(255, 127, 0, 255),
  Color.fromARGB(255, 255, 0, 255),
  Color.fromARGB(255, 255, 0, 127),
  Color.fromARGB(255, 128, 128, 128),
];

// enum type
enum PostsListType {
  small,
  square,
  page,
  round,
  mixed,
}

enum BoxColorType {
  single,
  gradient,
  // animation,
}

enum TitleTextAlign {
  start,
  center,
  end,
}
