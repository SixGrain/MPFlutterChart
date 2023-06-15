import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:mp_chart/mp/core/data_interfaces/i_bar_data_set.dart';
import 'package:mp_chart/mp/core/entry/bar_entry.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/enums/axis_dependency.dart';
import 'package:mp_chart/mp/core/enums/x_axis_position.dart';
import 'package:mp_chart/mp/core/highlight/highlight.dart';
import 'package:mp_chart/mp/core/highlight/horizontal_bar_highlighter.dart';
import 'package:mp_chart/mp/core/poolable/point.dart';
import 'package:mp_chart/mp/core/render/horizontal_bar_chart_renderer.dart';
import 'package:mp_chart/mp/core/utils/utils.dart';
import 'package:mp_chart/mp/painter/bar_chart_painter.dart';

class HorizontalBarChartPainter extends BarChartPainter {
  HorizontalBarChartPainter({
    required super.data,
    required super.animator,
    required super.viewPortHandler,
    required super.maxHighlightDistance,
    required super.highLightPerTapEnabled,
    required super.extraLeftOffset,
    required super.extraTopOffset,
    required super.extraRightOffset,
    required super.extraBottomOffset,
    required super.marker,
    required super.description,
    required super.drawMarkers,
    required super.infoBgColor,
    required super.infoPainter,
    required super.descPainter,
    required super.xAxis,
    required super.legend,
    required super.legendRenderer,
    required super.rendererSettingFunction,
    required super.selectedListener,
    required super.maxVisibleCount,
    required super.autoScaleMinMaxEnabled,
    required super.pinchZoomEnabled,
    required super.doubleTapToZoomEnabled,
    required super.highlightPerDragEnabled,
    required super.dragXEnabled,
    required super.dragYEnabled,
    required super.scaleXEnabled,
    required super.scaleYEnabled,
    required super.gridBackgroundPaint,
    required super.borderPaint,
    required super.drawGridBackground,
    required super.drawBorders,
    required super.clipValuesToContent,
    required super.minOffset,
    required super.keepPositionOnRotation,
    required super.drawListener,
    required super.axisLeft,
    required super.axisRight,
    required super.axisRendererLeft,
    required super.axisRendererRight,
    required super.leftAxisTransformer,
    required super.rightAxisTransformer,
    required super.xAxisRenderer,
    required super.zoomMatrixBuffer,
    required super.customViewPortEnabled,
    required super.backgroundPaint,
    required super.rangePaint,
    required super.chartTransListener,
    required super.chartPositionListener,
    required super.highlightFullBarEnabled,
    required super.drawValueAboveBar,
    required super.drawBarShadow,
    required super.fitBars,
  });

  @override
  void initDefaultWithData() {
    super.initDefaultWithData();
    highlighter = HorizontalBarHighlighter(this);
    renderer = HorizontalBarChartRenderer(this, animator, viewPortHandler);
  }

  Rect _offsetsBuffer = Rect.zero;

  @override
  void calculateOffsets() {
    legendRenderer.computeLegend(getBarData()!);
    renderer?.initBuffers();
    calcMinMax();

    double offsetLeft = 0, offsetRight = 0, offsetTop = 0, offsetBottom = 0;

    calculateLegendOffsets(_offsetsBuffer);

    offsetLeft += _offsetsBuffer.left;
    offsetTop += _offsetsBuffer.top;
    offsetRight += _offsetsBuffer.right;
    offsetBottom += _offsetsBuffer.bottom;

    // offsets for y-labels
    if (axisLeft.needsOffset()) {
      offsetTop +=
          axisLeft.getRequiredHeightSpace(axisRendererLeft.axisLabelPaint);
    }

    if (axisRight.needsOffset()) {
      offsetBottom +=
          axisRight.getRequiredHeightSpace(axisRendererRight.axisLabelPaint);
    }

    double xlabelwidth = xAxis.labelRotatedWidth.toDouble();

    if (xAxis.enabled) {
      // offsets for x-labels
      if (xAxis.position == XAxisPosition.BOTTOM) {
        offsetLeft += xlabelwidth;
      } else if (xAxis.position == XAxisPosition.TOP) {
        offsetRight += xlabelwidth;
      } else if (xAxis.position == XAxisPosition.BOTH_SIDED) {
        offsetLeft += xlabelwidth;
        offsetRight += xlabelwidth;
      }
    }

    offsetTop += extraTopOffset;
    offsetRight += extraRightOffset;
    offsetBottom += extraBottomOffset;
    offsetLeft += extraLeftOffset;

    double offset = Utils.convertDpToPixel(minOffset);

    viewPortHandler.restrainViewPort(
        max(offset, offsetLeft),
        max(offset, offsetTop),
        max(offset, offsetRight),
        max(offset, offsetBottom));

    prepareOffsetMatrix();
    prepareValuePxMatrix();
  }

