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
      final cursorDirections = <String, GameDirection>{
        'w': GameDirection.up,
        'a': GameDirection.left,
        's': GameDirection.down,
        'd': GameDirection.right,
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
