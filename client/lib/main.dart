import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simon_ai/core/common/config.dart';
import 'package:simon_ai/core/common/logger.dart';
import 'package:simon_ai/core/di/di_provider.dart';
import 'package:simon_ai/ui/main/main_screen.dart';

Future main() async {
  await runZonedGuarded(
    () async {
      final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      if (!kIsWeb) FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
      await _initSdks();
      runApp(const MyApp());
      if (!kIsWeb) FlutterNativeSplash.remove();
    },
    (exception, stackTrace) =>
        Logger.fatal(error: exception, stackTrace: stackTrace),
  );
}

Future _initSdks() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Logger.init();
  await Config.initialize();
  if (!kIsWeb) {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  await Future.wait([
    DiProvider.init(),
    _initFirebaseSdks(),
  ]);
}

// ignore: avoid-redundant-async
Future _initFirebaseSdks() async {
  // TODO: Add Craslytics, Analytics and other sdks that the project needs
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: false,
        splitScreenMode: true,
        builder: (_, __) => const MainScreen(),
      );
}