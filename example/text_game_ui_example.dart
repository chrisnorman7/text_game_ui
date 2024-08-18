// ignore_for_file: avoid_print

import 'dart:async';

import 'package:text_game_ui/text_game_ui.dart';

Future<void> main() async {
  final screen = GameScreen.fromLoadedOptions()..redrawScreen();
  await screen.run(
    (final key) {
      if (key == 'q') {
        return true;
      }
      screen
        ..setTile(screen.cursorPosition, key)
        ..moveCursor(GameDirection.right)
        ..redrawScreen();
      return false;
    },
  );
  print('Goodbye.');
}
