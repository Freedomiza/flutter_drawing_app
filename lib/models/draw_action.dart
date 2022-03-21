import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

import './action_type.dart';
import './generic.dart';

part 'draw_action.g.dart';

@JsonSerializable(ignoreUnannotated: true)
class DrawActionModel {
  @JsonKey(ignore: true)
  Paint? paint;
  @JsonKey(ignore: true)
  Paint? selectedPaint;

  @JsonKey(name: 'boundDistance')
  double boundDistance = 10;
  @JsonKey(name: 'actionType')
  ActionTypeModel actionType;
  @JsonKey(name: 'opacity')
  double opacity;
  @JsonKey(name: 'isSelected')
  bool isSelected;
  @JsonKey(name: 'points')
  List<PointModel> points;
  @JsonKey(name: 'zIndex')
  int zIndex;

  factory DrawActionModel.fromJson(Map<String, dynamic> json) =>
      _$DrawActionModelFromJson(json);
  Map<String, dynamic> toJson() => _$DrawActionModelToJson(this);

  DrawActionModel({
    this.actionType = ActionTypeModel.Hand,
    this.opacity = 1,
    this.paint,
    this.selectedPaint,
    this.points = const [],
    this.isSelected = false,
    this.zIndex = 0,
  });

  Rect get boundingBox {
    final firstPoint = points.first;
    final lastPoint = points.last;

    var drawRect = Rect.fromPoints(
        Offset(firstPoint.x, firstPoint.y), Offset(lastPoint.x, lastPoint.y));
    var boundingRect = Rect.fromLTRB(
        drawRect.topLeft.dx - boundDistance,
        drawRect.topLeft.dy - boundDistance,
        drawRect.bottomRight.dx + boundDistance,
        drawRect.bottomRight.dy + boundDistance);
    return boundingRect;
  }

  Paint get drawPaint =>
      isSelected == true ? (selectedPaint ?? Paint()) : (paint ?? Paint());

  Paint get boundingBoxPaint => Paint()
    ..color = Colors.blue.withOpacity(0.5)
    ..strokeWidth = 1
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke;

  void checkRectSelected(Offset? start, Offset? end) {
    if (start == null || end == null) return;
    var boundingRect = boundingBox;
    var selectingRect = Rect.fromPoints(start, end);
    var intersectRect = selectingRect.intersect(boundingRect);
    isSelected = false;
    if (!intersectRect.isEmpty &&
        intersectRect.width > 0 &&
        intersectRect.height > 0) {
      isSelected = true;
    } else {
      isSelected = false;
    }
    return;
  }

  void draw(Canvas canvas, [bool isSelected = false]) {
    if (isSelected == true) {
      canvas.drawRect(boundingBox, boundingBoxPaint);
    }
  }

  bool checkPointSelected(Offset offset) {
    // Reset selection
    isSelected = false;
    var boundingRect = boundingBox;
    if (boundingRect.isEmpty || boundingRect.hasNaN) return isSelected;
    if (offset.dx >= boundingRect.topLeft.dx &&
        offset.dy >= boundingRect.topLeft.dy &&
        offset.dx <= boundingRect.bottomRight.dx &&
        offset.dy <= boundingRect.bottomRight.dy) {
      isSelected = true;
    } else {
      isSelected = false;
    }
    return isSelected;
  }

  void update(PointModel nextPoint) {}

  void move(Vector2 moveVector) {
    if (points.isEmpty) {
      return;
    }
    for (final point in points) {
      point.move(moveVector);
    }
  }

  bool contains(PointModel point) {
    final offset = point.offset;
    return checkPointSelected(offset);
  }
}

@JsonSerializable()
class TextActionModel extends DrawActionModel {
  String text;
  TextStyleModel style;

  TextActionModel({
    required this.text,
    required this.style,
    Paint? paint,
    Paint? selectedPaint,
    double opacity = 1,
    ActionTypeModel actionType = ActionTypeModel.Text,
    bool isSelected = false,
    List<PointModel> points = const [],
    int zIndex = 0,
  }) : super(
          paint: paint,
          selectedPaint: selectedPaint,
          actionType: actionType,
          opacity: opacity,
          isSelected: isSelected,
          points: points,
          zIndex: zIndex,
        );

