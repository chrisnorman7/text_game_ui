import 'constants.dart';

/// The top-level exception class.
class TextGameUiException implements Exception {
  /// Create an instance.
  const TextGameUiException(this.message);

  /// The message to show.
  final String message;

  /// Show [message].
  /// Describe this object.
  @override
  String toString() => '$runtimeType: $message';
}

/// The cursor tried to move to an invalid location.
class InvalidCursorPosition extends TextGameUiException {
  /// Create an instance.
  const InvalidCursorPosition(this.cursorPosition)
      : super('The cursor tried to move to $cursorPosition.');

  /// The desired cursor position.
  final CursorPosition cursorPosition;
}
