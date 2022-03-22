// ignore_for_file: non_constant_identifier_names
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

import 'package:drawer_app/extension/hex_color.dart';
import 'package:drawer_app/models/draw_action.dart';

import './action_type.dart';
import './draw_action.dart';
import './generic.dart';

part 'history.g.dart';

final INITIAL_PAINT = Paint()
  ..color = Colors.black
  ..strokeWidth = 1
  ..isAntiAlias = true
  ..style = PaintingStyle.stroke;

final Paint SELECTED_PAINT = Paint()
  ..color = Colors.blue
  ..strokeWidth = 1
  ..isAntiAlias = true
  ..style = PaintingStyle.stroke;

@JsonSerializable(ignoreUnannotated: true)
class HistoryModel {
  @JsonKey(name: 'actionList')
  List<DrawActionModel> actionList = [];

  @JsonKey(name: 'redoList')
  List<DrawActionModel> redoList = [];

  @JsonKey(name: 'color')
  String color;

  @JsonKey(name: 'thickness')
  double thickness;

  @JsonKey(name: 'opacity')
  double opacity;

  @JsonKey(name: 'zIndex')
  int zIndex;

  @JsonKey(name: 'mode')
  ActionTypeModel mode = ActionTypeModel.Path;

  late Paint _backgroundPaint;
  bool gridVisible = false;
  late Paint paint;
  late Paint selectedPaint;
  bool _pathFound = false;
  bool _inDrag = false;
  Offset? dragEnd;
  Offset? dragStart;
  bool eraseMode;
  bool _selectMode = false;

  double _eraseArea = 1.0;
  set selectMode(bool value) {
    _selectMode = value;
    selectEnd = null;
    selectStart = null;
  }

  Matrix4 matrix = Matrix4.zero();

  Offset? selectEnd;

  Offset? selectStart;

  bool _startFlag = false;
  double? _startX; //start X with a tap
  double? _startY; //start Y with a tap

  factory HistoryModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$HistoryModelToJson(this);

  HistoryModel({
    required this.actionList,
    required this.redoList,
    Paint? paint,
    Paint? selectedPaint,
    this.color = 'fff',
    this.thickness = 1,
    this.opacity = 1,
    this.zIndex = 0,
    this.eraseMode = false,
  }) {
    this.paint = paint ?? INITIAL_PAINT;
    this.selectedPaint = selectedPaint ?? SELECTED_PAINT;
    _backgroundPaint = Paint()..color = Colors.white;
  }

  // Private props

  int get getSelectingCount {
    var count = 0;
    if (actionList.isNotEmpty) {
      count = actionList.where((element) => element.isSelected).length;
    }
    return count;
  }

  List<DrawActionModel> get selectedPath {
    List<DrawActionModel> result = [];
    if (actionList.isNotEmpty) {
      result = actionList.where((element) => element.isSelected).toList();
    }
    return result;
  }

  set eraseArea(double r) {
    _eraseArea = r;
  }

  bool get canUndo => actionList.isNotEmpty;

  void undo() {
    if (!_inDrag && canUndo) {
      redoList.add(actionList.removeLast());
    }
  }

  bool get canRedo => redoList.isNotEmpty;

  void redo() {
    if (!_inDrag && canRedo) {
      actionList.add(redoList.removeLast());
    }
  }

  set backgroundColor(color) => _backgroundPaint.color = color;

  void addText(String text) {
    actionList.add(TextActionModel(
        text: text,
        paint: paint,
        selectedPaint: selectedPaint,
        opacity: opacity,
        style: TextStyleModel()));
  }

  void add(Offset startPoint) {
    final startPointModel = PointModel.fromOffset(startPoint);
    if (!_inDrag) {
      _inDrag = true;
    }
    // TODO: 1: improve smoothing
    // TODO: 2: add virtual object region for select
    // TODO 3: Add layer here
    // Path path = Path();
    // path.moveTo(startPoint.dx, startPoint.dy);
    // TODO: IMP
    // _lastPoint = startPoint;

    _startX = startPoint.dx;
    _startY = startPoint.dy;
    _startFlag = true;

    switch (mode) {
      case ActionTypeModel.Hand:
      case ActionTypeModel.Path:
        actionList.add(PathActionModel(
            paint: paint,
            selectedPaint: selectedPaint,
            opacity: opacity,
            actionType: mode,
            points: [startPointModel]));
        break;
      case ActionTypeModel.Line:
      case ActionTypeModel.MultiLine:
        actionList.add(LineActionModel(
            paint: paint,
            selectedPaint: selectedPaint,
            opacity: opacity,
            actionType: mode,
            points: [startPointModel]));
        break;
      case ActionTypeModel.Shape:
        actionList.add(ShapeActionModel(
            shape: ShapeModel.Rectangle,
            paint: paint,
            selectedPaint: selectedPaint,
            opacity: opacity,
            actionType: mode,
            points: [startPointModel]));
        break;
      case ActionTypeModel.ShapeRound:
        actionList.add(ShapeActionModel(
            shape: ShapeModel.Round,
            paint: paint,
            selectedPaint: selectedPaint,
            opacity: opacity,
            actionType: mode,
            points: [startPointModel]));
        break;
      case ActionTypeModel.ShapeTriangle:
        actionList.add(ShapeActionModel(
            shape: ShapeModel.Triangle,
            paint: paint,
            selectedPaint: selectedPaint,
            opacity: opacity,
            actionType: mode,
            points: [startPointModel]));
        break;
      case ActionTypeModel.ShapeOval:
        actionList.add(ShapeActionModel(
            shape: ShapeModel.Oval,
            paint: paint,
            selectedPaint: selectedPaint,
            opacity: opacity,
            actionType: mode,
            points: [startPointModel]));
        break;
      case ActionTypeModel.ShapeSquare:
        actionList.add(ShapeActionModel(
            shape: ShapeModel.Square,
            paint: paint,
            selectedPaint: selectedPaint,
            opacity: opacity,
            actionType: mode,
            points: [startPointModel]));
        break;
      default:
    }
  }

