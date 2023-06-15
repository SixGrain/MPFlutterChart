import 'package:flutter/rendering.dart';
import 'package:mp_chart/mp/core/utils/color_utils.dart';
import 'package:mp_chart/mp/core/utils/utils.dart';

abstract class PainterUtils {
  static TextPainter create(
    TextPainter? painter,
    String? text,
    Color? color,
    double? fontSize, {
    String? fontFamily,
    FontWeight? fontWeight = FontWeight.w400,
  }) {
    fontWeight ??= FontWeight.w400;
    if (painter == null) {
      return _create(text, color, fontSize,
          fontFamily: fontFamily, fontWeight: fontWeight);
    }

    final span = painter.text;
    if (span != null && span is TextSpan) {
      var preText = span.text;
      var preColor = span.style?.color ?? ColorUtils.BLACK;
      var preFontSize = span.style?.fontSize ?? Utils.convertDpToPixel(13);

      return _create(
        text == null ? preText : text,
        color == null ? preColor : color,
        fontSize == null ? preFontSize : fontSize,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
      );
    } else {
      return _create(
        text,
        color,
        fontSize,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
      );
    }
  }

  static TextPainter _create(
    String? text,
    Color? color,
    double? fontSize, {
    String? fontFamily,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: text,
        style: createTextStyle(
          color,
          fontSize,
          fontFamily: fontFamily,
          fontWeight: fontWeight,
        ),
      ),
    );
  }

  static TextStyle createTextStyle(
    Color? color,
    double? fontSize, {
    String? fontFamily,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
    );
  }
}
