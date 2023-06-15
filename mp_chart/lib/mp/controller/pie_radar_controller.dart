import 'package:mp_chart/mp/controller/controller.dart';
import 'package:mp_chart/mp/core/utils/utils.dart';
import 'package:mp_chart/mp/painter/pie_redar_chart_painter.dart';

abstract class PieRadarController<P extends PieRadarChartPainter>
    extends Controller<P> {
  double rotationAngle;
  double rawRotationAngle;
  bool rotateEnabled;
  double minOffset;

  PieRadarController({
    this.rotationAngle = 270,
    this.rawRotationAngle = 270,
    this.rotateEnabled = true,
    this.minOffset = 30,
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
  void onRotateUpdate(double angle) {
    rawRotationAngle = angle;
    rotationAngle = Utils.getNormalizedAngle(rawRotationAngle);
    state?.setStateIfNotDispose();
  }

  P? get painter => super.painter;
}
