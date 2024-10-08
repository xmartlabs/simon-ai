import 'dart:io';

import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shake/shake.dart';
import 'package:simon_ai/core/common/config.dart';
import 'package:simon_ai/core/common/logger.dart';

class AppFeedback {
  static void init(BuildContext context) {
    ShakeDetector.autoStart(
      onPhoneShake: () {
        _displayFeedbackWidget(context);
      },
    );
  }

  static void _displayFeedbackWidget(BuildContext context) {
    BetterFeedback.of(context).show((feedback) async {
      final Email email = Email(
        body: feedback.text,
        subject: await _subject(),
        recipients: [Config.feedbackEmail],
        attachmentPaths: await _attachmentFiles(feedback),
        isHTML: false,
      );
      await FlutterEmailSender.send(email);
    });
  }

  static Future<List<String>> _attachmentFiles(UserFeedback feedback) async {
    final String cacheDirectory = (await getTemporaryDirectory()).path;
    final screenshotFilePath =
        await _writeImageToStorage(cacheDirectory, feedback.screenshot);
    return [screenshotFilePath, cacheDirectory + Logger.logFilePath];
  }

  static Future<String> _subject() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final appName = packageInfo.appName;
    final version = packageInfo.version;
    final buildNumber = packageInfo.buildNumber;
    return 'Feedback $appName - v$version($buildNumber)';
  }

  static Future<String> _writeImageToStorage(
    String path,
    Uint8List feedbackScreenshot,
  ) async {
    final String screenshotFilePath = '$path/feedback.png';
    final File screenshotFile = File(screenshotFilePath);
    await screenshotFile.writeAsBytes(feedbackScreenshot);
    return screenshotFilePath;
  }
}
