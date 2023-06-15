import 'package:flutter/rendering.dart';
import 'package:mp_chart/mp/core/data/bar_data.dart';
import 'package:mp_chart/mp/core/data/bubble_data.dart';
import 'package:mp_chart/mp/core/data/candle_data.dart';
import 'package:mp_chart/mp/core/data/combined_data.dart';
import 'package:mp_chart/mp/core/data/filled_line_data.dart';
import 'package:mp_chart/mp/core/data/line_data.dart';
import 'package:mp_chart/mp/core/data/scatter_data.dart';
import 'package:mp_chart/mp/core/data_interfaces/i_data_set.dart';
import 'package:mp_chart/mp/core/data_provider/combined_data_provider.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/highlight/combined_highlighter.dart';
import 'package:mp_chart/mp/core/highlight/highlight.dart';
import 'package:mp_chart/mp/core/render/combined_chart_renderer.dart';
import 'package:mp_chart/mp/painter/bar_line_chart_painter.dart';

enum DrawOrder { BAR, FILLED_LINE, BUBBLE, LINE, CANDLE, SCATTER, LEVEL }

class CombinedChartPainter extends BarLineChartBasePainter<CombinedData>
    implements CombinedDataProvider {
  /// if set to true, all values are drawn above their bars, instead of below
  /// their top
  bool _drawValueAboveBar = true;

  /// flag that indicates whether the highlight should be full-bar oriented, or single-value?
  bool _highlightFullBarEnabled = false;

  /// if set to true, a grey area is drawn behind each bar that indicates the
  /// maximum value
  bool _drawBarShadow = false;

  List<DrawOrder>? _drawOrder;

  CombinedChartPainter({
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
    required super.backgroundPaint,
    required super.borderPaint,
    required super.rangePaint,
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
    required super.drawRange,
    required super.chartPositionListener,
    required super.chartTransListener,
    required bool highlightFullBarEnabled,
    required bool drawValueAboveBar,
    required bool drawBarShadow,
    required List<DrawOrder> drawOrder,
  })  : _drawBarShadow = drawBarShadow,
        _highlightFullBarEnabled = highlightFullBarEnabled,
        _drawValueAboveBar = drawValueAboveBar,
        _drawOrder = drawOrder;

  List<DrawOrder> initDrawOrder() {
    return []
      ..add(DrawOrder.LEVEL)
      ..add(DrawOrder.FILLED_LINE)
      ..add(DrawOrder.BAR)
      ..add(DrawOrder.BUBBLE)
      ..add(DrawOrder.LINE)
      ..add(DrawOrder.CANDLE)
      ..add(DrawOrder.SCATTER);
  }

  @override
  void initDefaultWithData() {
    super.initDefaultWithData();
    _drawOrder ??= initDrawOrder();
    highlighter = CombinedHighlighter(this, this);
    renderer = CombinedChartRenderer(this, animator, viewPortHandler);
    (renderer as CombinedChartRenderer).createRenderers();
    renderer!.initBuffers();
  }

  @override
  CombinedData? getCombinedData() {
    return getData() as CombinedData?;
  }

  /// Returns the Highlight object (contains x-index and DataSet index) of the selected value at the given touch
  /// point
  /// inside the CombinedChart.
  ///
  /// @param x
  /// @param y
  /// @return
  @override
  Highlight? getHighlightByTouchPoint(double x, double y) {
    if (getCombinedData() == null) {
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
          stackIndex: h.stackIndex,
          axis: h.axis)
        ..dataIndex = h.dataIndex;
    }
  }

  @override
  LineData? getLineData() {
    if (getCombinedData() == null) return null;
    return getCombinedData()?.getLineData();
  }

  @override
  LineData? getLevelData() {
    if (getCombinedData() == null) return null;
    return getCombinedData()?.getLevelData();
  }

  @override
  BarData? getBarData() {
    if (getCombinedData() == null) return null;
    return getCombinedData()?.getBarData();
  }

  @override
  ScatterData? getScatterData() {
    if (getCombinedData() == null) return null;
    return getCombinedData()?.getScatterData();
  }

  @override
  CandleData? getCandleData() {
    if (getCombinedData() == null) return null;
    return getCombinedData()?.getCandleData();
  }

  @override
  BubbleData? getBubbleData() {
    if (getCombinedData() == null) return null;
    return getCombinedData()?.getBubbleData();
  }

  @override
  FilledLineData? getFilledLineData() {
    if (getCombinedData() == null) return null;
    return getCombinedData()?.getFilledLineData();
  }

  @override
  bool isDrawBarShadowEnabled() {
    return _drawBarShadow;
  }

  @override
  bool isDrawValueAboveBarEnabled() {
    return _drawValueAboveBar;
  }

  /// If set to true, all values are drawn above their bars, instead of below
  /// their top.
  ///
  /// @param enabled
  void setDrawValueAboveBar(bool enabled) {
    _drawValueAboveBar = enabled;
  }

  /// If set to true, a grey area is drawn behind each bar that indicates the
  /// maximum value. Enabling his will reduce performance by about 50%.
  ///
  /// @param enabled
  void setDrawBarShadow(bool enabled) {
    _drawBarShadow = enabled;
  }

  /// Set this to true to make the highlight operation full-bar oriented,
  /// false to make it highlight single values (relevant only for stacked).
  ///
  /// @param enabled
  void setHighlightFullBarEnabled(bool enabled) {
    _highlightFullBarEnabled = enabled;
  }

  /// @return true the highlight operation is be full-bar oriented, false if single-value
  @override
  bool isHighlightFullBarEnabled() {
    return _highlightFullBarEnabled;
  }

  /// Returns the currently set draw order.
  ///
  /// @return
  List<DrawOrder> getDrawOrder() {
    return _drawOrder!;
  }

  /// Sets the order in which the provided data objects should be drawn. The
  /// earlier you place them in the provided array, the further they will be in
  /// the background. e.g. if you provide new DrawOrer[] { DrawOrder.BAR,
  /// DrawOrder.LINE }, the bars will be drawn behind the lines.
  ///
  /// @param order
  void setDrawOrder(List<DrawOrder>? order) {
    if (order == null || order.length <= 0) return;
    _drawOrder = order;
  }

  /// draws all MarkerViews on the highlighted positions
  void drawMarkers(Canvas canvas) {
// if there is no marker view or drawing marker is disabled
    if (marker == null || !isDrawMarkers || !valuesToHighlight()) return;

    for (int i = 0; i < indicesToHighlight!.length; i++) {
      Highlight highlight = indicesToHighlight![i];

      IDataSet set = getCombinedData()!.getDataSetByHighlight(highlight)!;

      Entry? e = getCombinedData()?.getEntryForHighlight(highlight);
      if (e == null) continue;

      int entryIndex = set.getEntryIndex2(e);

// make sure entry not null
      if (entryIndex > set.getEntryCount() * animator.getPhaseX()) continue;

      List<double> pos = getMarkerPosition(highlight);

// check bounds
      if (!viewPortHandler.isInBounds(pos[0], pos[1])) continue;

// callbacks to update the content
      marker!.refreshContent(e, highlight);

// draw the marker
      marker!.draw(canvas, pos[0], pos[1]);
    }
  }
}
