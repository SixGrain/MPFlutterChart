library optimized_gesture_detector;

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mp_chart/gesture/callback.dart';
import 'package:mp_chart/gesture/direction.dart';
import 'package:mp_chart/gesture/gesture_dectetor.dart' as gd;
import 'package:mp_chart/gesture/scale.dart' as scale;
import 'package:mp_chart/gesture/utils.dart';

// ignore: must_be_immutable
class OptimizedGestureDetector extends StatelessWidget {
  static const int INITIAL_INT_VALUE = -1;

  static const int DOUBLE_TAP_INTERVAL = 300;

  static const int SINGLE_TAP_TRIGGER_TIME_BUFFER = 5;

  static const Offset ZERO = Offset(0, 0);

  final OpsTapDownCallback? _tapDownCallback;
  final OpsSingleTapUpCallback? _singleTapCallback;
  final OpsDoubleTapUpCallback? _doubleTapCallback;
  final OpsDragStartCallback? _dragStartCallback;
  final OpsDragUpdateCallback? _dragUpdateCallback;
  final OpsDragEndCallback? _dragEndCallback;
  final OpsMoveStartCallback? _moveStartCallback;
  final OpsMoveUpdateCallback? _moveUpdateCallback;
  final OpsMoveEndCallback? _moveEndCallback;
  final OpsScaleStartCallback? _scaleStartCallback;
  final OpsScaleUpdateCallback? _scaleUpdateCallback;
  final OpsScaleEndCallback? _scaleEndCallback;

  final OpsTapCancelCallback? _tapCancelCallback;
  final OpsMoveCancelCallback? _moveCancelCallback;
  final OpsScaleCancelCallback? _scaleCancelCallback;

  int _tapDownTime = INITIAL_INT_VALUE;

  bool _isSingleTap = false;
  bool _isDoubleTap = false;

  bool? _isRealScale;
  bool _isMoveCancel = false;
  bool _isScaleCancel = false;

  Timer? _singleTapTimer;

  Direction? _scaleMainDirection;

  Offset? _lastMoveUpdateGolbalPos;
  Offset? _lastMoveUpdateLocalPos;

  Offset? _lastScaleUpdateGolbalPos;
  Offset? _lastScaleUpdateLocalPos;

  List<int> _scaleTwoKeys = [];

  final Widget? child;

  final gd.CanDragDownFunction? _canHDragDown;
  final gd.CanDragDownFunction? _canVDragDown;

  OptimizedGestureDetector({
    super.key,
    OpsTapDownCallback? tapDown,
    OpsSingleTapUpCallback? singleTapUp,
    OpsTapCancelCallback? tapCancel,
    OpsDoubleTapUpCallback? doubleTapUp,
    OpsDragStartCallback? dragStart,
    OpsDragUpdateCallback? dragUpdate,
    OpsDragEndCallback? dragEnd,
    OpsMoveStartCallback? moveStart,
    OpsMoveCancelCallback? moveCancel,
    OpsMoveUpdateCallback? moveUpdate,
    OpsMoveEndCallback? moveEnd,
    OpsScaleStartCallback? scaleStart,
    OpsScaleCancelCallback? scaleCancel,
    OpsScaleUpdateCallback? scaleUpdate,
    OpsScaleEndCallback? scaleEnd,
    gd.CanDragDownFunction? needHorizontalConflictFunc,
    gd.CanDragDownFunction? needVerticalConflictFunc,
    this.child,
  })  : _tapDownCallback = tapDown,
        _tapCancelCallback = tapCancel,
        _singleTapCallback = singleTapUp,
        _doubleTapCallback = doubleTapUp,
        _dragStartCallback = dragStart,
        _dragUpdateCallback = dragUpdate,
        _dragEndCallback = dragEnd,
        _moveStartCallback = moveStart,
        _moveCancelCallback = moveCancel,
        _moveUpdateCallback = moveUpdate,
        _moveEndCallback = moveEnd,
        _scaleStartCallback = scaleStart,
        _scaleCancelCallback = scaleCancel,
        _scaleUpdateCallback = scaleUpdate,
        _scaleEndCallback = scaleEnd,
        _canHDragDown = needHorizontalConflictFunc,
        _canVDragDown = needVerticalConflictFunc;

