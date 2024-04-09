@echo off
call flutter pub get
call dart run flutter_native_splash:create
call flutter pub run flutter_launcher_icons
call dart run build_runner build -d
call flutterfire configure
call firebase deploy --only firestore
call firebase deploy --only storage
call firebase deploy --only remoteconfig
pause