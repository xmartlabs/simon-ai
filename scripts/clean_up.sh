#!/bin/bash
echo ':: flutter clean ::'
fvm flutter clean

echo ':: flutter pub get ::'
fvm flutter pub get
cd design_system/design_system_gallery && fvm flutter pub get && cd ../..

echo ':: dart run build_runner build --delete-conflicting-outputs ::'
fvm dart run build_runner build --delete-conflicting-outputs
cd design_system && fvm dart run build_runner build --delete-conflicting-outputs && cd ../..
