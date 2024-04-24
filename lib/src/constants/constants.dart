import 'package:flutter/material.dart';

// Never touch it. Manual code modification required when changing
// 절대 만지지 말 것. 변경 시 직접 코드 수정 필요
enum PostsListType {
  small,
  square,
  page,
}

enum BoxColorType {
  single,
  gradient,
  animation,
}

enum TitleTextAlign {
  start,
  center,
  end,
}

// split tag in text to create widget. Dont touch.
// 절대 만지지 말 것. 변경 시 직접 코드 수정 필요
const String splitTag = '<split>';

// firestore path
// 절대 만지지 말 것. 변경 시 직접 코드 수정 필요
const String postsPath = 'posts';
const String commentsPath = 'comments';

// storage path
// 절대 만지지 말 것. 변경 시 직접 코드 수정 필요
const String postPath = 'post';
const String profilePath = 'profile';
const String storyPath = 'story';

// stroage file content type
// 절대 만지지 말 것. 변경 시 직접 코드 수정 필요
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

const String contentTextPlain = 'text/plain';
const String contentTextHtml = 'text/html';
const String contentJson = 'application/json';

const String deleted = 'deleted';
const String unknown = 'unknown';

const String firebaseStorageUrlHead = 'https://firebasestorage.googleapis.com';
const String gcpStorageUrlHead = 'https://storage.googleapis.com/';

const String spareHomeBarImageUrl = 'assets/images/app-bar-logo.png';

// 랭킹에서 현재 년도 분석 실패시 사용.
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
