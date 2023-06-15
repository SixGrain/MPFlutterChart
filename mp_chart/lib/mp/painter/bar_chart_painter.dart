import 'package:flutter/rendering.dart';
import 'package:mp_chart/mp/core/data/bar_data.dart';
import 'package:mp_chart/mp/core/data_interfaces/i_bar_data_set.dart';
import 'package:mp_chart/mp/core/data_provider/bar_data_provider.dart';
import 'package:mp_chart/mp/core/entry/bar_entry.dart';
import 'package:mp_chart/mp/core/enums/axis_dependency.dart';
import 'package:mp_chart/mp/core/highlight/bar_highlighter.dart';
import 'package:mp_chart/mp/core/highlight/highlight.dart';
import 'package:mp_chart/mp/core/render/bar_chart_renderer.dart';
import 'package:mp_chart/mp/painter/bar_line_chart_painter.dart';

class BarChartPainter extends BarLineChartBasePainter<BarData>
    implements BarDataProvider {
  /// flag that indicates whether the highlight should be full-bar oriented, or single-value?
  final bool _highlightFullBarEnabled;

  /// if set to true, all values are drawn above their bars, instead of below their top
  final bool _drawValueAboveBar;

  /// if set to true, a grey area is drawn behind each bar that indicates the maximum value
  final bool _drawBarShadow;

  final bool _fitBars;

  BarChartPainter({
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
    required bool highlightFullBarEnabled,
    required bool drawValueAboveBar,
    required bool drawBarShadow,
    required bool fitBars,
  })  : _highlightFullBarEnabled = highlightFullBarEnabled,
        _drawValueAboveBar = drawValueAboveBar,
        _drawBarShadow = drawBarShadow,
        _fitBars = fitBars;

  @override
  void initDefaultWithData() {
    super.initDefaultWithData();
    highlighter = BarHighlighter(this);
    renderer = BarChartRenderer(this, animator, viewPortHandler);
    xAxis?.spaceMin = (0.5);
    xAxis?.spaceMax = (0.5);
  }

  @override
  void calcMinMax() {
    final data = getBarData()!;

    if (_fitBars) {
      xAxis.calculate(
          data.xMin - data.barWidth / 2.0, data.xMax + data.barWidth / 2.0);
    } else {
      xAxis.calculate(data.xMin, data.xMax);
    }

    // calculate axis range (min / max) according to provided data
    axisLeft.calculate(
        data.getYMin2(AxisDependency.LEFT), data.getYMax2(AxisDependency.LEFT));
    axisRight.calculate(data.getYMin2(AxisDependency.RIGHT),
        data.getYMax2(AxisDependency.RIGHT));
  }

  /// Returns the Highlight object (contains x-index and DataSet index) of the selected value at the given touch
  /// point
  /// inside the BarChart.
  ///
  /// @param x
  /// @param y
  /// @return
  @override
  Highlight? getHighlightByTouchPoint(double x, double y) {
    if (getBarData() == null) {
      return null;
    } else {
      Highlight? h = highlighter?.getHighlight(x, y);
      if (h == null || !isHighlightFullBarEnabled()) return h;

      // For isHighlightFullBarEnabled, remove stackIndex
      return Highlight(
          x: h.x,
          y: h.y,
          xPx: h.xPx,
          yPx: h.yPx,
          dataSetIndex: h.dataSetIndex,
          stackIndex: -1,
          axis: h.axis);
    }
  }

  /// The passed outputRect will be assigned the values of the bounding box of the specified Entry in the specified DataSet.
  /// The rect will be assigned Float.MIN_VALUE in all locations if the Entry could not be found in the charts data.
  ///
  /// @param e
  /// @return
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

    double left = x - barWidth / 2.0;
    double right = x + barWidth / 2.0;
    double top = y >= 0 ? y : 0;
    double bottom = y <= 0 ? y : 0;

    bounds = Rect.fromLTRB(left, top, right, bottom);

    return getTransformer(set.getAxisDependency())!.rectValueToPixel(bounds);
  }

  /// returns true if drawing values above bars is enabled, false if not
  ///
  /// @return
  bool isDrawValueAboveBarEnabled() {
    return _drawValueAboveBar;
  }

  /// returns true if drawing shadows (maxvalue) for each bar is enabled, false if not
  ///
  /// @return
  bool isDrawBarShadowEnabled() {
    return _drawBarShadow;
  }

  /// @return true the highlight operation is be full-bar oriented, false if single-value
  @override
  bool isHighlightFullBarEnabled() {
    return _highlightFullBarEnabled;
  }

  /// Highlights the value at the given x-value in the given DataSet. Provide
  /// -1 as the dataSetIndex to undo all highlighting.
  ///
  /// @param x
  /// @param dataSetIndex
  /// @param stackIndex   the index inside the stack - only relevant for stacked entries
  void highlightValue(double x, int dataSetIndex, int stackIndex) {
    highlightValue6(
        Highlight(x: x, dataSetIndex: dataSetIndex, stackIndex: stackIndex),
        false);
  }

  /// Groups all BarDataSet objects this data object holds together by modifying the x-value of their entries.
  /// Previously set x-values of entries will be overwritten. Leaves space between bars and groups as specified
  /// by the parameters.
  /// Calls notifyDataSetChanged() afterwards.
  ///
  /// @param fromX      the starting point on the x-axis where the grouping should begin
  /// @param groupSpace the space between groups of bars in values (not pixels) e.g. 0.8f for bar width 1f
  /// @param barSpace   the space between individual bars in values (not pixels) e.g. 0.1f for bar width 1f
  void groupBars(double fromX, double groupSpace, double barSpace) {
    if (getBarData() == null) {
      throw Exception(
          "You need to set data for the chart before grouping bars.");
    } else {
      getBarData()!.groupBars(fromX, groupSpace, barSpace);
    }
  }

  @override
  BarData? getBarData() {
    return getData() as BarData?;
  }
}
