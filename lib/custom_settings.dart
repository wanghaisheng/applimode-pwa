// Have a copy for updates (paste)
// 업데이트를 위해 복사본을 가지고 있기 (붙여넣기 할 것)
// Select between true and false for Boolean type
// 불타입은 true, false 중 선택

import 'package:applimode_app/src/constants/constants.dart';
import 'package:flutter/widgets.dart';

// Main screen app bar title.
// Used when remote configuration is not set.
// 메인 화면 앱바 타이틀. 리모트 컨피그 설정을 안 했을 경우 사용됨.
const spareHomeBarTitle = 'My Applimode';

// Main screen app style. 0 is only text, 1 is only image, 2 is image and text
// Used when remote configuration is not set. Default 0
// 메인 화면 앱바 스타일. 0은 글자만, 1은 이미지, 2는 글자 와 이미지
// 리모트 컨피그 설정을 안 했을 경우 사용됨. 기본 0
const spareHomeBarStyle = 0;

// 리모트 컨피그 설정을 안 했을 경우 기본으로 사용되는 메인 컬러. 기본 FCB126
// Main color used as default when remote configuration is not set. Default FCB126
const spareMainColor = 'FCB126';

// Data used for app information
// 앱정보에 사용되는 데이터
// Refer to pubspec.yaml for version
// 버전은 pubspec.yaml을 참고
const fullAppName = 'My Applimode';
const shortAppName = 'AMB';
const underbarAppName = 'my_applimode';
const camelAppName = 'myApplimode';
const androidBundleId = 'applimode.my_applimode';
const appleBundleId = 'applimode.myApplimode';
const firebaseProjectName = 'my-applimode';
const appCreator = 'JongsukOh';
const appVersion = '1.0.0';

// Main screen list view style
// 메인 화면 리스트 뷰 스타일
// Select among small, square, page (small, square, page)
// small, square, page 중 선택 (small, square, page)
const postsListType = PostsListType.square;

// Provides an option to select the main screen list view style
// 메인화면 리스트 뷰 스타일을 선택할 수 있는 옵션 제공
// If true, postsListType is not used
// 트루일 경우 postsListType 을 사용하지 않음
// Used for demo version. Not recommended to use
// 데모버전을 위해 사용되었음. 사용하는 것을 추천하지 않음
const bool showAppStyleOption = true;

// Change the start screen to the login screen
// 시작 화면을 로그인 화면으로 변경
// To prevent use if not logged in. Security rules must also be changed.
// 로그인을 안할 경우 사용하지 못하도록 할때. 보안 룰도 함께 변경해야 함
const isInitialSignIn = false;

// Only administrators can write
// 관리자만 글을 쓸 수 있음
const bool adminOnlyWrite = false;

// When using the Firebase analytics to know app user size
// 파이어베이스 분석도구를 사용할 경우. 사용자 규모를 파악할 수 있음
const bool useAnalytics = false;
// When using push notifications. default false
// 푸시 알림을 사용할 경우. 기본 false
// Use Blaze plan of Firebase to use push notifications
// 푸시 알림을 사용하기 위해서는 Blaze 요금제 사용
// The default Spark plan is disabled when the basic limit is exceeded
// 기본인 Spark 요금제는 기본 한도를 초과하면 사용 중지
// If you use the Blaze plan, a fee will be charged if you exceed the basic limit
// Blaze 요금제를 사용할 경우, 기본 한도를 초과한면 비용 발생
// After using the Blaze plan, it is necessary to set up Cloud functions
// Blaze 요금제를 사용한 후 Cloud functions 을 설정하고
const bool useFcmMessage = false;

// register as a paid member of the Apple Developer Program for notifications on Apple devices
// 애플 기기의 알림을 위해 애플 개발자 프로그램에 유료 회원으로 등록한 후
// and configure the settings for APNS
// 설정을 해주는 것이 필요
const bool useApns = false;

// Used to shorten the length of the url of the storage object.
// Change 'my-applimode' to your Firebase project name.
// 스토리지 객체의 url의 길이를 줄이기 위해 사용. my-applimode를 파이어베이스 프로젝트명으로 변경
const preStorageUrl =
    'https://firebasestorage.googleapis.com/v0/b/my-applimode.appspot.com/o/';

