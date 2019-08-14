import 'dart:math';

import 'package:mp_flutter_chart/chart/mp/core/axis.dart';
import 'package:mp_flutter_chart/chart/mp/core/data.dart';
import 'package:mp_flutter_chart/chart/mp/core/interfaces.dart';
import 'package:mp_flutter_chart/chart/mp/poolable/point.dart';

class Highlight {
  /**
   * the x-value of the highlighted value
   */
  double mX = double.nan;

  /**
   * the y-value of the highlighted value
   */
  double mY = double.nan;

  /**
   * the x-pixel of the highlight
   */
  double mXPx;

  /**
   * the y-pixel of the highlight
   */
  double mYPx;

  /**
   * the index of the data object - in case it refers to more than one
   */
  int mDataIndex = -1;

  /**
   * the index of the dataset the highlighted value is in
   */
  int mDataSetIndex;

  /**
   * index which value of a stacked bar entry is highlighted, default -1
   */
  int mStackIndex = -1;

  /**
   * the axis the highlighted value belongs to
   */
  AxisDependency axis;

  /**
   * the x-position (pixels) on which this highlight object was last drawn
   */
  double mDrawX;

  /**
   * the y-position (pixels) on which this highlight object was last drawn
   */
  double mDrawY;

  Highlight(
      {double x = double.nan,
      double y = double.nan,
      double xPx = 0,
      double yPx = 0,
      int dataSetIndex = 0,
      int stackIndex = -1,
      AxisDependency axis = null}) {
    this.mX = x;
    this.mY = y;
    this.mXPx = xPx;
    this.mYPx = yPx;
    this.mDataSetIndex = dataSetIndex;
    this.axis = axis;
    this.mStackIndex = stackIndex;
  }

  /**
   * returns the x-value of the highlighted value
   *
   * @return
   */
  double getX() {
    return mX;
  }

  /**
   * returns the y-value of the highlighted value
   *
   * @return
   */
  double getY() {
    return mY;
  }

  /**
   * returns the x-position of the highlight in pixels
   */
  double getXPx() {
    return mXPx;
  }

  /**
   * returns the y-position of the highlight in pixels
   */
  double getYPx() {
    return mYPx;
  }

  /**
   * the index of the data object - in case it refers to more than one
   *
   * @return
   */
  int getDataIndex() {
    return mDataIndex;
  }

  void setDataIndex(int mDataIndex) {
    this.mDataIndex = mDataIndex;
  }

  /**
   * returns the index of the DataSet the highlighted value is in
   *
   * @return
   */
  int getDataSetIndex() {
    return mDataSetIndex;
  }

  /**
   * Only needed if a stacked-barchart entry was highlighted. References the
   * selected value within the stacked-entry.
   *
   * @return
   */
  int getStackIndex() {
    return mStackIndex;
  }

  bool isStacked() {
    return mStackIndex >= 0;
  }

  /**
   * Returns the axis the highlighted value belongs to.
   *
   * @return
   */
  AxisDependency getAxis() {
    return axis;
  }

  /**
   * Sets the x- and y-position (pixels) where this highlight was last drawn.
   *
   * @param x
   * @param y
   */
  void setDraw(double x, double y) {
    this.mDrawX = x;
    this.mDrawY = y;
  }

  /**
   * Returns the x-position in pixels where this highlight object was last drawn.
   *
   * @return
   */
  double getDrawX() {
    return mDrawX;
  }

  /**
   * Returns the y-position in pixels where this highlight object was last drawn.
   *
   * @return
   */
  double getDrawY() {
    return mDrawY;
  }

  /**
   * Returns true if this highlight object is equal to the other (compares
   * xIndex and dataSetIndex)
   *
   * @param h
   * @return
   */
  bool equalTo(Highlight h) {
    if (h == null)
      return false;
    else {
      if (this.mDataSetIndex == h.mDataSetIndex &&
          this.mX == h.mX &&
          this.mStackIndex == h.mStackIndex &&
          this.mDataIndex == h.mDataIndex)
        return true;
      else
        return false;
    }
  }

  @override
  String toString() {
    return "Highlight, x: $mX, y: $mY, dataSetIndex: $mDataSetIndex, stackIndex (only stacked barentry): $mStackIndex";
  }
}