  @override
  Widget build(BuildContext context) {
    return gd.CoreGestureDetector(
      canHDragDown: _canHDragDown,
      canVDragDown: _canVDragDown,
      child: child,
      onTapDown: (details) {
        Util.L1("onTapDown", details);
        _isSingleTap = true;
        _isDoubleTap = false;

        int curTime = DateTime.now().millisecondsSinceEpoch;
        if (INITIAL_INT_VALUE == _tapDownTime) {
          _tapDownTime = curTime;
        } else {
          if (curTime - _tapDownTime <= DOUBLE_TAP_INTERVAL) {
            _cancelAndResetSingleTapTimer();
            _isDoubleTap = true;
            _isSingleTap = false;
          } else {
            _tapDownTime = curTime;
          }
        }

        _tapDownCallback?.call(details);
      },
      onTapUp: (details) {
        Util.L1("onTapUp", details);
        if (_isSingleTap) {
          _cancelAndResetSingleTapTimer();

          int consumeInterval =
              DateTime.now().millisecondsSinceEpoch - _tapDownTime;
          _singleTapTimer = Timer(
              Duration(
                  milliseconds: DOUBLE_TAP_INTERVAL +
                      SINGLE_TAP_TRIGGER_TIME_BUFFER -
                      consumeInterval), () {
            _isSingleTap = false;
            _singleTap(details);
            _cancelAndResetSingleTapTimer();
          });
        }

        if (_isDoubleTap) {
          _doubleTap(details);
        }
      },
      onTapCancel: () {
        Util.L2("onTapCancel");
        _isSingleTap = false;
        _isDoubleTap = false;
        _cancelAndResetSingleTapTimer();
        _tapCancelCallback?.call();
      },
      onLongPressStart: (details) {
        Util.L1("onLongPressStart", details);
        _dragStart(details);
      },
      onLongPressMoveUpdate: (details) {
        Util.L1("onLongPressMoveUpdate", details);
        _dragUpdate(details);
      },
      onLongPressEnd: (details) {
        Util.L1("onLongPressEnd", details);
        _dragEnd(details);
      },
      onScaleStart: (details) {
        Util.L1("onScaleStart", details);

        _isRealScale = null;
        _isMoveCancel = false;
        _isScaleCancel = false;
        _moveStart(details);
        _scaleStart(details);
      },
      onScaleUpdate: (details) {
        Util.L1("onScaleUpdate", details);
        if (_isRealScale == null) {
          _isRealScale = !(details.verticalScale == 1.0 &&
              details.horizontalScale == 1.0 &&
              details.rotation == 0.0);
          if (_isRealScale!) {
            _moveCancel();
          } else {
            _scaleCancel();
          }
        }

        if (_isRealScale!) {
          _scaleUpdate(details);
        } else {
          _moveUpdate(details);
        }
      },
      onScaleEnd: (details) {
        Util.L1("onScaleEnd", details);
        _isRealScale = null;
        if (!_isScaleCancel) {
          _scaleEnd(details);
        }
        if (!_isMoveCancel) {
          _moveEnd(details);
        }
        _isScaleCancel = false;
        _isMoveCancel = false;
      },
    );
  }

  void _singleTap(TapUpDetails details) {
    Util.L1("_singleTap", details);
    _singleTapCallback?.call(details);
  }

  void _doubleTap(TapUpDetails details) {
    Util.L1("_doubleTap", details);
    _doubleTapCallback?.call(details);
  }

  /// _drag* methods means long press then move
  void _dragStart(LongPressStartDetails details) {
    Util.L1("_dragStart", details);
    _dragStartCallback?.call(details);
  }

  void _dragUpdate(LongPressMoveUpdateDetails details) {
    Util.L1("_dragUpdate", details);
    _dragUpdateCallback?.call(details);
  }

