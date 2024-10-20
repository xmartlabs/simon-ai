// ignore_for_file: unused-code

extension StringExtensions on String {
  bool get isUpperCase => contains(RegExp(r'^[A-Z]+$'));

  bool get isNumber => contains(RegExp(r'^[0-9]+$'));

  bool get isValidEmail =>
      contains(RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'));

  String removePatternSuffix(Pattern suffix) {
    final atIndex = indexOf(suffix);
    return (atIndex != -1) ? substring(0, atIndex) : this;
  }

  String get camelCaseToSnakeCase {
    final sb = StringBuffer();
    var first = true;
    for (final rune in runes) {
      final char = String.fromCharCode(rune);
      if (char.isUpperCase && !first) {
        if (char != '_') {
          sb.write('_');
        }
        sb.write(char.toLowerCase());
      } else {
        first = false;
        sb.write(char.toLowerCase());
      }
    }
    return sb.toString();
  }

  String get addUnderscoreBeforeNumbers {
    final sb = StringBuffer();
    var first = true;
    var prev = '';
    for (final rune in runes) {
      final char = String.fromCharCode(rune);
      if (char.isNumber && !first && !prev.isNumber) {
        sb.write('_');
      }
      first = false;
      sb.write(char);
      prev = char;
    }
    return sb.toString();
  }

  String capitalize() =>
      '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
}

extension NullableStringExtensions on String? {
  bool get isNullOrEmpty => this?.isEmpty ?? true;

  String? ifNullOrBlank(String? Function() func) =>
      this == null || this!.isEmpty ? func() : this;
}
