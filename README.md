# Applimode
<!--
English | [한글](README_ko.md)
-->

Applimode is a project based on Flutter that allows easy construction of various types of apps and websites, ranging from blogs to bulletin boards. Even those without developer experience can create Android, iOS, web, and PWA applications, and deploy them directly to their own Google Firebase server at little to no cost. 
<!--Optionally, utilizing Cloudflare's R2 storage, workers, and CDN enables the affordable construction of media services as well.-->

## Configure your Applimode app
* [Configure Applimode for Windows](https://github.com/mycalls/applimode/blob/main/docs/windows.md)
* [Configure Applimode for macOS](https://github.com/mycalls/applimode/blob/main/docs/macos.md)

<!--
## Configuration overview
> [!IMPORTANT]
> * To install your Applimode app on an iOS device, you need a device running macOS.
> * This guide is a summary. If you have any questions or encounter any problems during the process, please refer to this [section](#configure-your-applimode-app).

* Download and install the following packages:
**Git** (only [Windows](https://github.com/mycalls/applimode/blob/main/docs/windows.md#install-git)), **VSCode** ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#install-vscode-and-the-flutter-sdk), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#install-vscode)), **Flutter SDK** ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#install-vscode-and-the-flutter-sdk), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#download-and-install-flutter)), **Android Studio** ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#install-android-studio), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#install-android-studio)), **Xcode** (only [macOS](https://github.com/mycalls/applimode/blob/main/docs/macos.md#install-and-configure-xcode)), **Node.js** · **Firebase CLI** · **Flutterfire CLI** ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#install-nodejs-and-the-firebase-cli-and-the-futterfire-cli), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#install-nodejs-and-the-firebase-cli-and-the-futterfire))
* Configure Firebase ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#configure-firebase), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#configure-firebase))
* Run the following commands.
```sh
git clone https://github.com/mycalls/applimode-tool.git
```
```sh
git clone https://github.com/mycalls/applimode.git
```
```sh
cd applimode-tool
```
* Modify and run the following command. (for more details, visit this [page](https://github.com/mycalls/applimode/blob/main/docs/windows.md#configure-your-project).)
> [!NOTE]
> * The worker key is used to store media files using **Cloudflare's R2** instead of **Firebase Storage**. This is optional, and you can enter your desired password.
```sh
npm run init -- --project-name="project name" --full-name="App Full Name" --short-name="App Short Name" --organization-name="myhome" --firebase-name="firebaseProjectId" --worker-key="yourWorkerKey" --main-color="FCB126"
```
* Replace the image files in **applimode/assets/images with the image files you want.
```sh
cd ..; cd applimode
```
```sh
flutter pub get; dart run flutter_native_splash:create; flutter pub run flutter_launcher_icons; dart run build_runner build -d; flutterfire configure; firebase deploy --only firestore; firebase deploy --only storage;
```
Additionally, you can set or configure the following:
* Add administrator ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#add-administrator), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#add-administrator))
* Admin settings and custom settings ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#admin-settings-and-custom-settings), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#admin-settings-and-custom-settings))
* Build an Android app ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#build-an-android-app), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#build-an-android-app))
* Build a web app ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#build-a-web-app), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#build-a-web-app))
* Configure Cloudflare R2 ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#configure-cloudflare-r2-optional), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#configure-cloudflare-r2-optional))
* Configure Cloudflare D1 ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#configure-cloudflare-d1-optional), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#configure-cloudflare-d1-optional))
* Configure Cloudflare CDN ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#configure-cloudflare-cdn-optional), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#configure-cloudflare-cdn-optional))
* Configure Youtube image proxy ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#configure-youtube-image-proxy-optional), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#configure-youtube-image-proxy-optional))
* Configure Youtube video proxy ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#configure-youtube-video-proxy-optional), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#configure-youtube-video-proxy-optional))
* Configure push notification ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#configure-push-notification-optional), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#configure-push-notification-optional))
* Use your custom domain ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#use-your-custom-domain-optional), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#use-your-custom-domain-optional))
* Upgrade your project with the new Applimode version ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#upgrade-your-project-with-the-new-applimode-version), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#upgrade-your-project-with-the-new-applimode-version))
* Configure Cloud Firestore Security Rules ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#configure-cloud-firestore-security-rules), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#configure-cloud-firestore-security-rules))
* Troubleshooting ([Win](https://github.com/mycalls/applimode/blob/main/docs/windows.md#troubleshooting), [mac](https://github.com/mycalls/applimode/blob/main/docs/macos.md#troubleshooting))
-->

## Main features
* Posts (text, images, videos)
* Comments (text, images)
* Like, dislike
* 3 types of bulletin board styles (list, box, page)
* Post Markdown support
* Hashtag
* Category and ranking
* Various admin settings options
* User Blocking

## Goals
> With Applimode, I want you to save your time and money.
* Build a community or blog service that supports web, iOS, and Android in just a few hours.
* Achieve zero initial cost and minimal maintenance costs.
* Make it easy to build, even for non-developers.
* Build and manage on your own server.

## Demo
* [Applimode Demo Web](https://applimode-demo.web.app/){:target="_blank"}
<!--
* [Android]()
* iOS will be updated in the future.
-->

<!--
## FAQs
* 앱 스타일 변경 방법
* 링크형식의 이미지나 비디오 삽입 방법
* 비디오 썸네일 직접 지정하는 방법
* 박스 또는 페이지 스타일에서 제목, 저자 숨기는 방법
-->
<!--[새 탭에서 열기](https://www.google.com/){:target="_blank"}-->

## Roadmap
The content of this section will be updated in the future.

## Contributing
The content of this section will be updated in the future.

## Releases
Please see the [changelog](https://github.com/mycalls/applimode/blob/main/CHANGELOG.md) for more details about a given release.

## Acknowledgements
Special thanks to these amazing projects which help power Applimode:
* [CODE WITH ANDREA](https://codewithandrea.com/)
* [Riverpod](https://riverpod.dev/)
