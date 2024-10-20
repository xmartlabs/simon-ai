import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  AppLocalizations get localizations => AppLocalizations.of(this)!;
}
