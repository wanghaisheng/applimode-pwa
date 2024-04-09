#!/bin/bash

# echo 'start applimode init'
flutter pub get
dart run flutter_native_splash:create
flutter pub run flutter_launcher_icons
dart run build_runner build -d
flutterfire configure
firebase deploy --only firestore
firebase deploy --only storage
firebase deploy --only remoteconfig
