// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:simon_ai/core/common/environments.dart';
import 'package:simon_ai/core/common/helper/enum_helpers.dart';

interface class Config {
  static const String environmentFolder = 'environments';
  static const String prodBundleId = 'com.xmartlabs.simonai';
  static const String feedbackEmail = 'simonai@xmartlabs.com';

  static const debugMode = kDebugMode;
  static const crashlyticsEnabled = !kIsWeb && !debugMode;
  static const analyticsEnabled = !kIsWeb && !debugMode;

  static const String userCollection = 'users';

  static const cameraResolutionPreset = ResolutionPreset.medium;
  static const numberOfProcessors = 3;

  static const logMlHandlers = true;
  static const logMlHandlersVerbose = false;

  static late Environments environment;

  static Future<void> initialize() async {
    environment = enumFromString(
          Environments.values,
          const String.fromEnvironment('ENV'),
        ) ??
        await getEnvFromBundleId();
  }

  static Future<Environments> getEnvFromBundleId() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName == prodBundleId
        ? Environments.prod
        : Environments.dev;
  }
}
