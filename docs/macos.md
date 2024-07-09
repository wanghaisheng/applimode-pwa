# Configure Applimode for macOS


<!--
1. Install and configure Xcode
2. Install Rosetta 2
3. Install VSCode
4. Download and install Flutter
5. Install Android Studio
6. Install Homebrew
7. Install rbenv, Ruby, and CocoaPods
8. Configure Firebase
9. Install Node.js and the Firebase CLI and the Futterfire 
10. Configure your project
11. Test drive
12. Add administrator
13. Admin settings and custom settings
14. Build an iOS app
15. Build an Android app
16. Build a web app
17. Configure Cloudflare R2 (Optional)
18. Configure Cloudflare D1 (Optional)
19. Configure Cloudflare CDN (Optional)
20. Configure Youtube image proxy (Optional)
21. Configure Youtube video proxy (Optional)
22. Configure push notification (Optional)
23. Use your custom domain (Optional)
24. Upgrade your project with the new Applimode version
25. Configure Cloud Firestore Security Rules
26. Troubleshooting
-->


> [!IMPORTANT]
> * This guide is written in detail for beginners. Skip the unnecessary parts.
> * This guide is written for macOS running on Apple Silicon.
> * Flutter supports macOS 10.15 (Catalina) or later.
> * This guide presumes your Mac runs the zsh as your default shell.



