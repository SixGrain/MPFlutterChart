import 'package:mp_chart/mp/chart/bar_chart.dart';
import 'package:mp_chart/mp/controller/bar_line_scatter_candle_bubble_controller.dart';
import 'package:mp_chart/mp/core/data/bar_data.dart';
import 'package:mp_chart/mp/core/marker/bar_chart_marker.dart';
import 'package:mp_chart/mp/core/marker/i_marker.dart';
import 'package:mp_chart/mp/painter/bar_chart_painter.dart';

class BarChartController
    extends BarLineScatterCandleBubbleController<BarChartPainter> {
  bool highlightFullBarEnabled;
  bool drawValueAboveBar;
  bool drawBarShadow;
  bool fitBars;

  BarChartController({
    this.highlightFullBarEnabled = true,
    this.drawValueAboveBar = false,
    this.drawBarShadow = false,
    this.fitBars = true,
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

  @override
  void initialPainter() {
    painter = BarChartPainter(
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
        borderPaint: borderPaint,
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
        backgroundPaint: backgroundPaint,
        rangePaint: rangePaint,
        chartTransListener: chartTransListener,
        chartPositionListener: chartPositionListener,
        highlightFullBarEnabled: highlightFullBarEnabled,
        drawValueAboveBar: drawValueAboveBar,
        drawBarShadow: drawBarShadow,
        fitBars: fitBars);
  }

  BarChartPainter? get painter => super.painter;

  BarChartState? get state => super.state as BarChartState?;

  @override
  IMarker? initMarker() => BarChartMarker();

  BarData? get data => super.data as BarData?;

  void groupBars(double fromX, double groupSpace, double barSpace) {
    if (data == null) {
      throw Exception(
          "You need to set data for the chart before grouping bars.");
    } else {
      data!.groupBars(fromX, groupSpace, barSpace);
    }
  }

  @override
  BarChartState createRealState() {
    return BarChartState();
  }
}
