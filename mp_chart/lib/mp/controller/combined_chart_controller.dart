import 'package:flutter/rendering.dart';
import 'package:mp_chart/mp/chart/combined_chart.dart';
import 'package:mp_chart/mp/controller/bar_line_scatter_candle_bubble_controller.dart';
import 'package:mp_chart/mp/core/data/combined_data.dart';
import 'package:mp_chart/mp/core/range_chart_listener.dart';
import 'package:mp_chart/mp/painter/combined_chart_painter.dart';

class CombinedChartController
    extends BarLineScatterCandleBubbleController<CombinedChartPainter>
    with ChartPositionListener {
  bool drawValueAboveBar;
  bool highlightFullBarEnabled;
  bool drawBarShadow;
  bool fitBars;
  List<DrawOrder> drawOrder;

  CombinedChartController({
    this.drawValueAboveBar = false,
    this.highlightFullBarEnabled = true,
    this.drawBarShadow = false,
    this.fitBars = true,
    this.drawOrder = const [],
    super.drawRange = false,
    super.maxVisibleCount = 100,
    super.autoScaleMinMaxEnabled = true,
    super.doubleTapToZoomEnabled = true,
    super.highlightPerDragEnabled = true,
    super.dragXEnabled = true,
    super.dragYEnabled = true,
    super.scaleXEnabled = true,
    super.scaleYEnabled = true,
    super.drawGridBackground = false,
    super.drawBorders = false,
    super.clipValuesToContent = false,
    super.minOffset = 30.0,
    super.customViewPortEnabled = false,
    super.pinchZoomEnabled = true,
    super.keepPositionOnRotation = false,
    super.borderStrokeWidth = 1.0,
    super.drawListener,
    super.axisLeft,
    super.axisRight,
    super.axisRendererLeft,
    super.axisRendererRight,
    super.leftAxisTransformer,
    super.rightAxisTransformer,
    super.xAxisRenderer,
    super.zoomMatrixBuffer,
    super.gridBackgroundPaint,
    super.borderPaint,
    super.rangePaint,
    super.backgroundPaint,
    super.gridBackColor,
    super.borderColor,
    super.rangeColor,
    super.backgroundColor,
    super.axisLeftSettingFunction,
    super.axisRightSettingFunction,
    super.touchEventListener,
    super.chartTransListener,
    super.chartPositionListener,
    super.marker,
    super.description,
    super.noDataText,
    super.xAxisSettingFunction,
    super.legendSettingFunction,
    super.rendererSettingFunction,
    super.selectionListener,
    super.maxHighlightDistance,
    super.highLightPerTapEnabled,
    super.extraTopOffset,
    super.extraRightOffset,
    super.extraBottomOffset,
    super.extraLeftOffset,
    super.drawMarkers,
    super.resolveGestureHorizontalConflict,
    super.resolveGestureVerticalConflict,
    super.descTextSize,
    super.infoTextSize,
    super.descTextColor,
    super.infoTextColor,
    super.infoBgColor,
    super.viewPortHandler,
    super.xAxis,
    super.legend,
    super.legendRenderer,
    super.descPainter,
    super.infoPainter,
    super.horizontalConflictResolveFunc,
    super.verticalConflictResolveFunc,
  });

  CombinedData? get data => super.data as CombinedData?;

  CombinedChartPainter? get painter => super.painter;

  CombinedChartState? get state => super.state as CombinedChartState?;

  @override
  void initialPainter() {
    painter = CombinedChartPainter(
        data: data,
        animator: animator,
        viewPortHandler: viewPortHandler,
        maxHighlightDistance: maxHighlightDistance,
        highLightPerTapEnabled: highLightPerTapEnabled,
        extraLeftOffset: extraLeftOffset,
        extraTopOffset: extraTopOffset,
        extraRightOffset: extraRightOffset,
        extraBottomOffset: extraBottomOffset,
        marker: marker,
        description: description,
        drawMarkers: drawMarkers,
        infoBgColor: infoBgColor,
        infoPainter: infoPainter,
        descPainter: descPainter,
        xAxis: xAxis,
        legend: legend,
        legendRenderer: legendRenderer,
        rendererSettingFunction: rendererSettingFunction,
        selectedListener: selectedListener,
        maxVisibleCount: maxVisibleCount,
        autoScaleMinMaxEnabled: autoScaleMinMaxEnabled,
        pinchZoomEnabled: pinchZoomEnabled,
        doubleTapToZoomEnabled: doubleTapToZoomEnabled,
        highlightPerDragEnabled: highlightPerDragEnabled,
        dragXEnabled: dragXEnabled,
        dragYEnabled: dragYEnabled,
        scaleXEnabled: scaleXEnabled,
        scaleYEnabled: scaleYEnabled,
        gridBackgroundPaint: gridBackgroundPaint,
        backgroundPaint: backgroundPaint,
        borderPaint: borderPaint,
        rangePaint: rangePaint,
        drawGridBackground: drawGridBackground,
        drawBorders: drawBorders,
        clipValuesToContent: clipValuesToContent,
        minOffset: minOffset,
        keepPositionOnRotation: keepPositionOnRotation,
        drawListener: drawListener,
        axisLeft: axisLeft,
        axisRight: axisRight,
        axisRendererLeft: axisRendererLeft,
        axisRendererRight: axisRendererRight,
        leftAxisTransformer: leftAxisTransformer,
        rightAxisTransformer: rightAxisTransformer,
        xAxisRenderer: xAxisRenderer,
        zoomMatrixBuffer: zoomMatrixBuffer,
        customViewPortEnabled: customViewPortEnabled,
        drawRange: drawRange,
        chartPositionListener: chartPositionListener,
        chartTransListener: chartTransListener,
        highlightFullBarEnabled: highlightFullBarEnabled,
        drawValueAboveBar: drawValueAboveBar,
        drawBarShadow: drawBarShadow,
        drawOrder: drawOrder);
  }

  @override
  CombinedChartState createRealState() {
    return CombinedChartState();
  }

  @override
  void updatePositionMatrix(
      Matrix4 positionMatrix, double mainChartWidth, double mainChartHeight) {
    painter?.viewPortHandler
        .setRangeMatrix(positionMatrix, mainChartWidth, mainChartHeight);
    state?.setStateIfNotDispose();
  }
}
