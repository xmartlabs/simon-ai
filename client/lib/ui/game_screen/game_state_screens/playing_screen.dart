import 'dart:async';

import 'package:flutter/widgets.dart';

class PlayingGameScreen extends StatefulWidget {
  const PlayingGameScreen({super.key});

  @override
  State<PlayingGameScreen> createState() => _PlayingGameScreenState();
}

class _PlayingGameScreenState extends State<PlayingGameScreen> {
  late final Timer timer;

  @override
  void initState() {
    timer = Timer(
      const Duration(seconds: 30),
      () => print('G'),
    );
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container();
}
