import 'dart:ui';

import 'package:mp_chart/mp/core/marker/line_chart_marker.dart';

class BarChartMarker extends LineChartMarker {
  BarChartMarker({
    super.textColor,
    super.backColor,
    super.fontSize,
  });

  @override
  Offset calculatePos(double posX, double posY, double textW, double textH) {
    return Offset(posX - textW / 2, posY - textH * 2);
  }
}