class ChartHighlighter<T extends BarLineScatterCandleBubbleDataProvider>
    implements IHighlighter {
  /**
   * instance of the data-provider
   */
  T mChart;

  /**
   * buffer for storing previously highlighted values
   */
  List<Highlight> mHighlightBuffer = List<Highlight>();

  ChartHighlighter(T chart) {
    this.mChart = chart;
  }

  @override
  Highlight getHighlight(double x, double y) {
    MPPointD pos = getValsForTouch(x, y);
    double xVal = pos.x;
    MPPointD.recycleInstance2(pos);
    Highlight high = getHighlightForX(xVal, x, y);
    return high;
  }

  /**
   * Returns a recyclable MPPointD instance.
   * Returns the corresponding xPos for a given touch-position in pixels.
   *
   * @param x
   * @param y
   * @return
   */
  MPPointD getValsForTouch(double x, double y) {
    // take any transformer to determine the x-axis value
    MPPointD pos =
        mChart.getTransformer(AxisDependency.LEFT).getValuesByTouchPoint1(x, y);
    return pos;
  }

  /**
   * Returns the corresponding Highlight for a given xVal and x- and y-touch position in pixels.
   *
   * @param xVal
   * @param x
   * @param y
   * @return
   */
  Highlight getHighlightForX(double xVal, double x, double y) {
    List<Highlight> closestValues = getHighlightsAtXValue(xVal, x, y);

    if (closestValues.isEmpty) {
      return null;
    }

    double leftAxisMinDist =
        getMinimumDistance(closestValues, y, AxisDependency.LEFT);
    double rightAxisMinDist =
        getMinimumDistance(closestValues, y, AxisDependency.RIGHT);

    AxisDependency axis = leftAxisMinDist < rightAxisMinDist
        ? AxisDependency.LEFT
        : AxisDependency.RIGHT;

    Highlight detail = getClosestHighlightByPixel(
        closestValues, x, y, axis, mChart.getMaxHighlightDistance());

    return detail;
  }

  /**
   * Returns the minimum distance from a touch value (in pixels) to the
   * closest value (in pixels) that is displayed in the chart.
   *
   * @param closestValues
   * @param pos
   * @param axis
   * @return
   */
  double getMinimumDistance(
      List<Highlight> closestValues, double pos, AxisDependency axis) {
    double distance = double.infinity;

    for (int i = 0; i < closestValues.length; i++) {
      Highlight high = closestValues[i];

      if (high.getAxis() == axis) {
        double tempDistance = (getHighlightPos(high) - pos).abs();
        if (tempDistance < distance) {
          distance = tempDistance;
        }
      }
    }

    return distance;
  }

  double getHighlightPos(Highlight h) {
    return h.getYPx();
  }

  /**
   * Returns a list of Highlight objects representing the entries closest to the given xVal.
   * The returned list contains two objects per DataSet (closest rounding up, closest rounding down).
   *
   * @param xVal the transformed x-value of the x-touch position
   * @param x    touch position
   * @param y    touch position
   * @return
   */
  List<Highlight> getHighlightsAtXValue(double xVal, double x, double y) {
    mHighlightBuffer.clear();

    BarLineScatterCandleBubbleData data = getData();

    if (data == null) return mHighlightBuffer;

    for (int i = 0, dataSetCount = data.getDataSetCount();
        i < dataSetCount;
        i++) {
      IDataSet dataSet = data.getDataSetByIndex(i);

      // don't include DataSets that cannot be highlighted
      if (!dataSet.isHighlightEnabled()) continue;

      mHighlightBuffer
          .addAll(buildHighlights(dataSet, i, xVal, Rounding.CLOSEST));
    }

    return mHighlightBuffer;
  }

  /**
   * An array of `Highlight` objects corresponding to the selected xValue and dataSetIndex.
   *
   * @param set
   * @param dataSetIndex
   * @param xVal
   * @param rounding
   * @return
   */
  List<Highlight> buildHighlights(
      IDataSet set, int dataSetIndex, double xVal, Rounding rounding) {
    List<Highlight> highlights = List();

    //noinspection unchecked
    List<Entry> entries = set.getEntriesForXValue(xVal);
    if (entries.length == 0) {
      // Try to find closest x-value and take all entries for that x-value
      final Entry closest = set.getEntryForXValue1(xVal, double.nan, rounding);
      if (closest != null) {
        //noinspection unchecked
        entries = set.getEntriesForXValue(closest.x);
      }
    }

    if (entries.length == 0) return highlights;

    for (Entry e in entries) {
      MPPointD pixels = mChart
          .getTransformer(set.getAxisDependency())
          .getPixelForValues(e.x, e.y);

      highlights.add(new Highlight(
          x: e.x,
          y: e.y,
          xPx: pixels.x,
          yPx: pixels.y,
          dataSetIndex: dataSetIndex,
          axis: set.getAxisDependency()));
    }

    return highlights;
  }

  /**
   * Returns the Highlight of the DataSet that contains the closest value on the
   * y-axis.
   *
   * @param closestValues        contains two Highlight objects per DataSet closest to the selected x-position (determined by
   *                             rounding up an down)
   * @param x
   * @param y
   * @param axis                 the closest axis
   * @param minSelectionDistance
   * @return
   */
  Highlight getClosestHighlightByPixel(List<Highlight> closestValues, double x,
      double y, AxisDependency axis, double minSelectionDistance) {
    Highlight closest = null;
    double distance = minSelectionDistance;

    for (int i = 0; i < closestValues.length; i++) {
      Highlight high = closestValues[i];

      if (axis == null || high.getAxis() == axis) {
        double cDistance = getDistance(x, y, high.getXPx(), high.getYPx());
        if (cDistance < distance) {
          closest = high;
          distance = cDistance;
        }
      }
    }

    return closest;
  }

  /**
   * Calculates the distance between the two given points.
   *
   * @param x1
   * @param y1
   * @param x2
   * @param y2
   * @return
   */
  double getDistance(double x1, double y1, double x2, double y2) {
    double x = pow((x1 - x2), 2);
    double y = pow((y1 - y2), 2);
    return sqrt(x + y);
  }

  BarLineScatterCandleBubbleData getData() {
    return mChart.getData();
  }
}
