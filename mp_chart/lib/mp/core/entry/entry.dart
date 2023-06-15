import 'package:mp_chart/mp/core/entry/base_entry.dart';

class Entry extends BaseEntry {
  double _x = 0;

  Entry({
    required double x,
    required super.y,
    super.icon,
    super.data,
  }) : this._x = x;

  Entry copy() {
    Entry e = Entry(x: _x, y: y, data: mData);
    return e;
  }

  // ignore: unnecessary_getters_setters
  double get x => _x;

  // ignore: unnecessary_getters_setters
  set x(double value) {
    _x = value;
  }
}