  @override
  void prepareValuePxMatrix() {
    rightAxisTransformer.prepareMatrixValuePx(axisRight.axisMinimum,
        axisRight.axisRange, xAxis.axisRange, xAxis.axisMinimum);
    leftAxisTransformer.prepareMatrixValuePx(axisLeft.axisMinimum,
        axisLeft.axisRange, xAxis.axisRange, xAxis.axisMinimum);
  }

  @override
  List<double> getMarkerPosition(Highlight high) {
    return []
      ..add(high.drawY)
      ..add(high.drawX);
  }

  @override
  Rect getBarBounds(BarEntry e) {
    Rect bounds = Rect.zero;
    IBarDataSet? set = getBarData()?.getDataSetForEntry(e);

    if (set == null) {
      bounds = Rect.fromLTRB(double.minPositive, double.minPositive,
          double.minPositive, double.minPositive);
      return bounds;
    }

    double y = e.y;
    double x = e.x;

    double barWidth = getBarData()!.barWidth;

    double top = x - barWidth / 2;
    double bottom = x + barWidth / 2;
    double left = y >= 0 ? y : 0;
    double right = y <= 0 ? y : 0;

    bounds = Rect.fromLTRB(left, top, right, bottom);

    return getTransformer(set.getAxisDependency())!.rectValueToPixel(bounds);
  }

  List<double> mGetPositionBuffer = List.filled(2, 0);

  /// Returns a recyclable MPPointF instance.
  ///
  /// @param e
  /// @param axis
  /// @return
  @override
  MPPointF? getPosition(Entry? e, AxisDependency axis) {
    if (e == null) return null;

    List<double> vals = mGetPositionBuffer;
    vals[0] = e.y;
    vals[1] = e.x;

    getTransformer(axis)!.pointValuesToPixel(vals);

    return MPPointF.getInstance1(vals[0], vals[1]);
  }

  /// Returns the Highlight object (contains x-index and DataSet index) of the selected value at the given touch point
  /// inside the BarChart.
  ///
  /// @param x
  /// @param y
  /// @return
  @override
  Highlight? getHighlightByTouchPoint(double x, double y) {
    if (getBarData() != null) {
      return highlighter?.getHighlight(y, x); // switch x and y
    }
    return null;
  }

  @override
  double getLowestVisibleX() {
    getTransformer(AxisDependency.LEFT)!.getValuesByTouchPoint2(
        viewPortHandler.contentLeft(),
        viewPortHandler.contentBottom(),
        posForGetLowestVisibleX);
    double result = max(xAxis.axisMinimum, posForGetLowestVisibleX.y);
    return result;
  }

  @override
  double getHighestVisibleX() {
    getTransformer(AxisDependency.LEFT)!.getValuesByTouchPoint2(
        viewPortHandler.contentLeft(),
        viewPortHandler.contentTop(),
        posForGetHighestVisibleX);
    double result = min(xAxis.axisMaximum, posForGetHighestVisibleX.y);
    return result;
  }

  /// ###### VIEWPORT METHODS BELOW THIS ######

//  void setVisibleXRangeMaximum(double maxXRange) {
//    double xScale = xAxis.mAxisRange / (maxXRange);
//    viewPortHandler.setMinimumScaleY(xScale);
//  }
//
//  void setVisibleXRangeMinimum(double minXRange) {
//    double xScale = xAxis.mAxisRange / (minXRange);
//    viewPortHandler.setMaximumScaleY(xScale);
//  }
//
//  void setVisibleXRange(double minXRange, double maxXRange) {
//    double minScale = xAxis.mAxisRange / minXRange;
//    double maxScale = xAxis.mAxisRange / maxXRange;
//    viewPortHandler.setMinMaxScaleY(minScale, maxScale);
//  }

  @override
  void setVisibleYRangeMaximum(double maxYRange, AxisDependency axis) {
    double yScale = getAxisRange(axis) / maxYRange;
    viewPortHandler.setMinimumScaleX(yScale);
  }

  @override
  void setVisibleYRangeMinimum(double minYRange, AxisDependency axis) {
    double yScale = getAxisRange(axis) / minYRange;
    viewPortHandler.setMaximumScaleX(yScale);
  }

  @override
  void setVisibleYRange(
      double minYRange, double maxYRange, AxisDependency axis) {
    double minScale = getAxisRange(axis) / minYRange;
    double maxScale = getAxisRange(axis) / maxYRange;
    viewPortHandler.setMinMaxScaleX(minScale, maxScale);
  }
}