<!--
## Install Git
* Download and install [Git](https://git-scm.com/download/mac).
* Press ```Cmd``` + ```SpaceBar```, type **Terminal** and click.
* Run the following command.
```sh
git --version
```
* Close **Terminal**.
-->



## Install and configure Xcode
* Download, install, and open [Xcode](https://developer.apple.com/xcode/).
<!--열기 팝업이 추가된 링크-->
<!--https://apps.apple.com/us/app/xcode/id497799835-->
* If iOS is not checked in the **Select the platforms** box, check it and click **Install** or **Download & Installl**.
* Click the Spotlight icon in the menu bar. (or press ```Command``` + ```Space Bar```)
* In the search field, type *terminal* and select it.
* Run the following commands.
```sh
sudo sh -c 'xcode-select -s /Applications/Xcode.app/Contents/Developer && xcodebuild -runFirstLaunch'
```
```sh
sudo xcodebuild -license
```
<!--
```xcode-select --install```이라는 명령어를 사용하라는 경우도 있다.
하지만 xcode commandline toos는 xcode가 설치될 때, 같이 설치됨으로 위치만 지정해 주는 것이 맞는 듯 하다.
-->



## Install Rosetta 2
* Click the Spotlight icon in the menu bar. (or press ```Command``` + ```Space Bar```)
* In the search field, type *terminal* and select it.
* Run the following commands.
```sh
sudo softwareupdate --install-rosetta --agree-to-license
```



## Install VSCode
* Download, install, and launch [VSCode](https://code.visualstudio.com/).
* To open the Command Palette, press ```Command``` + ```Shift``` + ```P```. (or chosse **View** > **Command Palette**)
* Type *shell* and select **Shell Command: Install 'code' command in PATH**.
* Press ```Command``` + ```Shift``` + ```X```. (or choose **View** > **Extensions**)
* Type *flutter* and click **Install**.
<!--
* Press ```Command``` + ```Shift``` + ```P```.
* In the **Command Palette**, type *flutter*.
* Select **Flutter: New Project**.
* Click **Download SDK** at the bottom right.
* Create a folder (choose File > New Folder, or press ```Command``` + ```Shift``` + ```N```) and name it *development*.
* Click **Clone Flutter**.
* Click **Add SDK to PATH**.
* To open the **VScode**'s built-in terminal, click **View** (on the top menu of VSCode) and select **Terminal**.
* Run the following command.
```sh
flutter doctor
```
-->
* Close **VSCode**.



## Download and install Flutter
* Open this [page](https://docs.flutter.dev/get-started/install/macos/mobile-ios) and scroll down.
* Click **Download and install** in the **Install the Flutter SDK** section.
* Click **flutter_macos_arm64_x.xx.x-stable.zip**.
* Open or go to **Terminal**.
* Run the following command.
> [!CAUTION]
> Change **x.xx.x** in the command to the current version of the file.
```sh
unzip ~/Downloads/flutter_macos_arm64_x.xx.x-stable.zip \
       -d ~/development/
```
* When finished, the Flutter SDK should be in the ~/development/flutter directory.
* To add Flutter to the PATH environment variable, run the following command.
```sh
nano ~/.zshenv
```
> [!NOTE]
> Use your preferred text editor.
* Copy the following line and paste it at the end of your ~/.zshenv file.
```sh
export PATH=$HOME/development/flutter/bin:$PATH
```
* Save your ~/.zshenv file. (If you used the nano editor, press ```control``` + ```O```, then ```control``` + ```X```.)
* To apply this change, restart all open Terminal sessions.
<!--
* Run the following command.
```sh
flutter doctor
```
-->



## Install Android Studio
* Download, install, and launch [Android Studio](https://developer.android.com/studio).
* Click **Pulgins** (on the left sidebar), type *flutter*, click **Install**, and then click **Restart IDE**.
* Click **Projects** (on the left sidebar), then **More Actions** (in the Center), and finally **SDK Manager**.
* Click **SDK Tools** (on the top menu).
* Check **Android SDK Command-line Tools**, then click **Apply** (on the bottom right).
* Open or go to **Terminal**.
* Run the following command and press ```y``` to all questions.
```sh
flutter doctor --android-licenses
```
<!--
```sh
flutter doctor
```
-->
* Close **Android Studio** and **Terminal**.



## Install Homebrew
* Open or go to **Terminal**.
* Run the following command
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
> For more details, visit [this page](https://brew.sh/).
* Run these two commands in the following part of the output.
```sh
===> Next steps:
- Run these two commands in your terminal to add Homebrew to your PATH:
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/<USERNAME>/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
```
<!--
```sh
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/<USERNAME>/.zprofile
```
```sh
eval "$(/opt/homebrew/bin/brew shellenv)"
```
```sh
brew doctor
```
-->
* Close **Terminal**.



## Install rbenv, Ruby, and CocoaPods
* Open or go to **Terminal**.
* Run the following command.
```sh
brew install rbenv
```
* To add **rbenv** to the PATH environment variable, run the following command.
```sh
nano ~/.zshenv
```
* Copy the following line and paste it at the end of your ~/.zshenv file.
```sh
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"
```
* Save your ~/.zshenv file. (If you used the nano editor, press ```control``` + ```O```, then ```control``` + ```X```.)
* Close **Terminal** and reopen it.
<!--
```sh
source ~/.zshenv
```
-->
* Run the following commands.
<!--
```sh
rbenv install -l
```
-->
```sh
rbenv install 3.2.3
```
```sh
rbenv global 3.2.3
```
```sh
source ~/.zshenv
```
```sh
sudo gem install cocoapods
```
<!--
```sh
sudo gem update --system x.x.x
```
-->
<!--flutter 공식문서만 패스 추가할 것을 권장함.-->
```sh
nano ~/.zshenv
```
* Copy the following line and paste it at the end of your ~/.zshenv file.
```sh
export PATH=$HOME/.gem/bin:$PATH
```
* Save your ~/.zshenv file. (If you used the nano editor, press ```control``` + ```O```, then ```control``` + ```X```.)
* Close **Terminal**.
<!--
```sh
source ~/.zshenv
```
```sh
ruby -v
```
-->



## Configure Firebase
* Sign up or log in to [Firebase](https://firebase.google.com).
* Click [Go to console](https://console.firebase.google.com).
* Click **Add project**.
* Enter a project name and click **Continue**.
* Disable **Google Analytics** and click **Create project**. (You can change this setting later.)
* Click **Build** (on the left sidebar) and click **Authentication**.
* Click **Get started** and then click **Email/Password**.
* Enable **Email/Password** and click **Save**.
* Click **Build** (on the left sidebar) and then click **Firestore Database**.
* Click **Create database** and select a location for your database.
* Click **Next** and then click **Create**.
* Click **Build** (on the left sidebar) and then click **Storage**.
* Click **Get started**, then click **Next**, and finally click **Done**.



## Install Node.js and the Firebase CLI and the Futterfire
* Open or go to **Terminal**.
* Run the following commands.
```sh
brew install nvm
```
<!--
~/.nvm 있는지 확인할 것.
어떤 문서는 디렉토리를 따로 만들어야 한다고 쓰여 있음.
nvm 설치 후 확인해 볼것
```sh
mkdir ~/.nvm
```
-->
```sh
nano ~/.zshenv
```
* Copy the following line and paste it at the end of your ~/.zshenv file.
```sh
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
```
* Save your ~/.zshenv file. (If you used the nano editor, press ```control``` + ```O```, then ```control``` + ```X```.)
* Run the following commands.
```sh
source ~/.zshenv
```
<!--
```sh
nvm -v
```
-->
```sh
nvm install --lts
```
<!--
```sh
여러개 설치되있을 경우 원하는 버전 사용하기
nvm use --lts
node -v
npm -v
```
-->
```sh
npm install -g firebase-tools
```
* Close **Terminal** and reopen it.
* Run the following commands.
```sh
firebase login
```
```sh
dart pub global activate flutterfire_cli
```
```sh
nano ~/.zshenv
```
* Copy the following line and paste it at the end of your ~/.zshenv file.
```sh
export PATH="$PATH":"$HOME/.pub-cache/bin"
```
* Save your ~/.zshenv file. (If you used the nano editor, press ```control``` + ```O```, then ```control``` + ```X```.)
* Run the following command.
```sh
source ~/.zshenv
```



## Configure your project
* Open or go to **Terminal**.
* Run the following commands.
```sh
mkdir ~/projects; cd ~/projects;
```
```sh
git clone https://github.com/mycalls/applimode-tool.git
```
```sh
git clone https://github.com/mycalls/applimode.git
```
* Close **Terminal**.
* Open **VSCode**
* Click **File** (on the top menu of VSCode), select **Open Folder**, choose **applimode-tool** (in the **projects** folder) and click **Open**.
* Click **View** (on the top menu of VSCode), then select **Terminal**.
* Modify and run the following command.
```sh
npm run init -- --project-name="project name" --full-name="App Full Name" --short-name="App Short Name" --organization-name="myhome" --firebase-name="firebaseProjectId" --worker-key="yourWorkerKey" --main-color="FCB126"
```
<!--Todos
각 parameter에 대한 설명을 별도의 페이지로 만들어 직접 변경을 원하는 사람들에 대한 가이드도 제공할 것
-->
> [!NOTE]
> * If the project name, full name, and short name are all the same, you can enter only the project name.
> * The project name can only contain alphabets, and a combination of two words is recommended.
> * The project name and organization name are used to create each bundle ID for use in the App Store and Play Store. The bundle ID must be unique, so please decide carefully.
> * To find the Firebase project ID, go to your Firebase project page -> click the settings button on the left -> select Project settings -> copy Project ID.
> * The worker key is used to store media files using Cloudflare's R2. This is optional, and you can enter your desired password.
> * The default media file storage is Firebase Cloud Storage, so no separate settings are required.
> * You can set up Cloudflare R2 as your media file storage, by following [this guide](#configure-cloudflare-r2-optional).
> * The full name, short name, worker key, main color ​​can be changed later.

* Prepare images to be used for the app icon and launch screen.
<!--Todos 피그마 공유 템플릿 파일 만들고 링크 제공할 것-->
> [!NOTE]
> * app-bar-logo.png - 128 * 128 (Margin of about 4 px, no background)
> * app-icon-512.png - 512 * 512 (Use an image of 1024 px)
> * app-icon-1024.png - 1024 * 1024 (Margin of about 160 px)
> * app-logo-android12.png - 960 * 960 (Margin of about 240, no background)
> * app-logo.png - 720 * 720 (Margin of about 8 px, no background)
* Press ```Cmd``` + ```SpaceBar```, type your applimode project name. (or Open **Finder**)
* Open your project folder (maybe in the projects folder), open the **assets** folder, and then open the **images** folder.
* Replace the image files in the folder with the image files you prepared.
* Go back to **VSCode**.
* Click **File** (on the top menu of VSCode), select **Open Folder**, choose your project folder (maybe in the **projects** folder), and click **Open**.
* Click **View** (on the top menu of VSCode), then select **Terminal**.
* Run the following commands in order:
```sh
flutter pub get
```
```sh
dart run flutter_native_splash:create
```
```sh
flutter pub run flutter_launcher_icons
```
```sh
dart run build_runner build -d
```
```sh
flutterfire configure
```
> when asked something, press **n** or **N**.
```sh
firebase deploy --only firestore
```
```sh
firebase deploy --only storage
```
* If you want to enter commands all at once, run the following command:
```sh
flutter pub get; dart run flutter_native_splash:create; flutter pub run flutter_launcher_icons; dart run build_runner build -d; flutterfire configure; firebase deploy --only firestore; firebase deploy --only storage;
```
* Open [Google Cloud console](https://console.cloud.google.com/) in your web browser.
* Sign up or log in.
* Select your project on the top left.
* Click **Activate Cloud Shell** on the top right.
![gcp-console-head](https://github.com/mycalls/applimode-examples/blob/main/assets/gcp-console-head.png?raw=true)
* Run the following command in the shell at the bottom.
```sh
echo '[{"origin": ["*"],"method": ["GET"],"maxAgeSeconds": 3600}]' > cors.json
```
<!--
> touch cors.json
> nano cors.json
[
  {
    "origin": ["*"],
    "method": ["GET"],
    "maxAgeSeconds": 3600
  }
]
-->
* Open your [Firebase console](https://console.firebase.google.com/) in your web browser. 
* Click your project.
* Click **Storage** (on the left sidebar).
* Click the Copy folder path icon (to the right of the URL starting with **gs://**) to copy your cloud storage bucket.
![fb-storage-head](https://github.com/mycalls/applimode-examples/blob/main/assets/fb-storage-head.png?raw=true)
* Go back to your Google Cloud console.
* Run the following commands in the shell at the bottom.
```sh
gsutil cors set cors.json gs://<your-cloud-storage-bucket>
```
```sh
exit
```



## Test drive
> [!IMPORTANT]
> Do this chapter after your Firestore indexing is complete. (about 5 minutes) You can check your Firestore indexing here. [Firebase console](https://console.firebase.google.com/) > your project > Firestore Database > Indexes

#### iOS
* If you haven't enrolled in the [Apple Developer program](https://developer.apple.com/programs/), enroll now.

> To learn more about membership types, check out [Choosing a Membership](https://developer.apple.com/support/compare-memberships).

* Tap on **Settings** > **Privacy & Security** > **Developer Mode** on your iOS device.
* Tap to toggle **Developer Mode** to On.
* Tap **Restart**.
* When the **Turn on Developer Mode?** dialog appears, tap **Turn On**.
* Open or move to **VSCode**.
* If necessary, open your Applimode project. (**File** > **Open Folder**)
* Attach your iOS device to the USB port on your Mac.
* Press ```Command``` + ```Shift``` + ```P```. (or choose **View** > **Command Palette**)
* Type *flutter* and select the **Flutter: Select Device**.
* Select your iOS device from the **Select Device** prompt.
* Click the built-in terminal at the bottom. (or choose **View** > **Terminal**)
* Run the following commands.
```sh
cd ios
```
```sh
rm -rf Pods
```
```sh
rm -rf Podfile.lock
```
```sh
pod install --repo-update
```
```sh
cd ..
```
```sh
open ios/Runner.xcworkspace
```
<!--
```sh
cd ios; rm -rf Pods; rm -rf Podfile.lock; pod install --repo-update; cd ..; open ios/Runner.xcworkspace;
```
-->
* Your Applimode project will open in Xcode.
* In the left navigation panel under **Targets**, select **Runner**.
* In the **Runner settings** pane, click **Signing & Capabilities**.
* Select **All** at the top.
* Select **Automatically manage signing**.
* Select a team from the **Team** dropdown menu.
![xcode-sign](https://github.com/mycalls/applimode-examples/blob/main/assets/xcode-sign.png?raw=true)
> [!NOTE]
> * Teams are created in the App Store Connect section of your Apple Developer Account page. If you have not created a team, you can choose a personal team.
> * The Team dropdown displays that option as Your Name (Personal Team).
* Click **Product** (on the top menu of Xcode), then click **Scheme**, and finally click **Edit Scheme**.
* Click **Run** in the left panel.
* Select **Release** from the **Build Configuration** dropdown menu in the **Info** tab.
* Click the play icon button on the top left. (or press ```Command``` + ```R```)
> [!NOTE]
> * If you receive an **Untrusted Developer** error message on your iOS device, follow these steps.
> 1. On your iOS device, open **Settings**.
> 2. Choose **General** > **VPN & Device Management**.
> 3. Choose the affected profile and trust it.

> [!NOTE]
> * If you receive an **iproxy** error message on your mac, follow these steps.
> 1. On your mac, open **System settings**.
> 2. Choose **Privacy and Security** > **VPN & Device Management**.
> 3. Scroll down and click **Allow anyway**.
* After your app build completes, follow [this chapter](#after-your-app-build-completes).

#### Web or Android 
* Open or move to **VSCode**.
* If necessary, open your Applimode project. (**File** > **Open Folder**)
* Press ```Command``` + ```Shift``` + ```P```. (or choose **View** > **Command Palette**)
* Type *flutter* and select the **Flutter: Select Device**.
* Select a target device from the Select Device prompt.
* Click Run (on the top menu of VSCode) and select **Start Debugging**. (or press ```F5``` or ```fn``` + ```F5```)

#### After your app build completes
* After the app build completes, click the write button on the bottom right.
* Click **Register** on the login screen and complete your signup.
* Click the write button and write the first post. (if you are testing Cloudflare R2 or CDN, write the post with an image or a video)
* To end the test drive, click **Run** (on the top menu of VSCode) and select **Stop Debugging**. (or press ```Shift``` + ```F5``` or ```Shift``` + ```fn``` + ```F5```)
> [!NOTE]
> * In debugging mode, the performance of most apps becomes very slow. Don't worry about the performance because Applimode in release mode is very fast.
> * Select Chrome or Edge for web apps.
> * To enable Developer options and USB debugging on your android device, refer to [this page](https://developer.android.com/studio/debug/dev-options).
> * If you connect an Android device but it does not appear in the device list, try changing the USB Preferences to Charging or File transfers.
<!-- * To enable them, go to Settings > About phone > Software information (there may not be) > Build number, click 7 times in a row. Return to the previous screen to find Developer options at the bottom. Then turn on USB debugging.-->



## Add administrator
* Open your [Firebase console](https://console.firebase.google.com/) in your web browser. 
* Click your project.
* Click **Authentication** (on the left sidebar).
* Click the **Copy UID** button next to your **User UID**. (Move your mouse cursor over your **User UID** to display the button)
![fb-auth-head](https://github.com/mycalls/applimode-examples/blob/main/assets/fb-auth-head.png?raw=true)
* Click **Firestore Database** (on the left sidebar).
* Click the users collection and select your uid.
* Click the **Edit field** button (pencil shape) next to the **isAdmin** field. (Move your mouse cursor over the **isAdmin** field to display the **Edid field** button)
![fb-firestore-isadmin](https://github.com/mycalls/applimode-examples/blob/main/assets/fb-firestore-isadmin.png?raw=true)
* Change the value from **false** to **true** and click **Update**.
* Click **Rules** (on the top menu).
* Change the first word **adminUid** in line 8 (or near it) to your uid. (paste your uid)
> ex) return request.auth.uid in ["9a6sIEiAldOzFIZ9hO2SxaG6Db63", "adminUid"];
![fb-firestore-rules](https://github.com/mycalls/applimode-examples/blob/main/assets/fb-firestore-rules.png?raw=true)
* Click **Publish**
> [!CAUTION]
> If you designate someone as an administrator, the user can change admin settings in the app, edit, delete or block all posts, and even block all posts from a specific user.



## Admin settings and custom settings
> [!NOTE]
> * If you change the custom settings file, you must rebuild it to apply it to your app.
> * When changing Admin settings, users fetch the values ​​on your app's first startup, and the values ​​are applied on your app's second startup.
> * The default minimum fetch interval for Admin settings is 600 seconds (10 minutes), and you can change it in the custom settings file.

* [Add administrator](#add-administrator) is required first to activate the Admin Settings tab in your app.
* Open(```F5```) or hot restart(```Command``` + ```Shift``` + ```F5```) your Applimode app. (You can need the ```fn``` key)
* Click the menu button on the top left of the home screen.
* Click **Admin settings**. (If you can't find the Admin settings tab, restart your app.)
* After changing the settings, click Save at the bottom.
<!--todos 각 설정에 대한 상세 설명 페이지 만들고 여기에 링크 추가-->
* To change the custom settings, open VSCode.
* Click **File** (on the top menu of VSCode) and select **Open Folder**.
* Select your project folder (maybe in the **projects** folder) and click **Open**.
* Press ```Command``` + ```P``` and type *custom_settings.dart*, then click.
* Change appCreator and appVersion to your desired values.
> [!IMPORTANT]
> fullAppName, shortAppName, underbarAppName, camelAppName, androidBundleId, appleBundleId, and firebaseProjectName are values ​​used when upgrading your project. Do not change them. If you want to make changes, refer to [this chapter](#configure-your-project) and configure your project again.
* The values ​​with **spare** in front of the name are ​​used when users first run your app after installing it. (when Admin settings are not yet activated). You can change them to whatever values you want.
* If you want to register your app on the App Store or Play Store, add the corresponding links to **termsUrl** and **privacyUrl**.
* If you change the value of **isInitialSignIn** to true, only logged in users will be able to use your app. You can also use Cloud Firestore Security Rules for even stronger security. Please read [this chapter](#configure-cloud-firestore-security-rules) for more details.
* If you change the value of **adminOnlyWrite** to true, only users designated as administrators can write posts.
* Read [this chapter](#configure-push-notification-optional) to change the values ​​of **useFcmMessage**, **fcmVapidKey**, and **useApns** to true.
* When you have made all changes, press ```Command``` + ```S```.
* We will prepare more detailed information on all values ​​of Admin settings and Custom settings soon.



## Build an iOS app
> [!CAUTION]
The content of this section will be updated in the future. For more details, refer to [this page](https://docs.flutter.dev/deployment/ios).
<!--todos 내용 추가해 줄 것-->



## Build an Android app
* Open **VSCode**.
* Click **File** (on the top menu of VSCode) and select **Open Folder**.
* Select your project folder and click **Open**.
* Click **View** (on the top menu of VSCode) and select **Terminal**.
* Run the following command:
```sh
flutter build apk --release --target-platform=android-arm64
```
> [!IMPORTANT]
> If you change the custom settings file, you need to re-run the command to update your app.
* You can find your apk file here: 
**\<your-project-folder\>\build\app\outputs\apk\release** or **\<your-project-folder\>\build\app\outputs\flutter-apk\app-release.apk**
> For more details, visit [this link](https://docs.flutter.dev/deployment/android#build-the-app-for-release).



## Build a web app
<!--
// build/web
> firebase init
> flutter build web --release
> flutter build web --release --web-renderer=html
> flutter build web --release --web-renderer=canvaskit
> firebase deploy
> firebase deploy --only hosting
-->
* Open **VSCode**.
* Click **File** (on the top menu of VSCode) and select **Open Folder**.
* Select your project folder and click **Open**.
* Click **View** (on the top menu of VSCode) and select **Terminal**.
* Run the following command:
```sh
flutter build web --release --web-renderer=html
```
```sh
firebase deploy --only hosting
```
> [!IMPORTANT]
> If you change the custom settings file, you need to re-run the commands to update your app.
* Open your [Firebase console](https://console.firebase.google.com/) in your web browser. 
* Click your project.
* Click **Hosting** (on the left sidebar).
* Scroll down to find the **Domains** section.
* Click the domain address.
* If you want to use your custom domain, read [this chapter](#use-your-custom-domain-optional).
* Please visit [this page]() for how to install a PWA(Progressive Web App) on your phone and computer.
<!--todos pwa 설치 방법 페이지 만들고 링크 추가-->



## Configure Cloudflare R2 (Optional)
> [!NOTE]
> * The biggest advantage of R2 is that transfer fees are free. (Firebase Cloud Storage is free for transfers up to 1 GB per day, after which a fee of $0.12 is charged for each GB)
> * You can also use Cloudflare's CDN for free by registering a domain and connecting it with R2.
> * If you are building a video-centric app, I highly recommend using Cloudflare R2.
> * [R2 pricing plans](https://developers.cloudflare.com/r2/pricing/)
> * [Workers pricing plans](https://developers.cloudflare.com/workers/platform/pricing/)
* Go to the [Cloudflare console](https://dash.cloudflare.com/sign-up).
* Sign up or log in.
* Click **R2** (on the left sidebar).
* Fill out the **R2** subscription form and complete the **R2** subscription.
* Open **Terminal**.
* Run the following commands.
```sh
cd ~/projects
```
```sh
npm create cloudflare@latest <your_r2_worker_name>
```
> ex) npm create cloudflare@latest applimode-r2-worker
* Select default values ​​for all questions.
* Open **VSCode**.
* Click **File** (on the top menu of VSCode) and select **Open Folder**.
* Select the <your_r2_worker_name> folder and click **Open**.
* Click **View** (on the top menu of VSCode) and select **Terminal**.
* Run the following command:
```sh
npx wrangler r2 bucket create <your_r2_bucket_name>
```
> ex) npx wrangler r2 bucket create applimode-bucket
* Press ```Command``` + ```P``` and type *wrangler.toml*, then click.
* Add the following to the end of your wrangler.toml file.
```
account_id = "YOUR_ACCOUNT_ID" # ← Replace with your Account ID.
workers_dev = true

[[r2_buckets]]
binding = "MY_BUCKET"
bucket_name = "YOUR_BUCKET_NAME" # ← Replace with your bucket name.
```
* Update **account_id** and **bucket_name**.
> * To find your account ID and bucket name, go to [Cloudflare dashboard](https://dash.cloudflare.com/) and click R2 (on the left sidebar).
> * Click the **Click to copy** button below **Account ID** on the right side.
> * Copy your bucket name below **Buckets** on the center side.
![cf-r2-overview](https://github.com/mycalls/applimode-examples/blob/main/assets/cf-r2-overview.png?raw=true)
<!-->
> * Or you can also find them using the following commands
```sh
npx wrangler whoami 
```
```sh
npx wrangler r2 bucket list
```
-->
* To save, press ```Command``` + ```S```. (or **File** > **Save**)
<!--
* Click **File** (on the top menu of VSCode) and select **New Window**.
* Click **File** (on the top menu of VSCode) and select **Open Folder**.
* Select the <your_applimode_project_name> folder and click **Open**. (maybe in your **projects** folder)
* Press ```Command``` + ```P``` and type *r2_worker.index.ts* and click.
* Press ```Command``` + ```A``` and press ```Command``` + ```C```.
 -->
* Open this [page](https://github.com/mycalls/applimode-examples/blob/main/r_two_Worker/r2_worker.index.ts) and click the **Copy raw file** button (next to the **Raw** button) on the upper-right corner of the file view.
![copy-raw-file](https://github.com/mycalls/applimode-examples/blob/main/assets/gh-copy-raw-file.png?raw=true)
* Go back to VSCode.
* Press ```Command``` + ```P``` and type *index.ts*, then click.
* Press ```Command``` + ```A``` and press ```Command``` + ```V```.
* To save, press ```Command``` + ```S```. (or **File** > **Save**)
* Click **Terminal** at the bottom of VSCode and run the following commands.
```
npx wrangler secret put AUTH_KEY_SECRET
```
<!--Enter a secret value:-->
* Type your worker key that you entered in the [Configure your project](#configure-your-project) section.
```
npx wrangler deploy
```
* Click **File** (on the top menu of VSCode) and select **Open Folder**.
* Select your project folder (maybe in the **projects** folder) and click **Open**.
* Press ```Command``` + ```P``` and type *custom_settings.dart*, then click.
* Press ```Command``` + ```F``` and type *useRTwoStorage*.
* Change the useRTwoStorage value from **false** to **true**.
> ex) const bool useRTwoStorage = true;
* Go to the [Cloudflare dashboard](https://dash.cloudflare.com/).
* Go to Workers & Pages (on the left sidebar) and in Overview, select your Worker.
* Go to Settings > Triggers > Routes.
* Copy your route.
![cf-workers-triggers](https://github.com/mycalls/applimode-examples/blob/main/assets/cf-workers-triggers.png?raw=true)
* Go back to VSCode.
* Press ```Command``` + ```F``` and type *rTwoBaseUrl*.
* Change the rTwoBaseUrl value from **yourR2WorkerUrl** to the route you copied.
> ex) const String rTwoBaseUrl = 'applimode-r2-worker.yourID.workers.dev';
* Press ```Command``` + ```S```. (or **File** > **Save**)
* To make sure it works well, follow the [Test drive](#test-drive) chapter.



## Configure Cloudflare D1 (Optional)
> [!NOTE]
> * Applimode supports hashtag search by default. Search is possible only if the user adds # in front of the word when writing a post.
> * If you only want to use hashtag search, skip this chapter, or if you want to use full-text search, follow this chapter.
> * [D1 pricing plans](https://developers.cloudflare.com/d1/platform/pricing/)
* Open **Terminal**.
* Run the following commands.
```sh
cd ~/projects
```
```sh
npm create cloudflare@latest <your_d1_worker_name>
```
> ex) npm create cloudflare@latest applimode-d1-worker
* Select default values ​​for all questions.
* Open **VSCode**.
* Click **File** (on the top menu of VSCode) and select **Open Folder**.
* Select the <your_d1_worker_name> folder and click **Open**.
* Click **View** (on the top menu of VSCode) and select **Terminal**.
* Run the following command:
```sh
npx wrangler d1 create <db-name>
```
> ex) npx wrangler d1 create applimode-d1
* Copy the following part of the output.
```
[[d1_databases]]
binding = "DB" # i.e. available in your Worker on env.DB
database_name = "applimode-d1"
database_id = "<unique-ID-for-your-database>"
```
* Press ```Command``` + ```P``` and type *wrangler.toml*, then click.
* Add the part you copied to the end of your wrangler.toml file.
* To save, press ```Command``` + ```S```. (or **File** > **Save**)
* Open this [page](https://github.com/mycalls/applimode-examples/blob/main/d_one_worker/d1.posts.sql) and click the **Copy raw file** button (next to the **Raw** button) on the upper-right corner of the file view.
* Go back to VSCode.
* Click **File** and click **New File...**. (or click the New File button)
![vscode-new-file](https://github.com/mycalls/applimode-examples/blob/main/assets/vs-create-file.png?raw=true)
* Type posts.sql and press **Enter** and click **Create File**. (in your project root folder)
* To paste and save, press ```Command``` + ```V``` and ```Command``` + ```S```.
* Open this [page](https://github.com/mycalls/applimode-examples/blob/main/d_one_worker/d1_worker.index.ts) and click the **Copy raw file** button (next to the **Raw** button) on the upper-right corner of the file view.
* Go back to VSCode.
* Press ```Command``` + ```P``` and type *index.ts*, then click.
* Press ```Command``` + ```A``` and press ```Command``` + ```V```.
* To save, press ```Command``` + ```S```.
* Click **Terminal** on the bottom of VSCode and run the following commands. (To find your your-d1-db-name, go to the **wrangler.toml** file, refer to **database_name**)
```
npx wrangler d1 execute <your-d1-db-name> --remote --file=./posts.sql
```
```
npx wrangler deploy
```
* Click **File** (on the top menu of VSCode) and select **Open Folder**.
* Select your project folder (maybe in the **projects** folder) and click **Open**.
* Press ```Command``` + ```P``` and type *custom_settings.dart*, then click.
* Press ```Command``` + ```F``` and type *useDOneForSearch*.
* Change the useDOneForSearch value from **false** to **true**.
> ex) const bool useDOneForSearch = true;
* Go to the [Cloudflare dashboard](https://dash.cloudflare.com/).
* Go to Workers & Pages (on the left sidebar) and in Overview, select your Worker.
* Go to Settings > Triggers > Routes.
* Copy your route.
* Go back to VSCode.
* Press ```Command``` + ```F``` and type *dOneBaseUrl*.
* Change the dOneBaseUrl value from **yourD1WorkerUrl** to the route you copied.
> ex) const String rTwoBaseUrl = 'applimode-d1-worker.yourID.workers.dev';
* Press ```Command``` + ```S```. (or **File** > **Save**)
* To make sure it works well, follow the [Test drive](#test-drive) chapter.



## Configure Cloudflare CDN (Optional)
> [!IMPORTANT]
> * To use Cloudflare's CDN, your domain must be registered with Cloudflare.
> * If you don't have a domain, go to the [Cloudflare console](https://dash.cloudflare.com/) and click **Domain Registration** (on the left sidebar) and click **Register Domain**.
> * If you need to transfer your domain to cloudflare, go to the [Cloudflare console](https://dash.cloudflare.com/) and click **Domain Registration** (on the left sidebar) and click **Transfer Domain**.
> * [Domain registration documentation](https://developers.cloudflare.com/registrar/get-started/register-domain)
> * [Domain transfer documentation](https://developers.cloudflare.com/registrar/get-started/transfer-domain-to-cloudflare/)

* Go to the [Cloudflare console](https://dash.cloudflare.com/).
* Click **R2** (on the left sidebar) and in **Overview**, select the bucket you want.
* Click **Settings** on the top, scroll down to find the **Public access** section.
* In **Custom Domains**, click **Connect Dommain**.
* Type the domain for CDN and click Continue.
> If you have a domain called applimode.com, type a sub domain like *<n>media.<n>applimode.<n>com* or *<n>cdn.<n>applimode.<n>com* or *<n>content.<n>applimode.<n>com*.
* Click **Websites** (on the left sidebar) and click your domain.
* Click **Rules** (on the left sidebar) and **Transform Rules** and **Modify Response Header** (on the tab menu).
* Click **+ Create rule**.
* Type the rule name like *applimode-r2-cors*.
* Select **Custom filter expression**.
* In **Field**, select **Hostname** and in **Operator**, select **equals** and in **Value, type the sub domain you connected to your R2 bucket. (like *<n>media.<n>applimode.<n>com* or *<n>cdn.<n>applimode.<n>com* or *<n>content.<n>applimode.<n>com*)
* In **Select item**, select **Add**.
* In Header name, copy and paste the following expression.
```
access-control-allow-origin
```
* In Value, type __*__.
* Click **Deploy**.
![cf-websites-rules](https://github.com/mycalls/applimode-examples/blob/main/assets/cf-websites-rules.png?raw=true)
* Open or go back to VSCode.
* Click **File** (on the top menu of VSCode) and select **Open Folder** and select your project folder (maybe in the **projects** folder) and click **Open**.
* Press ```Command``` + ```P``` and type *custom_settings.dart*, then click.
* Press ```Command``` + ```F``` and type *useCfCdn*.
* Change the useCfCdn value from **false** to **true**.
> ex) const bool useCfCdn = true;
* Press ```Command``` + ```F``` and type *cfDomainUrl*.
* Change the cfDomainUrl value from **yourCustomDomainUrl** to the sub domain you connected to your R2 bucket. (like *<n>media.<n>applimode.<n>com* or *<n>cdn.<n>applimode.<n>com* or *<n>content.<n>applimode.<n>com*)
> ex) const String cfDomainUrl = 'media.applimod.com';
* Press ```Command``` + ```S```. (or **File** > **Save**)
* To make sure it works well, follow the [Test drive](#test-drive) chapter.



## Configure Youtube image proxy (Optional)
> [!NOTE]
> * In posts containing YouTube links, there are cases where the preview image cannot be retrieved due to CORS issues.
> * You can solve this problem by configuring a proxy worker for YouTube images.
* Open **Terminal**.
* Run the following commands.
```sh
cd ~/projects
```
```sh
npm create cloudflare@latest yt-thumbnail-worker
```
* Select default values ​​for all questions.
* Open this [page](https://github.com/mycalls/applimode-examples/blob/main/yt_thumbnail_worker/yt_thumbnail_worker.index.ts) and click the **Copy raw file** button (next to the **Raw** button) on the upper-right corner of the file view.
* Open **VSCode**.
* Click **File** (on the top menu of VSCode) and select **Open Folder**.
* Select the **yt-thumbnail-worker** folder and click **Open**.
* Press ```Command``` + ```P``` and type *index.ts* and click.
* Press ```Command``` + ```A``` and press ```Command``` + ```V```.
* To save, press ```Command``` + ```S```.
* Click **View** (on the top menu of VSCode) and select **Terminal**.
* Run the following command.
```
npx wrangler deploy
```
* Go to the [Cloudflare dashboard](https://dash.cloudflare.com/).
* Go to Workers & Pages (on the left sidebar) and in Overview, click **yt-thumbnail-worker**.
* Go to Settings > Triggers > Routes.
* Copy your route.
* Go back to VSCode.
* Click **File** (on the top menu of VSCode) and select **Open Folder** and select your project folder (maybe in the **projects** folder) and click **Open**.
* Press ```Command``` + ```P``` and type *custom_settings.dart* and click.
* Press ```Command``` + ```F``` and type *youtubeImageProxyUrl*.
* Change the youtubeImageProxyUrl value from **yt-thumbnail-worker.jongsukoh80.workers.dev** to the route you copied.
> ex) const String rTwoBaseUrl = 'yt-thumbnail-worker.yourID.workers.dev';
* Press ```Command``` + ```S```. (or **File** > **Save**)



## Configure Youtube video proxy (Optional)
> [!NOTE]
> * When opening a YouTube video in a post, the page where the video is embedded is sent.
> * If not configured, <n>youtube-nocookie.<n>com will be used.
* Open **Terminal**.
* Run the following commands.
```sh
cd ~/projects
```
```sh
npm create cloudflare@latest yt-iframe-wroker
```
* Select default values ​​for all questions.
* Open this [page](https://github.com/mycalls/applimode-examples/blob/main/yt_iframe_worker/yt_iframe_worker.index.ts) and click the **Copy raw file** button (next to the **Raw** button) on the upper-right corner of the file view.
* Open **VSCode**.
* Click **File** (on the top menu of VSCode) and select **Open Folder**.
* Select the **yt_iframe_worker** folder and click **Open**.
* Press ```Command``` + ```P``` and type *index.ts* and click.
* Press ```Command``` + ```A``` and press ```Command``` + ```V```.
* To save, press ```Command``` + ```S```.
* Click **View** (on the top menu of VSCode) and select **Terminal**.
* Run the following command.
```
npx wrangler deploy
```
* Go to the [Cloudflare dashboard](https://dash.cloudflare.com/).
* Go to Workers & Pages (on the left sidebar) and in Overview, click **yt-iframe-wroker**.
* Go to Settings > Triggers > Routes.
* Copy your route.
* Go back to VSCode.
* Click **File** (on the top menu of VSCode) and select **Open Folder** and select your project folder (maybe in the **projects** folder) and click **Open**.
* Press ```Command``` + ```P``` and type *custom_settings.dart* and click.
* Press ```Command``` + ```F``` and type *youtubeIframeProxyUrl*.
* Paste the route you copied in the youtubeIframeProxyUrl value.
> ex) const String youtubeIframeProxyUrl = 'yt-iframe-worker.yourID.workers.dev';
* Press ```Command``` + ```S```. (or **File** > **Save**)



## Configure push notification (Optional)
> [!NOTE]
> * Firebase has two pricing plans: the Spark Plan (aka the free plan) and the Blaze Plan (aka the pay-as-you-go plan).
> * To use push notifications, you must use Firebase's Blaze Plan.
> * For more details, visit this [page](https://firebase.google.com/docs/projects/billing/firebase-pricing-plans).
> * To use APNs (Apple Push Notification service), you must register for [Apple Developer Program](https://developer.apple.com/programs/). (99 USD)
> * Currently, Safari on iOS and macOS does not support push notifications. (web app and PWA on iOS and macOS)
<!--
> * Visit [this page](https://firebase.flutter.dev/docs/messaging/apple-integration), for more details for Apple integration.
-->
* Go to the [Firebase console](https://console.firebase.google.com/).
* Click your project.
* Click **Upgrade** on the bottom of the left sidebar.
* Click **Select plan**.
* Click the settings button on the top of the left sidebar.
* Click **Project settings**.
![fb-project-settings](https://github.com/mycalls/applimode-examples/blob/main/assets/fb-project-settings.png?raw=true)
* Open or go back to VSCode.
* Click **File** (on the top menu of VSCode) and select **Open Folder** and select your project folder (maybe in the **projects** folder) and click **Open**.
* Click **View** (on the top menu of VSCode) and select **Terminal**.
* Run the following commands.
<!--
```
firebase init functions
```
-->
```
cd functions
```
```
npm install
```
```
firebase deploy --only functions
```
```
cd ..
```
* Press ```Command``` + ```P``` and type *index.html* and click.
* Change lines 111 to 125 with the following content.
```html
<!--
<script src="flutter_bootstrap.js" async=""></script>
-->
<!--When using push notification for web app-->
<script src="flutter_bootstrap.js" async="">
  if ('serviceWorker' in navigator) {
    // Service workers are supported. Use them.
    window.addEventListener('load', function () {
      // Register Firebase Messaging service worker.
      navigator.serviceWorker.register('firebase-messaging-sw.js', {
        scope: '/firebase-cloud-messaging-push-scope',
      });
    });
  }
</script>
```
* To save, press ```Command``` + ```S```.
* Press ```Command``` + ```P``` and type *custom_settings.dart* and click.
* Press ```Command``` + ```F``` and type *useFcmMessage*.
* Change the useFcmMessage value from **false** to **true**.
> ex) const bool useFcmMessage = true;
* Go to your web browser with the project settings page open.
* Click Cloud Messaging on the top tab menu and scroll to the bottom.
* Copy Key pair of Web Push certificates.
![fb-cloud-message-web](https://github.com/mycalls/applimode-examples/blob/main/assets/fb-cloud-message-web.png?raw=true)
* Go back to VSCode.
* Paste the Key pair you copied in the fcmVapidKey value.
> ex) const String fcmVapidKey = 'very-long-key-pair';
* Press ```Command``` + ```S```. (or **File** > **Save**)
* Go to your web browser with the project settings page open.
* Click General on the top tab menu and scroll down.
* In the Your apps section, click the Web apps part.
* Copy all content of the **firebaseConfig** part.
```
apiKey: "project-api-key",
authDomain: "your-project.firebaseapp.com",
projectId: "your-project-id",
storageBucket: "your-project.appspot.com",
messagingSenderId: "000000000000",
appId: "0:000000000000:web:0000000000000000000000",
measurementId: "0-0000000000"
```
<!--![fb-general-firebase-config](https://github.com/mycalls/applimode-examples/blob/main/assets/fb-general-firebase-config.png?raw=true)-->
* Go back to VSCode.
* Press ```Command``` + ```P``` and type *firebase-messaging-sw.js* and click.
* Select the content from apiKey to measurementId (maybe lines from 7 to 13) and paste the content you copied.
* Press ```Command``` + ```S```. (or **File** > **Save**)
<!--
iOS APNS 사용하기 위해서 링크 참고
https://firebase.flutter.dev/docs/messaging/apple-integration
custom_settings 에서 useApns 변경
-->
* Open your [Apple Developer page](https://developer.apple.com/membercenter/index.action) in your web browser.
* Click **Keys** in the **Certificates, IDs & Profiles** section.
* Click the blue plus button.
* Enter a name of the key in the **Key Name** box. (anything is OK)
* Enalbe **Apple Push Notifications service (APNs)**.
* Click **Continue** & then **Save**.
* Once saved, you will be presented with a screen displaying the private **Key ID** & the ability to download the key. Copy the ID, and click **Download** to download the file to your local machine.
![copy-key-id](https://firebase.flutter.dev/assets/images/ios-apple-dev-copy-download-d865d57ffeb870bc011b00eb8e6ca175.png)
* Open your [Firebase console](https://console.firebase.google.com/project/_/settings/cloudmessaging) in your web browser.
* Click your project.
<!--
* On the **Firebase Console**, navigate to the **Project settings** and select the **Cloud Messaging** tab.
-->
* Select your iOS application under the **Apple app configuration** heading.
* Click **Upload** under the **APNs Authentication Key** heading.
* Upload the downloaded file and enter the Key & Team IDs.
> [!NOTE]
> To find your **Team ID**, open [this page](https://developer.apple.com/account) in your web browser. Then, press ```Command``` + ```F``` and type *team id*.
<!--
![upload-apns-file](https://images.prismic.io/invertase/74bd1df4-c9e9-465c-9e0f-cacf6e26d68c_7539b8ec-c310-40dd-91e5-69f19009786f_apple-fcm-upload-key.gif)
-->
* Go back to your project open in **Xcode**. (if you closed **Xcode**, refer to [this section](#open-your-applimode-project-in-xcode))
* Select your project.
* Select the project target.
* Select the **Signing & Capabilities** tab.
![xcode-signing](https://firebase.flutter.dev/assets/images/ios-signing-capabilities-e74450e3f1cd627127e033075610940a.png)
* Click on the **+ Capabilities** button.
* Search for *Push Notifications*.
![apns-push](https://firebase.flutter.dev/assets/images/ios-enable-push-notifications-8a3043ac972a837a545f79bb30bddeec.png)
* Once selected, the capability will be shown below the other enabled capabilities. If no option appears when searching, the capability may already be enabled.
* Click on the **+ Capabilities** button.
* Search for **Background Modes**.
* Once selected, the capability will be shown below the other enabled capabilities. If no option appears when searching, the capability may already be enabled.
* Ensure that both the **Background fetch** and the **Remote notifications** sub-modes are enabled:
<!--
![apns-background-fetch](https://images.prismic.io/invertase/3a618574-dd9f-4478-9f39-9834d142b2e5_xcode-background-modes-check.gif)
-->
* Copy your **Bundle Identifier**.
![xcode-bundle-id](https://firebase.flutter.dev/assets/images/ios-xcode-bundle-id-9f0f92a850217305ca2e98ab14885019.png)
* Go back to your [Apple Developer page](https://developer.apple.com/membercenter/index.action) in your web browser.
* Click the **Identifiers** side menu item.
* Click the plus button to register a App Identifier.
* Select the **App IDs** option and click **Continue**.
* Select the **App** type option and click **Continue**.
<!--
![apns-identifiers-1](https://images.prismic.io/invertase/944b25ff-8360-456f-8a43-da8c3cd80644_ios-apple-dev-register-app-id2.gif)
-->
* Enter a description for the identifier.
* Enter the **Bundle ID** copied from **Xcode**.
* Scroll down and enable the **Push Notifications** capability (along with any others your app uses).
<!--
![apns-identifiers-2](https://images.prismic.io/invertase/0e711691-ccd2-43ab-9c0c-7696b6790153_apple-identifier.gif)
-->
* Click **Continue**.
* Go back to VSCode.
* Press ```Command``` + ```P``` and type *custom_settings.dart* and click.
* Press ```Command``` + ```F``` and type *useApns*.
* Change the useApns value from **false** to **true**.
> ex) const bool useApns = true;



## Use your custom domain (Optional)
* Open your [Firebase console](https://console.firebase.google.com/) in your web browser. 
* Click your project.
* Click **Hosting** (on the left sidebar).
* Scroll down to find the **Domains** section.
* Click **Add custom domain**.
<!--todos 내용 추가해줄 것-->
<!--
// 확인하는 동안 Records 항목의 Proxy 꺼줄것
// SSL/TLS 설정 Flexible 에서 Full 로 변경할 것
-->



## Upgrade your project with the new Applimode version
* Delete your existing **applimode**(or **applimode-main**) and **applimode-tool** folders. (If they are in your **projects** folder)
* Open **Terminal**.
* Run the following commands.
```sh
cd ~/projects;
```
```sh
git clone https://github.com/mycalls/applimode-tool.git
```
```sh
git clone https://github.com/mycalls/applimode.git
```
```sh
flutter upgrade
```
* Close **Terminal**.
* Open **VSCode**
* Click **File** (on the top menu of VSCode) and select **Open Folder**.
* Select **applimode-tool** (in the **projects** folder) and click **Open**.
* Click **View** (on the top menu of VSCode) and select **Terminal**.
* Modify and run the following command.
```sh
node index.js upgrade --directory-name="your_project_folder_name"
```
> ex) node index.js upgrade --directory-name="my_applimode"
```sh
flutter pub get; dart run flutter_native_splash:create; flutter pub run flutter_launcher_icons; dart run build_runner build -d; flutterfire configure;
```
* Delete your old project folder.



## Configure Cloud Firestore Security Rules 
* If you change the **isInitialSignIn** value to true in the **custom_settings.dart** file, you can enhance security further by modifying your Firestore rules.
* Open this [page](https://github.com/mycalls/applimode-examples/blob/main/fs_authed.firestore.rules) and click the **Copy raw file** button (next to the **Raw** button) on the upper-right corner of the file view.
![copy-raw-file](https://github.com/mycalls/applimode-examples/blob/main/assets/gh-copy-raw-file.png?raw=true)
* Open your [Firebase console](https://console.firebase.google.com/) in your web browser. 
* Click your project.
* Click **Firestore Database** (on the left sidebar).
* Click **Rules** on the top.
* Paste the content you copied.
* Add admin IDs. If you have forgotten how to do this, please follow the [this page](#add-administrator).
* Click **Publish**.
* To configure the rules so that only users you have authorized, not just logged-in users, can access the app, follow these instructions.
* Open this [page](https://github.com/mycalls/applimode-examples/blob/main/fs_verified.firestore.rules) and click the **Copy raw file** button (next to the **Raw** button) on the upper-right corner of the file view.
* Paste the content you copied into the Firestore Rules.
* Add admin IDs and verified IDs.
* Click **Publish**.



## Troubleshooting
* ###### If you don't see images or videos in your uploaded post, follow these steps. (CORS issue)
1. Open [Google Cloud console](https://console.cloud.google.com/) in your web browser.
2. Sign up or log in.
3. Select your project on the top left.
4. Click **Activate Cloud Shell** on the top right.
![gcp-console-head](https://github.com/mycalls/applimode-examples/blob/main/assets/gcp-console-head.png?raw=true)
5. Run the following command in the shell at the bottom.
```sh
echo '[{"origin": ["*"],"method": ["GET"],"maxAgeSeconds": 3600}]' > cors.json
```
<!--
> touch cors.json
> nano cors.json
[
  {
    "origin": ["*"],
    "method": ["GET"],
    "maxAgeSeconds": 3600
  }
]
-->
6. Open your [Firebase console](https://console.firebase.google.com/) in your web browser.
7. Click your project.
8. Click **Storage** (on the left sidebar).
9. Click the Copy folder path icon (on the right of the URL starting with **gs://**) to copy your cloud storage bucket.
![fb-storage-head](https://github.com/mycalls/applimode-examples/blob/main/assets/fb-storage-head.png?raw=true)
10.  Go back to your Google Cloud console.
11.  Run the following command in the shell at the bottom.
```sh
gsutil cors set cors.json gs://<your-cloud-storage-bucket>
```

* ###### If you receive an **Untrusted Developer** error message on your iOS device, follow these steps.
1. On your iOS device, open **Settings**.
2. Choose **General** > **VPN & Device Management**.
3. Choose the affected profile and trust it.

* ###### If you receive an **iproxy** error message on your mac, follow these steps.
1. On your mac, open **System settings**.
2. Choose **Privacy and Security** > **VPN & Device Management**.
3. Scroll down and click **Allow anyway**.

* ###### When building on an iOS device, you receive the following error message:
> In iOS 14+, debug mode Flutter apps can only be launched from Flutter tooling, IDEs with Flutter plugins or from Xcode. Alternatively, build in profile or release modes to enable launching from the home screen.
1. Click **Product** (on the top menu of Xcode), then click **Scheme**, and finally click **Edit Scheme**.
2. Click **Run** in the left panel.
3. Select **Release** from the **Build Configuration** dropdown menu in the **Info** tab.

<!--
// error: Unable to load contents of file list
* Xcode 종료
* VSCode 에서 프로젝트 열고 터미널 열기
> cd ios
> pod deintegrate
> pod update
> cd ..
> open ios/Runner.xcworkspace
* xcode에서 product -> clean 을 해주고 실행
> cd ios; pod deintegrate; pod update; cd ..; open ios/Runner.xcworkspace;
-->

* ###### Additionally, if an error occurs while building on an iOS device, follow the steps below.
1. Close Xcode.
2. Open or move to **VSCode**.
3. If necessary, open your Applimode project. (**File** > **Open Folder**)
4. Click the built-in terminal at the bottom. (or choose **View** > **Terminal**)
5. Run the following commands.
```sh
cd ios
```
```sh
rm -rf Pods
```
```sh
rm -rf Podfile.lock
```
```sh
pod install --repo-update
```
```sh
cd ..
```
```sh
open ios/Runner.xcworkspace
```
<!--
```sh
cd ios; rm -rf Pods; rm -rf Podfile.lock; pod install --repo-update; cd ..; open ios/Runner.xcworkspace;
```
-->
6. Your Applimode project will open in Xcode.
7. Click **Product** (on the top menu of Xcode), then click **Clean Build Folder**.

* ###### If an error occurs when building with an Android device, follow these steps.
1. Open **VSCode**
2. Click **File** (on the top menu of VSCode) and select **Open Folder**.
3. Select your project folder (maybe in the **projects** folder) and click **Open**.
4. Click **View** (on the top menu of VSCode) and select **Terminal**.
5. Run the following commands in order.
```sh
flutter clean
```
```sh
flutter pub cache repair
```
```sh
flutter pub get
```

* ###### If you don't see your Android device in the target device list, follow these steps.
1. Enable Developer options and USB debugging on your android device.
2. To enable Developer options and USB debugging on your android device, refer to [this page](https://developer.android.com/studio/debug/dev-options).
3. Try changing the USB Preferences to Charging or File transfers.
4. Connet again.

* ###### If you cannot upload a post with images or videos attached when using Cloudflare R2, follow these steps.
1. Open **VSCode**.
2. Click **File** (on the top menu of VSCode) and select **Open Folder**.
3. Select your project folder (maybe in the **projects** folder) and click **Open**.
4. Click **View** (on the top menu of VSCode) and select **Terminal**.
5. Run the following commands in order.
```sh
dart run build_runner clean
```
```sh
dart run build_runner build --delete-conflicting-outputs
```

* ##### Open your Applimode project in Xcode
1. Open **VSCode**.
2. Click **File** (on the top menu of VSCode) and select **Open Folder**.
3. Select your project folder (maybe in the **projects** folder) and click **Open**.
4. Click **View** (on the top menu of VSCode) and select **Terminal**.
5. Run the following command.
```sh
open ios/Runner.xcworkspace
```


<!--
// xcode 에서 열기
> open ios/Runner.xcworkspace

// xcode 빌드 에러

// [Xcode] The sandbox is not in sync with the Podfile.lock. Run 'pod install' or update your CocoaPods installation.
* Xcode 종료
* VSCode 에서 프로젝트 열고 터미널 열기
> cd ios
> rm -rf Pods
> rm -rf Podfile.lock
> pod install --repo-update
> cd ..
> open ios/Runner.xcworkspace
* xcode에서 product -> clean 을 해주고 실행
> cd ios; rm -rf Pods; rm -rf Podfile.lock; pod install --repo-update; cd ..; open ios/Runner.xcworkspace;
-->



<!--
// .zshrc
```sh
gsukoh/development/flutter/bin"
export PATH=/opt/homebrew/bin:$PATH
eval "$(rbenv init -)"
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/$
export PATH="$PATH":"$HOME/.pub-cache/bin"
export PATH="$PATH:/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin"
```
-->


