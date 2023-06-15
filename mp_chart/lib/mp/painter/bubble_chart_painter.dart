import 'package:mp_chart/mp/core/data/bubble_data.dart';
import 'package:mp_chart/mp/core/data_provider/bubble_data_provider.dart';
import 'package:mp_chart/mp/core/render/bubble_chart_renderer.dart';
import 'package:mp_chart/mp/painter/bar_line_chart_painter.dart';

class BubbleChartPainter extends BarLineChartBasePainter<BubbleData>
    implements BubbleDataProvider {
  BubbleChartPainter({
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
  });

  @override
  void initDefaultWithData() {
    super.initDefaultWithData();
    renderer = BubbleChartRenderer(this, animator, viewPortHandler);
  }

  @override
  BubbleData? getBubbleData() {
    return getData() as BubbleData?;
  }
}
