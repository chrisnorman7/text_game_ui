import 'dart:math';

/// Extension methods for moving cursors.
extension PointCursorExtension on Point<int> {
  /// The coordinates above.
  Point<int> get up => Point(x, y - 1);

  /// The coordinates below.
  Point<int> get down => Point(x, y + 1);

  /// The coordinates left.
  Point<int> get left => Point(x - 1, y);

  /// The coordinates right.
  Point<int> get right => Point(x + 1, y);
}
