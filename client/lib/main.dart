import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simon_ai/core/common/config.dart';
import 'package:simon_ai/core/common/logger.dart';
import 'package:simon_ai/core/di/di_provider.dart';
import 'package:simon_ai/firebase_options.dart';
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
  if (!kIsWeb) {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }
  //TODO: Remove this later
  Animate.restartOnHotReload = true;

  await _initFirebaseSdks();
  await Future.wait([
    Logger.init(),
    Config.initialize(),
    DiProvider.init(),
  ]);
}

Future _initFirebaseSdks() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform(
      await Config.getEnvFromBundleId(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
        designSize: const Size(1240, 773),
        minTextAdapt: false,
        splitScreenMode: true,
        builder: (_, __) => const MainScreen(),
      );
}
