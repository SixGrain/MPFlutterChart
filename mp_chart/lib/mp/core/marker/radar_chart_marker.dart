import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/marker/line_chart_marker.dart';
import 'package:mp_chart/mp/core/value_formatter/default_value_formatter.dart';

class RadarChartMarker extends LineChartMarker {
  RadarChartMarker({
    super.textColor,
    super.backColor,
    super.fontSize,
  });

  @protected
  @override
  String getMessage(DefaultValueFormatter formatter, Entry entry) =>
      "${formatter.getFormattedValue1(entry.y)}";

  Offset calculatePos(double posX, double posY, double textW, double textH) {
    return Offset(posX - textW / 2, posY - textH / 2);
  }
}
