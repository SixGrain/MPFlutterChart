import 'package:flutter/painting.dart';
import 'package:mp_chart/mp/chart/radar_chart.dart';
import 'package:mp_chart/mp/controller/pie_radar_controller.dart';
import 'package:mp_chart/mp/core/axis/y_axis.dart';
import 'package:mp_chart/mp/core/data/radar_data.dart';
import 'package:mp_chart/mp/core/enums/axis_dependency.dart';
import 'package:mp_chart/mp/core/functions.dart';
import 'package:mp_chart/mp/core/marker/i_marker.dart';
import 'package:mp_chart/mp/core/marker/radar_chart_marker.dart';
import 'package:mp_chart/mp/painter/radar_chart_painter.dart';

class RadarChartController extends PieRadarController<RadarChartPainter> {
  double webLineWidth;
  double innerWebLineWidth;
  Color? webColor;
  Color? webColorInner;
  int webAlpha;
  bool drawWeb;
  int skipWebLineCount;
  YAxis? yAxis;
  Color? backgroundColor;

  YAxisSettingFunction? yAxisSettingFunction;

  RadarChartController({
    this.webLineWidth = 1.5,
    this.innerWebLineWidth = 0.75,
    this.webColor,
    this.webColorInner,
    this.webAlpha = 150,
    this.drawWeb = true,
    this.skipWebLineCount = 0,
    this.yAxis,
    this.backgroundColor,
    this.yAxisSettingFunction,
    super.rotationAngle = 270,
    super.rawRotationAngle = 270,
    super.rotateEnabled = true,
    super.minOffset = 30,
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
  IMarker? initMarker() => RadarChartMarker();

  YAxis initYAxis() => YAxis(position: AxisDependency.LEFT);

  RadarData? get data => super.data as RadarData?;

  RadarChartPainter? get painter => super.painter;

  RadarChartState? get state => super.state as RadarChartState?;

  @override
  void initialPainter() {
    painter = RadarChartPainter(
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
      rotationAngle: rotationAngle,
      rawRotationAngle: rawRotationAngle,
      rotateEnabled: rotateEnabled,
      minOffset: minOffset,
      backgroundColor: backgroundColor,
      webLineWidth: webLineWidth,
      innerWebLineWidth: innerWebLineWidth,
      webColor: webColor!,
      webColorInner: webColorInner!,
      webAlpha: webAlpha,
      drawWeb: drawWeb,
      skipWebLineCount: skipWebLineCount,
      yAxis: yAxis!,
    );
  }

  @override
  void doneBeforePainterInit() {
    super.doneBeforePainterInit();
    webColor ??= Color.fromARGB(255, 122, 122, 122);
    webColorInner ??= Color.fromARGB(255, 122, 122, 122);
    yAxis = initYAxis();
    if (yAxisSettingFunction != null) {
      yAxisSettingFunction!(yAxis!, this);
    }
  }

  @override
  RadarChartState createRealState() {
    return RadarChartState();
  }
}
