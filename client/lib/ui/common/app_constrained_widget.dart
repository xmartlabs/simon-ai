import 'package:flutter/material.dart';

class AppConstrainedWidget extends StatelessWidget {
  final Widget child;

  const AppConstrainedWidget({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints(maxWidth: 480),
        child: child,
      );
}
