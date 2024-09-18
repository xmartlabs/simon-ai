import 'package:logger/logger.dart' as dart_log;
import 'package:logger/logger.dart';
import 'package:simon_ai/core/common/config.dart';
import 'package:simon_ai/core/common/crash_report_tool.dart';
import 'package:stack_trace/stack_trace.dart';

interface class Logger {
  static final CrashReportTool _crashReportTool = Config.crashlyticsEnabled
      ? CrashlyticsCrashReportTool()
      : NoOpsCrashReportTool();

  static final dart_log.Logger _instance = dart_log.Logger(
    printer: _CrashReportWrappedPrinter(_CustomDebugLogger(), _crashReportTool),
    filter: _DisplayAllLogFilter(),
    output: MultiOutput([ConsoleOutput()]),
  );

  static Future init() => _crashReportTool.init();

  static void v(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _instance.log(Level.trace, message, error: error, stackTrace: stackTrace);

  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _instance.log(Level.debug, message, error: error, stackTrace: stackTrace);

  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _instance.log(Level.info, message, error: error, stackTrace: stackTrace);

  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _instance.log(
        Level.warning,
        message,
        error: error,
        stackTrace: stackTrace,
      );

  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _instance.log(Level.error, message, error: error, stackTrace: stackTrace);

  static void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _instance.log(Level.off, message, error: error, stackTrace: stackTrace);

  static Future<void> fatal({dynamic error, StackTrace? stackTrace}) async {
    d('Fatal', error, stackTrace);
    await _crashReportTool.logFatal(error, stackTrace);
  }
}

class _DisplayAllLogFilter extends LogFilter {
  // TODO: In the future it should be filtered based on the env
  @override
  bool shouldLog(LogEvent event) => true;
}

class _CrashReportWrappedPrinter extends LogPrinter {
  final LogPrinter _printer;
  final CrashReportTool _crashReportTool;

  _CrashReportWrappedPrinter(this._printer, this._crashReportTool);

  @override
  Future<void> init() => _printer.init();

  StackTrace _currentStacktrace() {
    // Filter: FirebaseCrashlytics.record, _CrashReportWrappedPrinter
    // Logger.log, Logger.e
    final trace = Trace.current(4);
    final frames = trace.frames;
    final newFrames = frames.map(
      (frame) => Frame(
        frame.uri,
        frame.line,
        frame.column,
        frame.member,
      ),
    );
    return _PrintableTrace(newFrames);
  }

  @override
  List<String> log(LogEvent event) {
    final sanitizedEvent = dart_log.LogEvent(
      event.level,
      event.message,
      error: event.error,
      stackTrace: event.stackTrace ?? _currentStacktrace(),
    );
    if (event.level case Level.warning || Level.error) {
      _crashReportTool.logNonFatal(sanitizedEvent);
    }
    return _printer.log(sanitizedEvent);
  }

  @override
  Future<void> destroy() => _printer.destroy();
}

class _PrintableTrace extends Trace {
  _PrintableTrace(super.frames, {super.original});

  // It's equal to VMTrace.toString() Method.
  // Firebase use it to generate the stacktrace
  @override
  String toString() {
    var i = 1;
    return frames.map((frame) {
      final number = '#${i++}'.padRight(8);
      final member = frame.member!
          .replaceAllMapped(
            RegExp(r'[^.]+\.<async>'),
            (match) => '${match[1]}.<${match[1]}_async_body>',
          )
          .replaceAll('<fn>', '<anonymous closure>');
      final line = frame.line ?? 0;
      final column = frame.column ?? 0;
      return '$number$member (${frame.uri}:$line:$column)\n';
    }).join();
  }
}

class _CustomDebugLogger extends LogPrinter {
  final _simpleLogger = SimplePrinter();
  final _prettyPrinter = PrettyPrinter();

  @override
  List<String> log(LogEvent event) =>
      event.level == Level.warning || event.level == Level.error
          ? _prettyPrinter.log(event)
          : _simpleLogger.log(event);

  @override
  Future<void> destroy() async {
    await _simpleLogger.destroy();
    await _prettyPrinter.destroy();
    await super.destroy();
  }
}