// Mute home screen video sound
// 홈화면 영상 소리 뮤트
const isPostsItemVideoMute = false;

// Use direct upload button on page type
// 페이지 타입에서 다이렉트 업로드 버튼 사용
const useDirectUploadButton = true;

// Color type of basic post box. single, gradient, animation. basic gradient
// 베이직 포스트 박스의 컬러 타입. single, gradient, animattion. 기본 gradient
const boxColorType = BoxColorType.gradient;
// Used when specified as single. Colors can be set directly using boxCustomColorPalettes
// single로 지정했을 경우 사용. boxCustomColorPalettes 를 이용해 직접 컬러 설정 가능
const boxSingleColors = boxSingleColorPalettes;
// Used when specified as gradient, animation. Colors can be set directly using boxCustomGradientColorPalettes
// gradient, animation을 사용했을 경우 사용. boxCustomGradientColorPalettes 를 이용해 직접 지정 가능
const boxGradientColors = boxGradientColorPalettes;

// use r2 storage
// r2 스토리지 사용
const useRTwoStorage = false;
// When using r2, use secure read
// r2 사용시 읽기도 보안 가져오기 사용
const useRTwoSecureGet = false;
// use Cloudflare CDN
// 클라우드플레어 CDN 사용 (도메인 등록 필수)
const useCfCdn = false;
// use Cloudflare D1 for seach
// 검색서비스를 위해 클라우드플레어 D1 사용
const useDOneForSearch = false;

// Cloudflare worker base url for r2 storage
// 클라우드플레어 r2 스토리지 사용을 위한 워커 베이스 url
const rTwoBaseUrl = 'yourR2WorkerUrl';

// Cloudflare custom domain for cdn
// 클라우드플레어 커스텀 도메인 url
const cfDomainUrl = 'yourCustomDomainUrl';

// Cloudflare worker base url for D1 table
// 클라우드플레어 D1 데이터베이스를 위한 워커 베이스 url
const dOneBaseUrl = 'yourD1WorkerUrl';

// Regular expression for search with D1. Set for each language
// D1에서 검색을 위한 정규표현식. 각 언어에 맞게 설정할 것
const searchRegExp = '[^A-Za-z0-9ㄱ-ㅎㅏ-ㅣ가-힣\n ]';

// Number of items loaded at once in the main screen list view. default 10
// 메인 화면 리스트 뷰에서 한번에 불러오는 아이템 숫자. 기본 10
// As the number increases, the number of reads in the database increases.
// 숫자를 늘릴 수록 데이터베이스의 읽기 수롤 많이 사용함
const int listFetchLimit = 10;
// Number of items loaded in the main head view of the home screen. default 1
// 홈화면 상단 메인 뷰에서 사용하기 위해 블러오는 아이템 숫자. 기본 1
const int mainFetchLimit = 1;

// Refresh cycle through main screen pull-to-refresh. Default 10 seconds
// 메인화면 풀투리프레쉬를 통한 새로고침 주기. 기본 10초
const int mainPostsRefreshTimer = 10;

// Maximum length of video in seconds. default 60
// 비디오 영상 최대 길이 초 단위. 기본 60
const int videoMaxDuration = 60;

// Maximum video file size. Default 50.0 in megabytes
// 비디오 영상 최대 파일 크기. 메가바이트 단위 기본 50.0
const double mediaMaxMBSize = 50.0;

// Frequency of remote config calls.
// A minimum of 12 hours of use in production mode is recommended.
// 리모트 컨피그 호출 빈도. 프로덕션 모드에서 최소 12시간 사용 권장.
const Duration remoteConfigInterval = Duration(minutes: 10);

// Changing this will change the maximum width of the content on the web.
// Only pcWidthBreakpoint was used.
// 변경하면 웹에서 컨텐츠의 최대너비가 바뀜. pcWidthBreakpoint만 사용했음.
// default 600.0
// 기본 600.0
const double mobileWidthBreakpoint = 600.0;
// default 840.0
// 기본 840.0
const double pcWidthBreakpoint = 720.0;

// Maximum length of username in sub-info. default 18
// 서브 인포에서 이름 최대 길이. 기본 18
const int usernameMaxLength = 18;