  void _dragEnd(LongPressEndDetails details) {
    Util.L1("_dragEnd", details);
    _dragEndCallback?.call(details);
  }

  /// _move* methods means tap then move
  void _moveStart(scale.OpsSStartDetails details) {
    Util.L1("_moveStart", details);
    _resetLastMoveUpdatePos();
    _moveStartCallback?.call(DetailsUtils.toOpsMoveStartDetails(details));
  }

  void _moveUpdate(scale.OpsSUpdateDetails details) {
    Util.L1("_moveUpdate", details);
    _moveUpdateCallback?.call(DetailsUtils.toOpsMoveUpdateDetails(details));
    _lastMoveUpdateGolbalPos = details.focalPoint;
    _lastMoveUpdateLocalPos = details.localFocalPoint;
  }

  void _moveEnd(scale.OpsSEndDetails details) {
    Util.L1("_moveEnd", details);
    _moveEndCallback?.call(DetailsUtils.toOpsMoveEndDetails(details,
        _lastMoveUpdateGolbalPos ?? ZERO, _lastMoveUpdateLocalPos ?? ZERO));
    _resetLastMoveUpdatePos();
  }

  void _moveCancel() {
    Util.L2("_moveCancel");
    _isMoveCancel = true;
    _resetLastMoveUpdatePos();
    _moveCancelCallback?.call();
  }

  /// _scale* methods means zoom then move
  void _scaleStart(scale.OpsSStartDetails details) {
    Util.L1("_scaleStart", details);
    _resetScaleDirection();
    _resetLastScaleUpdatePos();
    _scaleStartCallback?.call(DetailsUtils.toOpsScaleStartDetails(details));
  }

  void _scaleUpdate(scale.OpsSUpdateDetails details) {
    Util.L1("_scaleUpdate", details);

    if (details.globalPointerLocations.length >= 2) {
      if (_scaleTwoKeys.isEmpty) {
        details.globalPointerLocations.forEach((k, v) {
          if (_scaleTwoKeys.length < 2) {
            _scaleTwoKeys.add(k);
          }
        });
      }

      if (_scaleTwoKeys.length >= 2) {
        if (_scaleMainDirection == null) {
          _scaleMainDirection = getCurrentDirection(
            details.globalPointerLocations[_scaleTwoKeys[0]]!,
            details.globalPointerLocations[_scaleTwoKeys[1]]!,
          );
        }

        Util.L2("direction $_scaleMainDirection");
        _scaleUpdateCallback?.call(DetailsUtils.toOpsScaleUpdateDetails(
            details, _scaleMainDirection!));
      }
    }
    _lastScaleUpdateGolbalPos = details.focalPoint;
    _lastScaleUpdateLocalPos = details.localFocalPoint;
  }

  void _scaleEnd(scale.OpsSEndDetails details) {
    Util.L1("_scaleEnd", details);
    _resetScaleDirection();
    _scaleEndCallback?.call(DetailsUtils.toOpsScaleEndDetails(details,
        _lastScaleUpdateGolbalPos ?? ZERO, _lastScaleUpdateLocalPos ?? ZERO));
    _resetLastScaleUpdatePos();
  }

  void _scaleCancel() {
    Util.L2("_scaleCancel");
    _isScaleCancel = true;
    _resetScaleDirection();
    _resetLastScaleUpdatePos();
    _scaleCancelCallback?.call();
  }

  void _resetLastMoveUpdatePos() {
    _lastMoveUpdateGolbalPos = null;
    _lastMoveUpdateLocalPos = null;
  }

  void _resetLastScaleUpdatePos() {
    _lastScaleUpdateGolbalPos = null;
    _lastScaleUpdateLocalPos = null;
  }

  void _resetScaleDirection() {
    _scaleTwoKeys.clear();
    _scaleMainDirection = null;
  }

  void _cancelAndResetSingleTapTimer() {
    _singleTapTimer?.cancel();
    _singleTapTimer = null;
  }
}
