// import 'dart:ui';

// import 'package:canvas_drawing/extensions/hex_color.dart';
// import 'package:canvas_drawing/models/story/action_type_model.dart';
// import 'package:canvas_drawing/models/story/draw_action_model.dart';
// import 'package:canvas_drawing/models/story/generic_model.dart';
// import 'package:canvas_drawing/resources/styles.dart';
// import 'package:flutter/material.dart';
// import 'package:vector_math/vector_math_64.dart' hide Colors;

// const double boundDistance = 10;

// final Paint boundingBoxPaint = new Paint()
//   ..color = Colors.blue.withOpacity(0.5)
//   ..strokeWidth = 1
//   ..isAntiAlias = true
//   ..style = PaintingStyle.stroke;

// final Paint selectedPaint = new Paint()
//   ..color = Colors.blue
//   ..strokeWidth = 1
//   ..isAntiAlias = true
//   ..style = PaintingStyle.stroke;

// // class HistoryRecord {
// //   HistoryRecord(this.path, this.paint, this.mode, [this.text, this.textStyle]);

// //   Offset firstPoint;
// //   Offset lastPoint;
// //   int layer;
// //   final DrawMode mode;
// //   // Rect rect;
// //   double opacity;

// //   final Paint paint;
// //   final Path path;
// //   List<Offset> points;
// //   List<Offset> savedPoints = [];
// //   bool selected = false;
// //   final String text;
// //   final TextStyle textStyle;

// //   Rect get boundingBox {
// //     switch (mode) {
// //       case DrawMode.Square:
// //       case DrawMode.Oval:
// //       case DrawMode.Line:
// //       case DrawMode.Round:
// //       case DrawMode.Triangle:
// //         {
// //           var drawRect = Rect.fromPoints(firstPoint, lastPoint);
// //           var boundingRect = Rect.fromLTRB(
// //               drawRect.topLeft.dx - boundDistance,
// //               drawRect.topLeft.dy - boundDistance,
// //               drawRect.bottomRight.dx + boundDistance,
// //               drawRect.bottomRight.dy + boundDistance);
// //           return boundingRect;
// //         }
// //       case DrawMode.Path:
// //       default:
// //         {
// //           var drawRect = path.getBounds();
// //           var boundingRect = Rect.fromLTRB(
// //               drawRect.topLeft.dx - boundDistance,
// //               drawRect.topLeft.dy - boundDistance,
// //               drawRect.bottomRight.dx + boundDistance,
// //               drawRect.bottomRight.dy + boundDistance);
// //           return boundingRect;
// //         }
// //     }
// //   }

// //   void update(Offset nextPoint) {
// //     Path path = this.path;
// //     // TODO: smoothing
// //     switch (mode) {
// //       case DrawMode.Square:
// //       case DrawMode.Oval:
// //       case DrawMode.Round:
// //       case DrawMode.Triangle:
// //       case DrawMode.Line:
// //         {
// //           if (firstPoint == null) {
// //             firstPoint = nextPoint;
// //           } else {
// //             lastPoint = nextPoint;
// //           }
// //           return;
// //         }

// //       case DrawMode.MultiLine:
// //         {
// //           if (firstPoint == null) {
// //             firstPoint = nextPoint;
// //           } else {
// //             lastPoint = nextPoint;
// //             points.add(nextPoint);
// //           }
// //           return;
// //         }
// //       case DrawMode.Path:
// //       default:
// //         {
// //           path.lineTo(nextPoint.dx, nextPoint.dy);
// //           // Saving point for future modify
// //           savedPoints.add(nextPoint);
// //           return;
// //         }
// //     }
// //   }

// //   void endLine(Offset offset) {
// //     var endCircle = Rect.fromCircle(center: offset, radius: 1.0);
// //     //if it was just a tap, draw a point and reset a flag
// //     // if(firstPoint.dx == lastPoint.dx &&
// //     // firstPoint.dy == lastPoint.dy) {

// //     // }

// //     path.fillType = PathFillType.evenOdd;
// //     path.addOval(endCircle);
// //     path.close();
// //   }

// //   _drawTriangle(Offset start, Offset end, Paint paint, Canvas canvas) {
// //     Rect rect = Rect.fromPoints(start, end);

// //     Path path = Path();

// //     path.moveTo(rect.bottomLeft.dx, rect.bottomLeft.dy);

// //     path.lineTo(rect.bottomRight.dx, rect.bottomRight.dy);

// //     path.lineTo(rect.topCenter.dx, rect.topCenter.dy);
// //     path.lineTo(rect.bottomLeft.dx, rect.bottomLeft.dy);
// //     // path.lineTo(rect.bottomCenter.dx, rect.bottomCenter.dy);
// //     path.close();
// //     canvas.drawPath(path, paint);
// //   }

