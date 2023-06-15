import 'package:mp_chart/mp/controller/bar_chart_controller.dart';
import 'package:mp_chart/mp/core/enums/axis_dependency.dart';
import 'package:mp_chart/mp/core/marker/horizontal_bar_chart_marker.dart';
import 'package:mp_chart/mp/core/marker/i_marker.dart';
import 'package:mp_chart/mp/core/render/x_axis_renderer.dart';
import 'package:mp_chart/mp/core/render/x_axis_renderer_horizontal_bar_chart.dart';
import 'package:mp_chart/mp/core/render/y_axis_renderer.dart';
import 'package:mp_chart/mp/core/render/y_axis_renderer_horizontal_bar_chart.dart';
import 'package:mp_chart/mp/core/transformer/transformer.dart';
import 'package:mp_chart/mp/core/transformer/transformer_horizontal_bar_chart.dart';
import 'package:mp_chart/mp/core/view_port.dart';
import 'package:mp_chart/mp/painter/horizontal_bar_chart_painter.dart';

class HorizontalBarChartController extends BarChartController {
  HorizontalBarChartController({
    super.highlightFullBarEnabled = true,
    super.drawValueAboveBar = false,
    super.drawBarShadow = false,
    super.fitBars = true,
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

  HorizontalBarChartPainter? get painter => super.painter as HorizontalBarChartPainter?;

  @override
  void initialPainter() {
    painter = HorizontalBarChartPainter(
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

  @override
  IMarker? initMarker() => HorizontalBarChartMarker();

  @override
  Transformer initLeftAxisTransformer() =>
      TransformerHorizontalBarChart(viewPortHandler);

  @override
  Transformer initRightAxisTransformer() =>
      TransformerHorizontalBarChart(viewPortHandler);

  @override
  YAxisRenderer initAxisRendererLeft() => YAxisRendererHorizontalBarChart(
      viewPortHandler, axisLeft!, leftAxisTransformer!);

  @override
  YAxisRenderer initAxisRendererRight() => YAxisRendererHorizontalBarChart(
      viewPortHandler, axisRight!, rightAxisTransformer!);

  @override
  XAxisRenderer initXAxisRenderer() => XAxisRendererHorizontalBarChart(
      viewPortHandler, xAxis, leftAxisTransformer!);

  @override
  ViewPortHandler initViewPortHandler() => HorizontalViewPortHandler();

  @override
  void setVisibleXRangeMaximum(double maxXRange) {
    double xScale = xAxis.axisRange / (maxXRange);
    viewPortHandler.setMinimumScaleY(xScale);
  }

  @override
  void setVisibleXRangeMinimum(double minXRange) {
    double xScale = xAxis.axisRange / (minXRange);
    viewPortHandler.setMaximumScaleY(xScale);
  }

  @override
  void setVisibleXRange(double minXRange, double maxXRange) {
    double minScale = xAxis.axisRange / minXRange;
    double maxScale = xAxis.axisRange / maxXRange;
    viewPortHandler.setMinMaxScaleY(minScale, maxScale);
  }

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