  @override
  void draw(Canvas canvas, [bool isSelected = false]) {
    // TODO: implement text draw
    super.draw(canvas, isSelected);
    print("Drawing text $text");
    if (points.isEmpty) return;
    final startPoint = points.first;
    final endPoint = points.last;

    TextSpan span = TextSpan(
        style: TextStyle(color: drawPaint.color, fontSize: 24.0), text: text);
    TextPainter textPainter =
        TextPainter(text: span, textDirection: TextDirection.ltr);
    textPainter.layout();
    textPainter.paint(canvas, const Offset(200, 200));

    canvas.drawRect(
        Rect.fromPoints(startPoint.offset, endPoint.offset), drawPaint);
  }

  @override
  void update(PointModel nextPoint) {
    if (points.length < 2) {
      points.add(nextPoint);
      return;
    }
    points[points.length - 1] = nextPoint;
  }

  factory TextActionModel.fromJson(Map<String, dynamic> json) =>
      _$TextActionModelFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TextActionModelToJson(this);
}

@JsonSerializable(ignoreUnannotated: true)
class LineActionModel extends DrawActionModel {
  LineActionModel({
    Paint? paint,
    Paint? selectedPaint,
    required ActionTypeModel actionType,
    required double opacity,
    List<PointModel> points = const [],
    bool isSelected = false,
    int zIndex = 0,
  }) : super(
          paint: paint,
          selectedPaint: selectedPaint,
          actionType: actionType,
          opacity: opacity,
          isSelected: isSelected,
          points: points,
          zIndex: zIndex,
        );
  @override
  void draw(Canvas canvas, [bool isSelected = false]) {
    super.draw(canvas, this.isSelected);
    if (points.isEmpty) return;
    final startPoint = points.first;
    final endPoint = points.last;

    canvas.drawLine(startPoint.offset, endPoint.offset, drawPaint);
  }

  @override
  void update(PointModel nextPoint) {
    if (points.length < 2) {
      points.add(nextPoint);
      return;
    }
    points[points.length - 1] = nextPoint;
  }

  factory LineActionModel.fromJson(Map<String, dynamic> json) =>
      _$LineActionModelFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$LineActionModelToJson(this);
}

@JsonSerializable(ignoreUnannotated: true)
class PathActionModel extends DrawActionModel {
  late Path path;

  PathActionModel({
    Paint? paint,
    Paint? selectedPaint,
    ActionTypeModel actionType = ActionTypeModel.Path,
    double opacity = 1,
    bool isSelected = false,
    List<PointModel> points = const [],
    int zIndex = 0,
    Path? path,
  }) : super(
            actionType: actionType,
            isSelected: isSelected,
            opacity: opacity,
            paint: paint,
            selectedPaint: selectedPaint,
            points: points,
            zIndex: zIndex) {
    this.path = path ?? Path();
    if (points.isNotEmpty) {
      final firstPoint = points.first;
      this.path.moveTo(firstPoint.x, firstPoint.y);
    }

    // if (this.points.length > 0) {
    //   final firstPoint = this.points.first;
    //   final lastPoint = this.points.last;
    //   this.path.moveTo(firstPoint.x, firstPoint.y);
    //   // Init path based on Points
    //   this.points.sublist(1).forEach((point) {
    //     this.path.lineTo(point.x, point.y);
    //   });
    //   this.endLine(lastPoint);
    // }
  }

  @override
  void draw(Canvas canvas, [bool isSelected = false]) {
    super.draw(canvas, this.isSelected);
    canvas.drawPath(path, drawPaint);
  }

  @override
  Rect get boundingBox {
    var drawRect = path.getBounds();
    var boundingRect = Rect.fromLTRB(
        drawRect.topLeft.dx - boundDistance,
        drawRect.topLeft.dy - boundDistance,
        drawRect.bottomRight.dx + boundDistance,
        drawRect.bottomRight.dy + boundDistance);
    return boundingRect;
  }

