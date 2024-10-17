import 'dart:ui' as ui;
import 'dart:ui';

import 'package:mp_chart/mp/core/entry/entry.dart';

class ScatterEntry extends Entry {
  dynamic picture;
  Color? color;

  ScatterEntry({
    required double x,
    required double y,
    ui.Image? icon,
    Object? data,
    this.picture,
    this.color,
  }) : super(x: x, y: y, icon: icon, data: data);

  ScatterEntry copy({double? x, double? y}) => ScatterEntry(
        x: x ?? this.x,
        y: y ?? this.y,
        data: mData,
        picture: picture,
        color: color,
      );
}