// //   void checkRectSelected(Offset start, Offset end) {
// //     var boundingRect = this.boundingBox;
// //     var selectingRect = Rect.fromPoints(start, end);
// //     var intersectRect = selectingRect.intersect(boundingRect);
// //     selected = false;
// //     if (intersectRect != null &&
// //         intersectRect.width > 0 &&
// //         intersectRect.height > 0) {
// //       selected = true;
// //       // print('found');
// //     } else {
// //       selected = false;
// //     }
// //     return;
// //   }

// //   bool checkPointSelected(Offset offset) {
// //     // Reset selection
// //     selected = false;
// //     var boundingRect = this.boundingBox;
// //     if (boundingRect == null || boundingRect.hasNaN) return selected;
// //     if (offset.dx >= boundingRect.topLeft.dx &&
// //         offset.dy >= boundingRect.topLeft.dy &&
// //         offset.dx <= boundingRect.bottomRight.dx &&
// //         offset.dy <= boundingRect.bottomRight.dy) {
// //       selected = true;
// //     } else {
// //       selected = false;
// //     }
// //     return selected;
// //   }

// //   void move(Vector2 moveVector) {
// //     print("Moving to $moveVector");
// //     switch (mode) {
// //       case DrawMode.Path:
// //       default:
// //         {
// //           if (savedPoints != null && savedPoints.length > 0) {
// //             path.reset();
// //             var firstPoint = savedPoints[0];
// //             path.moveTo(
// //                 firstPoint.dx + moveVector.x, firstPoint.dy + moveVector.y);
// //             savedPoints.forEach((point) {
// //               path.lineTo(point.dx + moveVector.x, point.dy + moveVector.y);
// //             });
// //             // path.close();
// //           }
// //           return;
// //         }
// //     }
// //   }

// //   void drawTo(Canvas canvas, [bool selectMode]) {
// //     if (selectMode) {
// //       canvas.drawRect(this.boundingBox, boundingBoxPaint);
// //     }
// //     var drawPaint =
// //         selected ? (selectedPaint..strokeWidth = paint.strokeWidth) : paint;

// //     switch (mode) {
// //       case DrawMode.Text:
// //         {
// //           print("Drawing text $text");
// //           TextSpan span = new TextSpan(
// //               style: new TextStyle(color: Colors.blue[800], fontSize: 24.0),
// //               text: text);
// //           TextPainter textPainter =
// //               TextPainter(text: span, textDirection: TextDirection.ltr);
// //           textPainter.layout();
// //           textPainter.paint(canvas, Offset(200, 200));
// //           canvas.drawRect(Rect.fromCenter(center: Offset(200, 100)), drawPaint);
// //           return;
// //         }
// //       case DrawMode.Square:
// //         {
// //           if (firstPoint != null && lastPoint != null) {
// //             var drawRect = Rect.fromPoints(firstPoint, lastPoint);
// //             canvas.drawRect(drawRect, drawPaint);
// //           }
// //           return;
// //         }
// //       case DrawMode.Oval:
// //         {
// //           if (firstPoint != null && lastPoint != null) {
// //             canvas.drawOval(Rect.fromPoints(firstPoint, lastPoint), drawPaint);
// //           }
// //           return;
// //         }

// //       case DrawMode.Triangle:
// //         {
// //           if (firstPoint != null && lastPoint != null) {
// //             _drawTriangle(firstPoint, lastPoint, drawPaint, canvas);
// //           }
// //           if (selectMode) {
// //             canvas.drawRect(this.boundingBox, boundingBoxPaint);
// //           }
// //           return;
// //         }
// //       case DrawMode.Line:
// //         {
// //           if (firstPoint != null && lastPoint != null) {
// //             canvas.drawLine(firstPoint, lastPoint, drawPaint);
// //           }
// //           return;
// //         }
// //       case DrawMode.Round:
// //         {
// //           if (firstPoint != null && lastPoint != null) {
// //             canvas.drawRRect(
// //                 RRect.fromRectXY(
// //                     Rect.fromPoints(firstPoint, lastPoint), 10, 10),
// //                 drawPaint);
// //           }
// //           return;
// //         }
// //       case DrawMode.MultiLine:
// //         {
// //           if (firstPoint != null && lastPoint != null) {
// //             Path multiPath = new Path();
// //             multiPath.moveTo(firstPoint.dx, firstPoint.dy);
// //             points.forEach((point) {
// //               multiPath.lineTo(point.dx, point.dy);
// //             });

// //             multiPath.close();
// //             canvas.drawPath(multiPath, drawPaint);
// //           }
// //           return;
// //         }

