import 'package:flutter/cupertino.dart';
import 'package:mp_chart/gesture/gesture_dectetor.dart';
import 'package:mp_chart/mp/chart/chart.dart';
import 'package:mp_chart/mp/core/animator.dart';
import 'package:mp_chart/mp/core/axis/x_axis.dart';
import 'package:mp_chart/mp/core/common_interfaces.dart';
import 'package:mp_chart/mp/core/data/chart_data.dart';
import 'package:mp_chart/mp/core/description.dart';
import 'package:mp_chart/mp/core/functions.dart';
import 'package:mp_chart/mp/core/legend/legend.dart';
import 'package:mp_chart/mp/core/marker/i_marker.dart';
import 'package:mp_chart/mp/core/render/legend_renderer.dart';
import 'package:mp_chart/mp/core/utils/color_utils.dart';
import 'package:mp_chart/mp/core/utils/painter_utils.dart';
import 'package:mp_chart/mp/core/view_port.dart';
import 'package:mp_chart/mp/painter/painter.dart';

abstract class Controller<P extends ChartPainter>
    implements AnimatorUpdateListener {
  ChartState? state;
  ChartData? data;
  P? _painter;

  late Animator animator;

  ////// needed
  IMarker? marker;
  late Description description;
  late ViewPortHandler viewPortHandler;

  late XAxis xAxis;
  late Legend legend;
  late LegendRenderer legendRenderer;

  XAxis? _xAxisTemp;
  Legend? _legendTemp;
  LegendRenderer? _legendRendererTemp;

  ////// option
  double maxHighlightDistance;
  bool highLightPerTapEnabled;
  double extraTopOffset, extraRightOffset, extraBottomOffset, extraLeftOffset;
  bool drawMarkers;

  ////// split child property
  Color infoBgColor;
  TextPainter descPainter;
  TextPainter infoPainter;

  OnChartValueSelectedListener? selectedListener;

  XAxisSettingFunction? xAxisSettingFunction;
  LegendSettingFunction? legendSettingFunction;

  DataRendererSettingFunction? rendererSettingFunction;
  CanDragDownFunction? horizontalConflictResolveFunc;
  CanDragDownFunction? verticalConflictResolveFunc;

  Controller({
    this.maxHighlightDistance = 100,
    this.highLightPerTapEnabled = true,
    this.extraTopOffset = 0,
    this.extraRightOffset = 0,
    this.extraBottomOffset = 0,
    this.extraLeftOffset = 0,
    this.drawMarkers = true,
    IMarker? marker,
    Description? description,
    ViewPortHandler? viewPortHandler,
    XAxis? xAxis,
    Legend? legend,
    LegendRenderer? legendRenderer,
    OnChartValueSelectedListener? selectionListener,
    bool? resolveGestureHorizontalConflict,
    bool? resolveGestureVerticalConflict,
    double? descTextSize,
    double? infoTextSize,
    Color? descTextColor,
    Color? infoTextColor,
    Color? infoBgColor,
    TextPainter? descPainter,
    TextPainter? infoPainter,
    String? noDataText,
    this.xAxisSettingFunction,
    this.legendSettingFunction,
    this.rendererSettingFunction,
    this.horizontalConflictResolveFunc,
    this.verticalConflictResolveFunc,
  })  : _xAxisTemp = xAxis,
        _legendTemp = legend,
        _legendRendererTemp = legendRenderer,
        this.descPainter = descPainter ??
            PainterUtils.create(null, null, descTextColor ?? ColorUtils.BLACK,
                descTextSize ?? 12,
                fontFamily: description?.typeface?.fontFamily,
                fontWeight: description?.typeface?.fontWeight),
        this.infoPainter = infoPainter ??
            PainterUtils.create(
              null,
              noDataText ?? "No chart data available.",
              infoTextColor ?? ColorUtils.BLACK,
              infoTextSize ?? 12,
            ),
        this.infoBgColor = infoBgColor ?? ColorUtils.WHITE {
    this.animator = ChartAnimatorBySys(this);
    this.viewPortHandler = viewPortHandler ?? initViewPortHandler();
    this.marker = marker ?? initMarker();
    this.description = description ?? initDescription();
    this.selectedListener = selectionListener ?? initSelectionListener();

    if (resolveGestureHorizontalConflict == true) {
      horizontalConflictResolveFunc = () => true;
    }

    if (resolveGestureVerticalConflict == true) {
      verticalConflictResolveFunc = () => true;
    }
  }

  IMarker? initMarker() => null;

  Description initDescription() => Description();

  ViewPortHandler initViewPortHandler() => ViewPortHandler();

  XAxis initXAxis() => XAxis();

  Legend initLegend() => Legend();

  LegendRenderer initLegendRenderer() =>
      LegendRenderer(viewPortHandler, legend);

  OnChartValueSelectedListener? initSelectionListener() => null;

  ChartState createChartState() => state = createRealState();

  ChartState createRealState();

  void doneBeforePainterInit() {
    this.legend = _legendTemp ?? initLegend();
    this.legendRenderer = _legendRendererTemp ?? initLegendRenderer();
    this.xAxis = _xAxisTemp ?? initXAxis();

    legendSettingFunction?.call(this.legend, this);
    xAxisSettingFunction?.call(this.xAxis, this);
  }

  void initialPainter();

  @override
  void onAnimationUpdate(double x, double y) {
    state?.setStateIfNotDispose();
  }

  @override
  void onRotateUpdate(double angle) {}

  // ignore: unnecessary_getters_setters
  P? get painter => _painter;

  // ignore: unnecessary_getters_setters
  set painter(P? value) {
    _painter = value;
  }
}
