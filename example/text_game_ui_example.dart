// ignore_for_file: avoid_print

import 'dart:async';

import 'package:text_game_ui/text_game_ui.dart';

Future<void> main() async {
  final screen = GameScreen.fromLoadedOptions()..redrawScreen();
  await screen.run(
    (final key) {
      if (key == DefaultKeys.quitGame) {
        return true;
      }
      final cursorDirections = <String, GameDirection>{
        DefaultKeys.cursorUp: GameDirection.up,
        DefaultKeys.cursorLeft: GameDirection.left,
        DefaultKeys.cursorDown: GameDirection.down,
        DefaultKeys.cursorRight: GameDirection.right,
      };
      final direction = cursorDirections[key];
      if (direction != null) {
        try {
          screen
            ..moveCursor(direction)
            ..redrawScreen();
        } on InvalidCursorPosition {
          // Do nothing.
        }
      }
      return false;
    },
  );
  print('Goodbye.');
}
