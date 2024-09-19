#!/bin/bash
echo ':: flutter clean ::'
fvm flutter clean

echo ':: flutter pub get ::'
fvm flutter pub get
cd design_system/design_system_gallery && fvm flutter pub get

echo ':: flutter pub run build_runner build --delete-conflicting-outputs ::'
cd ../.. && fvm flutter pub run build_runner build --delete-conflicting-outputs