// List to show in main screen drawer
// 메인화면 서랍에서 보여줄 리스트
// Recommendations
// 추천글
const bool useRecommendation = true;
// Ranking
// 순위
const bool useRanking = true;
// Category
// 카테고리
const bool useCategory = true;
// logout button. default true
// 로그아웃 버튼. 기본 true
const bool showLogoutOnDrawer = true;

// Show search button on app bar
// 검색 버튼 보이기
const bool showSearchButton = true;

// show like count
// 포스트에서 좋아요 수 보여주기
const bool showLikeCount = true;
// show dislike count
// 포스트에서 싫어요 수 보여주기
const bool showDislikeCount = true;
// show total count of like and dislike
// 포스트에서 좋아요 싫어요 합계 수 보여주기
const bool showSumCount = false;
// show post comment count
// 포스트에서 댓글 수 보여주기
const bool showCommentCount = true;
// show total count of like and comment
// 포스트에서 좋아요와 댓글 합계 수 보여주기
const bool showCommentPlusLikeCount = false;
// Show the like icon as a heart
// 좋아요 아이콘을 하트로 보여주기
const bool isThumbUpToHeart = false;
// Use the dislike button but hide the count
// 싫어요 버튼은 사용하고 카운트만 숨기기
const bool showOnlyDislikeButton = false;

// Show administrator icon
// 관리자 아이콘 보여주기
const bool showUserAdminLabel = true;
// Show the total number of likes received by the user
// 사용자가 받은 총 좋아요 카운트 보여주기
const bool showUserLikeCount = true;
// Show the total number of dislikes received by the user
// 사용자가 받은 총 싫어요 카운트 보여주기
const bool showUserDislikeCount = true;
// Show the total number of likes and dislikes received by the user
// 사용자가 받은 좋아요 싫어요 합계 보여주기
const bool showUserSumCount = false;

// Administrator icon color. default 0xFFEEAC4D
// 관리자 아이콘 색깔. 기본 0xFFEEAC4D
const int userAdminColor = 0xFFEEAC4D;
// Verified user icon color. default 0xFF00a5e3
// 인증된 사용자 아이콘 색깔. 기본 0xFF00a5e3
const int userVerifiedColor = 0xFF00a5e3;
// User like icon color. default 0xFF00C6C7
// 사용자 좋아요 아이콘 색깔. 기본 0xFF00C6C7
const int userLikeCountColor = 0xFF00C6C7;
// User dislike icon color. default 0xFFFF6F68
// 사용자 싫어요 아이콘 색깔. 기본 0xFFFF6F68
const int userDislikeCountColor = 0xFFFF6F68;
// User Likes Dislikes Total Icon Color. default 0xFF6C88C4
// 사용자 좋아요 싫어요 합계 아이콘 색깔. 기본 0xFF6C88C4
const int userSumCountColor = 0xFF6C88C4;

// Edit card type (square, page) main screen style
// 카드타입 (스퀘어, 페이지) 메인 화면 스타일 편집

// Center title text alignment. Specify among start, center, end. default center
// 센터 타이틀 텍스트 정렬. start, center, end 중 지정. 기본 center
const TitleTextAlign titleTextAlign = TitleTextAlign.center;
// Maximum number of lines in the center title. basic 2
// 센터 타이틀 최대 줄수. 기본 2
const int basicPostsItemMiddleTitleMaxLines = 2;
// Maximum number of lines in the bottom title. basic 2
// 하단 타이틀 최대 줄수. 기본 2
const int basicPostsItemBottomTitleMaxLines = 2;
// Maximum number of lines in video content title. default 1
// 비디오 컨텐츠 타이틀 최대 줄수. 기본 1
const int basicPostsItemVideoTitleMaxLines = 1;
// Title text size. default 20.0
// 타이틀 텍스트 크기. 기본 20.0
const double basicPostsItemTitleFontsize = 20.0;
// Profile image size. default 48.0
// 프로필 이미지 크기. 기본 48.0
const double basicPostsItemProfileSize = 48.0;
// Username font size. default 18.0
// 사용자 이름 크기. 기본 18.0
const double basicPostsItemNameSize = 18.0;
// Sub-info size. default 14.0
// 서브 인포 크기. 기본 14.0
const double basicPostsItemSubInfoSize = 14.0;
// Side button color. default 0xFFFFFFFF
// 사이드 버튼 컬러. 기본 0xFFFFFFFF
const int basicPostsItemButtonColor = 0xFFFFFFFF;
// Side button size. default 28.0
// 사이드 버튼 크기. 기본 28.0
const double basicPostsItemButtonSize = 28.0;
// Side button count font size. default 14.0
// 사이드 버튼 카운트 글자 크기. 기본 14.0
const double basicPostsItemButtonFontSize = 14.0;

