import 'package:flutter/widgets.dart';

extension ContextDeviceSizeExtensions on BuildContext {
  bool get isSmallAndLandscapeDevice =>
      MediaQuery.of(this).orientation == Orientation.landscape &&
      MediaQuery.of(this).size.height < 470;
}