  void updateCurrent(Offset nextPoint) {
    final nextPointModel = PointModel.fromOffset(nextPoint);
    if (_inDrag) {
      _pathFound = false;
      if (actionList.isEmpty) return;

      if (!eraseMode) {
        final lastPath = actionList.lastOrNull;
        // TODO: smoothing
        //path.lineTo(nextPoint.dx, nextPoint.dy);
        // lastPath.drawLine(nextPoint);
        lastPath?.update(nextPointModel);
        _startFlag = false;
      } else {
        // TODO: convert this to simple ereaser by drag
        for (int i = 0; i < actionList.length; i++) {
          _pathFound = false;
          for (double x = nextPoint.dx - _eraseArea;
              x <= nextPoint.dx + _eraseArea;
              x++) {
            for (double y = nextPoint.dy - _eraseArea;
                y <= nextPoint.dy + _eraseArea;
                y++) {
              final point = PointModel(x: x, y: y);
              if (actionList[i].contains(point)) {
                redoList.add(actionList.removeAt(i));
                i--;
                _pathFound = true;
                break;
              }
            }
            if (_pathFound) {
              break;
            }
          }
        }
      }
    }
  }

  void endCurrent() {
    if ((_startFlag) && (!eraseMode)) {
      if (actionList.isEmpty) return;
      final lastPath = actionList.last;
      if (lastPath is PathActionModel) {
        lastPath.endLine(PointModel(x: _startX ?? 0, y: _startY ?? 0));
        _startFlag = false;
      }
    }
    _inDrag = false;
  }

  void calculateSelect() {
    // reset selection first
    for (var path in actionList) {
      path.isSelected = false;
    }

    if (selectStart == null || selectEnd == null) {
      bool hit = false;
      if (selectStart != null) {
        // Loop to _paths array in decending order
        for (var index = actionList.length - 1; index >= 0; index -= 1) {
          hit = actionList[index].checkPointSelected(selectStart!);
          if (hit) {
            break;
          }
        }
      }
      return;
    }

    for (DrawActionModel path in actionList) {
      path.checkRectSelected(selectStart, selectEnd);
    }
  }

  void clear() {
    if (!_inDrag) {
      actionList.clear();
      redoList.clear();
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    Paint paint = Paint();
    paint.isAntiAlias = true;
    paint.color = HexColor.fromHex('#D9D9D9');
    double cellWidth = 40;
    double cellHeight = 40;
    int numColumns = (width / cellWidth).floor() + 1;
    int numRows = (height / cellHeight).floor() + 1;

    // * Drawing rows
    for (int rowIndex = 0; rowIndex < numRows; rowIndex++) {
      canvas.drawLine(Offset(0, rowIndex * cellHeight),
          Offset(width, rowIndex * cellHeight), paint);
    }

    // * Drawing columns
    for (int colIndex = 1; colIndex < numColumns; colIndex++) {
      canvas.drawLine(Offset(colIndex * cellWidth, 0),
          Offset(colIndex * cellWidth, height), paint);
    }

    // for (int i = 1; i < numColumns; i++) {
    //   canvas.drawLine(i * cellWidth, 0, i * cellWidth, height, blackPaint);
    // }

    // for (int i = 1; i < numRows; i++) {
    //   canvas.drawLine(0, i * cellHeight, width, i * cellHeight, blackPaint);
    // }
  }

  bool hitTestSelectedPath(Offset point) {
    var hitTest = false;
    if (selectedPath.isNotEmpty) {
      for (var index = selectedPath.length - 1; index >= 0; index -= 1) {
        hitTest = selectedPath.elementAt(index).checkPointSelected(point);
        if (hitTest) {
          break;
        }
      }
    }

    return hitTest;
  }

  void dragSelecting(Offset point) {
    if (dragStart == null) return;
    if (selectedPath.isNotEmpty) {
      Vector2 moveVector =
          Vector2(point.dx - dragStart!.dx, point.dy - dragStart!.dy);
      for (var index = selectedPath.length - 1; index >= 0; index -= 1) {
        selectedPath.elementAt(index).move(moveVector);
      }
    }
  }

  void draw(Canvas canvas, Size size) {
    // if (matrix != null && matrix != Matrix4.zero()) {
    //   canvas.save();
    //   canvas.transform(matrix.storage);
    // }

    // canvas.drawImageNine(image, center, dst, paint)
    // * Drawing background color
    canvas.drawRect(
        Rect.fromLTWH(0.0, 0.0, size.width, size.height), _backgroundPaint);

    // * Drawing custom grid
    if (gridVisible) {
      _drawGrid(canvas, size);
    }

    if (selectStart != null && selectEnd != null) {
      var selectPaint = Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.blue;

      canvas.drawRect(Rect.fromPoints(selectStart!, selectEnd!), selectPaint);
    }

    // TODO: Convert path to a custom obejct that contain more meta data;
    for (DrawActionModel path in actionList) {
      path.draw(canvas, _selectMode);
    }

    // if (matrix != null && matrix != Matrix4.zero()) {
    //   canvas.restore();
    // }
  }

  static init() {
    return HistoryModel(
        actionList: [], redoList: [], paint: null, selectedPaint: null);
  }
}
