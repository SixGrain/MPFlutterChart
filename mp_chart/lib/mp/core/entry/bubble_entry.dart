import 'package:mp_chart/mp/core/entry/entry.dart';

class BubbleEntry extends Entry {
  /// size value
  double _size = 0;

  /// Constructor.
  ///
  /// @param x The value on the x-axis.
  /// @param y The value on the y-axis.
  /// @param size The size of the bubble.
  BubbleEntry({
    double size = 0,
    required super.x,
    required super.y,
    super.data,
    super.icon,
  }) {
    this._size = size;
  }

  BubbleEntry copy() {
    BubbleEntry c = BubbleEntry(x: x, y: y, size: _size, data: mData);
    return c;
  }

  // ignore: unnecessary_getters_setters
  double get size => _size;

  // ignore: unnecessary_getters_setters
  set size(double value) {
    _size = value;
  }
}