// //       case DrawMode.Path:
// //       default:
// //         {
// //           // selectedPaint.color = Colors.red;
// //           canvas.drawPath(this.path, drawPaint);
// //           return;
// //         }
// //     }
// //   }
// // }

// class PathHistory {
//   PathHistory() {
//     _paths = List<DrawActionModel>();
//     _undone = List<DrawActionModel>();
//     _inDrag = false;
//     _backgroundPaint = Paint();
//     drawGrid = false;
//   }
//   double opacity;
//   Paint currentPaint;
//   Offset dragEnd;
//   Offset dragStart;
//   bool drawGrid = false;
//   bool erase;
//   Matrix4 matrix = Matrix4.zero();
//   ActionTypeModel mode = ActionTypeModel.Path;
//   Offset selectEnd;
//   bool selectMode = false;
//   Offset selectStart;

//   Paint _backgroundPaint;
//   bool _erase = false;
//   double _eraseArea = 1.0;
//   bool _inDrag;
//   bool _pathFound = false;
//   List<DrawActionModel> _paths;
//   bool _startFlag = false;
//   double _startX; //start X with a tap
//   double _startY; //start Y with a tap
//   List<DrawActionModel> _undone;

//   int get selectingCount {
//     var count = 0;
//     if (_paths != null && _paths.length > 0) {
//       count = _paths.where((element) => element.isSelected).length;
//     }
//     return count;
//   }

//   List<DrawActionModel> get selectedPath {
//     List<DrawActionModel> result = [];
//     if (_paths != null && _paths.length > 0) {
//       result = _paths.where((element) => element.isSelected).toList();
//     }
//     return result;
//   }

//   set eraseArea(double r) {
//     _eraseArea = r;
//   }

//   bool canUndo() => _paths.length > 0;

//   void undo() {
//     if (!_inDrag && canUndo()) {
//       _undone.add(_paths.removeLast());
//     }
//   }

//   bool canRedo() => _undone.length > 0;

//   void redo() {
//     if (!_inDrag && canRedo()) {
//       _paths.add(_undone.removeLast());
//     }
//   }

//   void clear() {
//     if (!_inDrag) {
//       _paths.clear();
//       _undone.clear();
//     }
//   }

//   set backgroundColor(color) => _backgroundPaint.color = color;

//   // Offset _lastPoint;

//   void addText(String text) {
//     _paths.add(TextActionModel(
//       text: text,
//       paint: currentPaint,
//       opacity: opacity,
//     ));
//   }

//   void add(Offset startPoint) {
//     // TODO: try tranfoms with matrix
//     // startPoint.tra

//     if (!_inDrag) {
//       _inDrag = true;
//       // TODO: 1: improve smoothing
//       // TODO: 2: add virtual object region for select
//       // TODO 3: Add layer here
//       // Path path = Path();
//       // path.moveTo(startPoint.dx, startPoint.dy);
//       // TODO: IMP
//       // _lastPoint = startPoint;

//       _startX = startPoint.dx;
//       _startY = startPoint.dy;
//       _startFlag = true;
//       switch (mode) {
//         case ActionTypeModel.Hand:
//           _paths.add(PathActionModel(
//               paint: currentPaint,
//               selectedPaint: selectedPaint,
//               opacity: opacity,
//               actionType: mode,
//               points: [PointModel.fromOffset(startPoint)]));
//           break;
//         case ActionTypeModel.Line:
//         case ActionTypeModel.MultiLine:
//           _paths.add(LineActionModel(
//               paint: currentPaint,
//               selectedPaint: selectedPaint,
//               opacity: opacity,
//               actionType: mode,
//               points: [PointModel.fromOffset(startPoint)]));
//           break;
//         case ActionTypeModel.Shape:
//           _paths.add(ShapeActionModel(
//               // TODO: add shape here
//               shape: ShapeModel.Rectangle,
//               paint: currentPaint,
//               selectedPaint: selectedPaint,
//               opacity: opacity,
//               actionType: mode,
//               points: [PointModel.fromOffset(startPoint)]));
//           break;
//         default:
//       }
//     }
//   }

//   void updateCurrent(Offset nextPoint) {
//     if (_inDrag) {
//       _pathFound = false;
//       if (!_erase) {
//         final lastPath = _paths.last;
//         // TODO: smoothing
//         //path.lineTo(nextPoint.dx, nextPoint.dy);
//         // lastPath.drawLine(nextPoint);
//         lastPath.update(PointModel.fromOffset(nextPoint));
//         _startFlag = false;
//       } else {
//         // TODO: convert this to simple ereaser by drag
//         for (int i = 0; i < _paths.length; i++) {
//           _pathFound = false;
//           for (double x = nextPoint.dx - _eraseArea;
//               x <= nextPoint.dx + _eraseArea;
//               x++) {
//             for (double y = nextPoint.dy - _eraseArea;
//                 y <= nextPoint.dy + _eraseArea;
//                 y++) {
//               final point = PointModel(x: x, y: y);
//               if (_paths[i].contains(point)) {
//                 _undone.add(_paths.removeAt(i));
//                 i--;
//                 _pathFound = true;
//                 break;
//               }
//             }
//             if (_pathFound) {
//               break;
//             }
//           }
//         }
//       }
//     }
//   }

