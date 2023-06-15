import 'package:mp_chart/mp/core/data/scatter_data.dart';
import 'package:mp_chart/mp/core/data_provider/scatter_data_provider.dart';
import 'package:mp_chart/mp/core/render/scatter_chart_renderer.dart';
import 'package:mp_chart/mp/painter/bar_line_chart_painter.dart';

class ScatterChartPainter extends BarLineChartBasePainter<ScatterData>
    implements ScatterDataProvider {
  ScatterChartPainter({
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
  }) : super(chartPositionListener: null);

  @override
  void initDefaultWithData() {
    super.initDefaultWithData();
    renderer = ScatterChartRenderer(this, animator, viewPortHandler);
    xAxis.spaceMin = (0.5);
    xAxis.spaceMax = (0.5);
  }

  @override
  ScatterData? getScatterData() {
    return getData() as ScatterData?;
  }
}
