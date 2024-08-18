import 'dart:async';

import '../text_game_ui.dart';

/// A simple key handler.
class SimpleKeyHandler {
  /// Create an instance.
  const SimpleKeyHandler({
    required this.keys,
  });

  /// Get a default handler to work with [screen].
  ///
  /// The default handler supports [DefaultKeys.quitGame], as well as the cursor
  /// movement keys set on [DefaultKeys].
  SimpleKeyHandler.withDefaults({
    required final GameScreen screen,
    final KeyHandlerKeys extraKeys = const {},
  }) : keys = {
          DefaultKeys.quitGame: () => true,
          for (final MapEntry(key: key, value: direction)
              in defaultMovementKeys.entries)
            key: () {
              try {
                screen
                  ..moveCursor(direction)
                  ..redrawScreen();
              } on InvalidCursorPosition {
                // Do nothing.
              }
              return false;
            },
          ...extraKeys,
        };

  /// The keys to handle.
  final KeyHandlerKeys keys;

  /// The function to handle keys.
  FutureOr<bool> handleKey(final String key) async {
    final handler = keys[key];
    return handler?.call() ?? false;
  }
}
