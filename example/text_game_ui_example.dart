// ignore_for_file: avoid_print

import 'dart:async';

import 'package:text_game_ui/text_game_ui.dart';

Future<void> main() async {
  final screen = GameScreen.fromLoadedOptions();
  final keyHandler = SimpleKeyHandler.withDefaults(screen: screen);
  screen.redrawScreen();
  await screen.run(keyHandler.handleKey);
  print('Goodbye.');
}
