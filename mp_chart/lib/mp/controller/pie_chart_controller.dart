import 'package:flutter/painting.dart';
import 'package:mp_chart/mp/chart/pie_chart.dart';
import 'package:mp_chart/mp/controller/pie_radar_controller.dart';
import 'package:mp_chart/mp/core/adapter_android_mp.dart';
import 'package:mp_chart/mp/core/data/pie_data.dart';
import 'package:mp_chart/mp/core/marker/bar_chart_marker.dart';
import 'package:mp_chart/mp/core/marker/i_marker.dart';
import 'package:mp_chart/mp/core/utils/color_utils.dart';
import 'package:mp_chart/mp/painter/pie_chart_painter.dart';

class PieChartController extends PieRadarController<PieChartPainter> {
  bool drawEntryLabels;
  bool drawHole;
  bool drawSlicesUnderHole;
  bool usePercentValues;
  bool drawRoundedSlices;
  String centerText;
  double holeRadiusPercent; // = 50
  double transparentCircleRadiusPercent; //= 55
  bool drawCenterText; // = true
  double centerTextRadiusPercent; // = 100.0
  double maxAngle; // = 360
  double minAngleForSlices; // = 0
  double centerTextOffsetX;
  double centerTextOffsetY;
  TypeFace? centerTextTypeface;
  TypeFace? entryLabelTypeface;
  Color? backgroundColor;
  Color holeColor;

  PieChartController({
    this.drawEntryLabels = true,
    this.drawHole = true,
    this.drawSlicesUnderHole = false,
    this.usePercentValues = false,
    this.drawRoundedSlices = false,
    this.centerText = "",
    this.holeRadiusPercent = 50.0,
    this.transparentCircleRadiusPercent = 55.0,
    this.drawCenterText = true,
    this.centerTextRadiusPercent = 100.0,
    this.maxAngle = 360,
    this.minAngleForSlices = 0,
    this.centerTextOffsetX = 0.0,
    this.centerTextOffsetY = 0.0,
    this.centerTextTypeface,
    this.entryLabelTypeface,
    this.backgroundColor,
    this.holeColor = ColorUtils.WHITE,
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
  IMarker initMarker() => BarChartMarker();

  PieData? get data => super.data as PieData?;

  PieChartPainter? get painter => super.painter;

  PieChartState? get state => super.state as PieChartState?;

  @override
  void initialPainter() {
    painter = PieChartPainter(
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
        drawEntryLabels: drawEntryLabels,
        drawHole: drawHole,
        drawSlicesUnderHole: drawSlicesUnderHole,
        usePercentValues: usePercentValues,
        drawRoundedSlices: drawRoundedSlices,
        centerText: centerText,
        centerTextOffsetX: centerTextOffsetX,
        centerTextOffsetY: centerTextOffsetY,
        entryLabelTypeface: entryLabelTypeface,
        centerTextTypeface: centerTextTypeface,
        holeRadiusPercent: holeRadiusPercent,
        transparentCircleRadiusPercent: transparentCircleRadiusPercent,
        drawCenterText: drawCenterText,
        centerTextRadiusPercent: centerTextRadiusPercent,
        maxAngle: maxAngle,
        minAngleForSlices: minAngleForSlices,
        holeColor: holeColor);
  }

  @override
  PieChartState createRealState() {
    return PieChartState();
  }
}