//   void endCurrent() {
//     if ((_startFlag) && (!_erase)) {
//       final lastPath = _paths.last;
//       if (lastPath is PathActionModel) {
//         lastPath.endLine(PointModel(x: _startX, y: _startY));
//         _startFlag = false;
//       }
//     }
//     _inDrag = false;
//   }

//   void calculateSelect() {
//     // reset selection first
//     _paths.forEach((path) {
//       path.isSelected = false;
//     });
//     if (selectStart != null && selectEnd != null) {
//       for (DrawActionModel path in _paths) {
//         path.checkRectSelected(selectStart, selectEnd);
//       }
//     } else {
//       bool hit = false;
//       if (selectStart != null) {
//         // Loop to _paths array in decending order

//         for (var index = _paths.length - 1; index >= 0; index -= 1) {
//           hit = _paths.elementAt(index).checkPointSelected(selectStart);
//           if (hit) {
//             break;
//           }
//         }
//       }
//     }
//   }

//   void _drawGrid(Canvas canvas, Size size) {
//     double width = size.width;
//     double height = size.height;
//     Paint paint = new Paint();
//     paint.isAntiAlias = true;
//     paint.color = HexColor.fromHex('#D9D9D9');
//     double cellWidth = 40;
//     double cellHeight = 40;
//     int numColumns = (width / cellWidth).floor() + 1;
//     int numRows = (height / cellHeight).floor() + 1;

//     // * Drawing rows
//     for (int rowIndex = 0; rowIndex < numRows; rowIndex++) {
//       canvas.drawLine(Offset(0, rowIndex * cellHeight),
//           Offset(width, rowIndex * cellHeight), paint);
//     }

//     // * Drawing columns
//     for (int colIndex = 1; colIndex < numColumns; colIndex++) {
//       canvas.drawLine(Offset(colIndex * cellWidth, 0),
//           Offset(colIndex * cellWidth, height), paint);
//     }

//     // for (int i = 1; i < numColumns; i++) {
//     //   canvas.drawLine(i * cellWidth, 0, i * cellWidth, height, blackPaint);
//     // }

//     // for (int i = 1; i < numRows; i++) {
//     //   canvas.drawLine(0, i * cellHeight, width, i * cellHeight, blackPaint);
//     // }
//   }

//   bool hitTestSelectedPath(Offset point) {
//     var hitTest = false;
//     if (selectedPath.length > 0) {
//       for (var index = selectedPath.length - 1; index >= 0; index -= 1) {
//         hitTest = selectedPath.elementAt(index).checkPointSelected(point);
//         if (hitTest) {
//           break;
//         }
//       }
//     }

//     return hitTest;
//   }

//   void dragSelecting(Offset point) {
//     if (selectedPath.length > 0) {
//       Vector2 moveVector =
//           Vector2(point.dx - dragStart.dx, point.dy - dragStart.dy);
//       for (var index = selectedPath.length - 1; index >= 0; index -= 1) {
//         selectedPath.elementAt(index).move(moveVector);
//       }
//     }
//   }

//   void draw(Canvas canvas, Size size) {
//     // if (matrix != null && matrix != Matrix4.zero()) {
//     //   canvas.save();
//     //   canvas.transform(matrix.storage);
//     // }

//     // canvas.drawImageNine(image, center, dst, paint)
//     // * Drawing background color
//     canvas.drawRect(
//         Rect.fromLTWH(0.0, 0.0, size.width, size.height), _backgroundPaint);

//     // * Drawing custom grid
//     if (drawGrid) {
//       _drawGrid(canvas, size);
//     }

//     if (selectStart != null && selectEnd != null) {
//       var selectPaint = new Paint();
//       selectPaint.style = PaintingStyle.stroke;
//       selectPaint.color = Styles.primaryColor;
//       canvas.drawRect(Rect.fromPoints(selectStart, selectEnd), selectPaint);
//     }

//     // TODO: Convert path to a custom obejct that contain more meta data;
//     for (DrawActionModel path in _paths) {
//       path.draw(canvas, selectMode);
//     }

//     // if (matrix != null && matrix != Matrix4.zero()) {
//     //   canvas.restore();
//     // }
//   }
// }
