# Applimode

Applimode is a project based on Flutter that allows easy construction of various types of apps and websites, ranging from blogs to bulletin boards. Even those without developer experience can create Android, iOS, web, and PWA applications, and deploy them directly to their own Google Firebase server at little to no cost. 
<!--Optionally, utilizing Cloudflare's R2 storage, workers, and CDN enables the affordable construction of media services as well.-->

## Configure your Applimode app
* [Configure Applimode for Windows](https://github.com/mycalls/applimode/blob/main/docs/windows.md)
* [Configure Applimode for macOS](https://github.com/mycalls/applimode/blob/main/docs/macos.md)

## Configuration overview
> [!IMPORTANT]
> * To install your Applimode app on an iOS device, you need a device running macOS.
> * This guide is a summary. If you have any questions or encounter any problems during the process, please refer to this [section](#configure-your-applimode-app).


* Download and install the following packages:
**Git** (only [Windows]()), **VSCode** ([Win](), [mac]()), **Flutter SDK** ([Win](), [mac]()), **Android Studio** ([Win](), [mac]()), **Xcode** (only [macOS]()), **Node.js** ([Win](), [mac]()), **Firebase CLI** ([Win](), [mac]()), **Flutterfire CLI** ([Win](), [mac]())
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
* Modify and run the following command. (for more details, visit this [page]().)
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
* Add administrator ([Win](), [mac]())
* Admin settings and custom settings ([Win](), [mac]())
* Build an Android app ([Win](), [mac]())
* Build a web app ([Win](), [mac]())
* Configure Cloudflare R2 ([Win](), [mac]())
* Configure Cloudflare D1 ([Win](), [mac]())
* Configure Cloudflare CDN ([Win](), [mac]())
* Configure Youtube image proxy ([Win](), [mac]())
* Configure Youtube video proxy ([Win](), [mac]())
* Configure push notification ([Win](), [mac]())
* Use your custom domain ([Win](), [mac]())
* Upgrade your project with the new Applimode version ([Win](), [mac]())
* Configure Cloud Firestore Security Rules ([Win](), [mac]())
* Troubleshooting ([Win](), [mac]())

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
The content of this section will be updated in the future.

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