  void endLine(PointModel endPoint) {
    Offset offset = Offset(endPoint.x, endPoint.y);
    var endCircle = Rect.fromCircle(center: offset, radius: 1.0);

    path.fillType = PathFillType.evenOdd;
    path.addOval(endCircle);
    path.close();
  }

  @override
  void update(PointModel nextPoint) {
    path.lineTo(nextPoint.x, nextPoint.y);
    points.add(nextPoint);
  }

  factory PathActionModel.fromJson(Map<String, dynamic> json) =>
      _$PathActionModelFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PathActionModelToJson(this);
}

@JsonSerializable(ignoreUnannotated: true)
class ShapeActionModel extends DrawActionModel {
  @JsonKey()
  ShapeModel shape;
  @JsonKey()
  BackgroundModel? background;

  late Path path;

  ShapeActionModel({
    Paint? paint,
    Paint? selectedPaint,
    List<PointModel> points = const [],
    required this.shape,
    double opacity = 1,
    this.background,
    ActionTypeModel actionType = ActionTypeModel.Shape,
    bool isSelected = false,
    Path? path,
    int zIndex = 0,
  }) : super(
          actionType: actionType,
          isSelected: isSelected,
          opacity: opacity,
          paint: paint,
          selectedPaint: selectedPaint,
          points: points,
          zIndex: zIndex,
        ) {
    if (path != null) {
      this.path = path;
      return;
    }
    this.path = Path();
  }

  @override
  void draw(Canvas canvas, [bool isSelected = false]) {
    super.draw(canvas, isSelected);
    _drawShape(canvas, shape);
  }

  @override
  void update(PointModel nextPoint) {
    if (points.length < 2) {
      points.add(nextPoint);
      return;
    }
    points[points.length - 1] = nextPoint;
  }

  void _drawShape(Canvas canvas, ShapeModel shape) {
    if (points.isEmpty) return;
    final firstPoint = points.first;
    final lastPoint = points.last;

    switch (shape) {
      case ShapeModel.Oval:
        canvas.drawOval(
            Rect.fromPoints(firstPoint.offset, lastPoint.offset), drawPaint);
        break;
      case ShapeModel.Triangle:
        _drawTriangle(firstPoint, lastPoint, canvas);
        break;
      case ShapeModel.Rectangle:
      default:
        canvas.drawRect(
            Rect.fromPoints(firstPoint.offset, lastPoint.offset), drawPaint);
        break;
    }
  }

  void _drawTriangle(
      PointModel firstPoint, PointModel lastPoint, Canvas canvas) {
    Rect rect = Rect.fromPoints(firstPoint.offset, lastPoint.offset);
    Path trianglePath = Path();
    trianglePath.moveTo(rect.bottomLeft.dx, rect.bottomLeft.dy);
    trianglePath.lineTo(rect.bottomRight.dx, rect.bottomRight.dy);
    trianglePath.lineTo(rect.topCenter.dx, rect.topCenter.dy);
    trianglePath.lineTo(rect.bottomLeft.dx, rect.bottomLeft.dy);
    // path.lineTo(rect.bottomCenter.dx, rect.bottomCenter.dy);
    trianglePath.close();
    if (paint != null) {
      canvas.drawPath(trianglePath, paint!);
    }
  }
}

// class BackgroundActionModel extends DrawActionModel {
//   BackgroundModel background;
//   BackgroundActionModel({
//     required this.background,
//   }):super(
//     actionType: ActionTypeModel.Background,
//   );

//   @override
//   void draw(Canvas canvas, [bool isSelected]) {
//     // TODO: implement draw
//     throw UnimplementedError();
//   }

//   @override
//   void update(PointModel nextPoint) {
//     // TODO: implement update
//     throw UnimplementedError();
//   }
// }

// // TODO: need a way to custom erase
// class EraseActionModel extends DrawActionModel {
//   @override
//   void update(PointModel nextPoint) {}
// }
