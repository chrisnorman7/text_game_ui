// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:text_game_ui/src/game_screen.dart';

Future<void> main() async {
  final screen = GameScreen.fromLoadedOptions()..redrawScreen();
  stdin
    ..echoMode = false
    ..lineMode = false;
  await for (final charCodes in stdin) {
    final character = String.fromCharCodes(charCodes);
    if (character == 'q') {
      break;
    }
    screen.setTile(const Point(0, 1), character);
  }
  print('Goodbye.');
}
