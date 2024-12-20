#!/bin/bash

# Install Flutter
git clone https://github.com/flutter/flutter.git
export PATH="$PATH:$PWD/flutter/bin"
flutter precache
flutter doctor
flutter --version

# Build the project
flutter build web --release