// Edit list type (small) main screen style
// 리스트타입 (스몰) 메인 화면 스타일 편집
// List height. default 88.0
// 리스트 높이. 기본 88.0
const double listSmallItemHeight = 88.0;
// Header item aspect ratio. default 16 / 9
// 메인 헤더 비율. 기본 16 / 9
const double smallItemHeaderRatio = 16 / 9;
// Image size. Change it in conjunction with the height of the list above.
// default 56.0
// 이미지 크기. 위의 리스트 높이랑 연동해서 변경할 것. 기본 56.0
const double cachedBorderImageSize = 56.0;
// Image roundness. default 12.0
// 이미지 둥글기. 기본 12.0
// When changing the size to half of the cachedBorderImageSize
// it changes to a circular shape.
// 위의 이미지 사이즈의 절반의 크기로 변경할 경우 원형으로 바뀜
const double cachedBorderImageRedius = 12.0;
// Maximum number of lines in the title. default 1
// 타이틀 최대 줄수. 기본 1
const int smallPostsItemTitleMaxLines = 1;
// Title size. default 16.0
// 타이틀 사이즈. 기본 16.0
const double smallPostsItemTitleSize = 16.0;
// Sub info size. default 12.0
// 서브 인포 사이즈. 기본 12.0
const double smallPostsItemSubInfoSize = 12.0;

// User likes, dislikes, and total label size in profile. default 12.0
// 프로필에서 사용자 좋아요, 싫어요, 합계 라벨 사이즈. 기본 12.0
const double profileUserLabelFontSize = 12.0;

// Change the height of the main screen app bar. default 64.0
// 메인 화면 앱바의 높이를 변경. 기본 64.0
const double mainScreenAppBarHeight = 64.0;
// Change the main screen app bar image padding. default 16.0
// 메인 화면 앱바 이미지의 상하여백를 변경. 기본 16.0
const double mainScreenAppBarPadding = 16.0;
// Change the height of the post screen app bar. default 72.0
// 포스트 화면 앱바의 높이를 변경. 기본 72.0
const double postScreenAppBarHeight = 72.0;
// Change the height of the comment screen app bar. default 72.0
// 코멘트 화면 앱바의 높이를 변경. 기본 72.0
const double commentScreenAppBarHeight = 72.0;

// Change minimum profile size. Not used. default 16.0
// 최소 프로필 사이즈 변경. 사용하지 않음. 기본 16.0
const double profileSizeMicro = 16.0;
// Change the profile size of the main screen drawer. default 24.0
// 메인화면 서랍의 프로필 사이즈 변경. 기본 24.0
const double profileSizeSmall = 24.0;
// Change the default profile size. Not used. default 32.0
// 기본 프로필 사이즈 변경. 사용하지 않음. 기본 32.0
const double profileSizeMedium = 32.0;
// Change the size of all profiles
// except the main screen drawer and profile screen profiles. default 40.0
// 메인화면 서랍, 프로필 스크린 프로필 외 모든 프로필 사이즈 변경. 기본 40.0
const double profileSizeBig = 40.0;
// Change the profile size on the profile screen. default 48.0
// 프로필 화면의 프로필 사이즈 변경. 기본 48.0
const double profileSizeBigger = 48.0;
// Change maximum profile size. Not used. default 64.0
// 최대 프로필 사이즈 변경. 사용하지 않음. 기본 64.0
const double profileSizeMax = 64.0;

// Default padding. Used to limit the maximum size. default 16.0
// 기본 패딩. 최대 크기를 제한하는 경우 사용. 기본 16.0
const double defaultHorizontalPadding = 16.0;

