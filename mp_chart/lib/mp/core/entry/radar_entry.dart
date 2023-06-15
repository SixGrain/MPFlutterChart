import 'package:mp_chart/mp/core/entry/entry.dart';

class RadarEntry extends Entry {
  RadarEntry({
    required double value,
    super.data,
    super.icon,
  }) : super(x: 0, y: value);

  /// This is the same as getY(). Returns the value of the RadarEntry.
  ///
  /// @return
  double getValue() {
    return y;
  }

  RadarEntry copy() {
    RadarEntry e = RadarEntry(value: y, data: mData);
    return e;
  }
}
