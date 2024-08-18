// ignore_for_file: avoid_print

import 'dart:async';

import 'package:text_game_ui/text_game_ui.dart';

Future<void> main() async {
  final screen = GameScreen.fromLoadedOptions()..redrawScreen();
  final keyHandler = SimpleKeyHandler.withDefaults(screen: screen);
  await screen.run(keyHandler.handleKey);
  print('Goodbye.');
}