//Padding at the bottom of the card item on the main screen. Not used.
//default 12.0
// 메인 화면의 카드 아이템 하단 패딩. 0.0 일 경우 여백 없음. 기본 12.0
const double cardBottomPadding = 12.0;

// How long the full screen video player overlay (like the play button) stays on
// default 4
// 전체 화면 비디오 플레이어 오버레이(플레이버튼 같은) 유지 시간. 기본 4
const Duration overlayDuration = Duration(seconds: 4);

// 그라디에이션 컬러 애니메이션 구동 시간. 기본 2000
// Gradient color animation running time. default 2000
const int colorAnimationDuration = 2000;

// Minimum bytes to specify long content. default 1200
// 긴 컨텐츠 지정을 위한 최소 바이트. 기본 1200
const int longContentSize = 1200;
// Maximum length saved as a title when specified as long content. default 140
// 긴 컨텐츠로 지정되었을 경우 타이틀로 저장하는 최대 길이. 기본 140
const int longContentTitleSize = 140;

// Text displayed if there is no self-introduction on the bio edit screen.
// default noBio
// 프로필의 자기소개 변경 화면에서 자기 소개 없을 경우 표시되는 문구. 기본 noBio
const String noBio = 'noBio';

// Single color box basic color. If you set it yourself, use boxCustomColorPalettes at the bottom.
// 싱글 컬러 박스 기본 컬러. 직접 설정할 경우 하단의 boxCustomColorPalettes를 사용
const boxSingleColorPalettes = [
  Color(0xFFFCB126),
  Color(0xFF4CB0A6),
  Color(0xFFFF6F68),
  Color(0xFF5cb270),
  Color(0xFFffa8bd),
  Color(0xFFb79c05),
  Color(0xFF00ACA5),
  Color(0xFFEE84B3),
  Color(0xFF20503E),
  Color(0xFFB57E79),
];

// Gradient and animation color box default colors. If you set it yourself, use boxCustomGradientColorPalettes at the bottom.
// 그라디언트 및 애니메이션 컬러 박스 기본 컬러. 직접 설정할 경우 하단의 boxCustomGradientColorPalettes를 사용
const boxGradientColorPalettes = [
  [Color(0xFFede342), Color(0xFFff51eb)],
  [Color(0xFF439cfb), Color(0xFFf187fb)],
  [Color(0xFF0061FF), Color(0xFF60efff)],
  [Color(0xFFf4f269), Color(0xFF5cb270)],
  [Color(0xFFff0f7b), Color(0xFFf89b29)],
  [Color(0xFF5D4157), Color(0xFFA8CABA)],
  [Color(0xFF61f4de), Color(0xFF6e78ff)],
  [Color(0xFFb79c05), Color(0xFF161616)],
  [Color(0xFF42047e), Color(0xFF07f49e)],
  [Color(0xFF40c9ff), Color(0xFFe81cff)],
];

// Used when directly specifying single color box.
// 싱글 컬러 박스 직접 지정할 경우 사용.
const boxCustomColorPalettes = [
  Color(0xFFFCB126),
  Color(0xFF4CB0A6),
  Color(0xFFFF6F68),
  Color(0xFF5cb270),
  Color(0xFFffa8bd),
  Color(0xFFb79c05),
  Color(0xFF00ACA5),
  Color(0xFFEE84B3),
  Color(0xFF20503E),
  Color(0xFFB57E79),
];

// Used when directly specifying gradient and animation color box.
// 그라디언트 및 애니메이션 컬러 박스 직접 지정할 경우 사용.
const boxCustomGradientColorPalettes = [
  [Color(0xFFede342), Color(0xFFff51eb)],
  [Color(0xFF439cfb), Color(0xFFf187fb)],
  [Color(0xFF0061FF), Color(0xFF60efff)],
  [Color(0xFFf4f269), Color(0xFF5cb270)],
  [Color(0xFFff0f7b), Color(0xFFf89b29)],
  [Color(0xFF5D4157), Color(0xFFA8CABA)],
  [Color(0xFF61f4de), Color(0xFF6e78ff)],
  [Color(0xFFb79c05), Color(0xFF161616)],
  [Color(0xFF42047e), Color(0xFF07f49e)],
  [Color(0xFF40c9ff), Color(0xFFe81cff)],
];
