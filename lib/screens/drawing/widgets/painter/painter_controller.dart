import 'dart:typed_data';
import 'dart:ui' as ui;
// import 'package:canvas_drawing/constants/draw_const.dart';
import 'package:canvas_drawing/models/story/action_type_model.dart';
import 'package:canvas_drawing/models/story/history_model.dart';
import 'package:canvas_drawing/screens/drawing_tools/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' hide Image;
import 'package:flutter/material.dart' as mat show Image;
import 'package:flutter/rendering.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

final INITIAL_PAINT = new Paint()
  ..color = Colors.black
  ..strokeWidth = 1
  ..isAntiAlias = true
  ..style = PaintingStyle.stroke;

final Paint SELECTED_PAINT = new Paint()
  ..color = Colors.blue
  ..strokeWidth = 1
  ..isAntiAlias = true
  ..style = PaintingStyle.stroke;

class PainterController extends PropertyChangeNotifier<String> {
  Color _drawColor = Color.fromARGB(255, 0, 0, 0);
  Color _backgroundColor = Color.fromARGB(255, 255, 255, 255);
  mat.Image _bgimage;
  double _thickness = 3.0;
  double _erasethickness = 3.0;
  double _opacity = 1;

  HistoryModel _pathHistory;
  HistoryModel get pathHistory => _pathHistory;
  set pathHistory(value) {
    _pathHistory = value;
  }

  ActionTypeModel get mode => _pathHistory.mode;
  set mode(ActionTypeModel value) {
    _pathHistory.mode = value;
    _updatePaint();
  }

  Matrix4 _matrix = Matrix4.zero();

  Matrix4 getMatrix() => _matrix;
  void setMatrix(Matrix4 val) {
    _matrix = val;
    _updatePaint();
  }

  bool _zoomMode = false;
  bool get zoomMode => _zoomMode;
  set zoomMode(bool value) {
    _zoomMode = value;
    notifyListeners("zoomMode");
    _updatePaint();
  }

  bool _selectMode = false;
  bool get selectMode => _selectMode;
  set selectMode(bool value) {
    _selectMode = value;

    pathHistory.selectMode = value;
    notifyListeners("selectMode");
    _updatePaint();
  }

  GlobalKey _globalKey;
  set globalKey(GlobalKey key) {
    _globalKey = key;
  }

  PainterController(double frameWidth, double frameHeight) {
    _pathHistory = HistoryModel(
      actionList: [],
      redoList: [],
      color: 'FFF',
      opacity: 1,
      paint: INITIAL_PAINT,
      selectedPaint: SELECTED_PAINT,
    );

    this.setMatrix(
        DrawerHelper.getCenterTranformMatrix(frameWidth, frameHeight));
  }

  Color get drawColor => _drawColor;
  set drawColor(Color color) {
    _drawColor = color;
    _updatePaint();
  }

  Color get backgroundColor => _backgroundColor;
  set backgroundColor(Color cl) {
    _backgroundColor = cl;
    _updatePaint();
  }

  mat.Image get backgroundImage => _bgimage;
  set backgroundImage(mat.Image image) {
    _bgimage = image;
    _updatePaint();
  }

  double get thickness => _thickness;
  set thickness(double t) {
    _thickness = t;
    _updatePaint();
  }

  double get erasethickness => _erasethickness;
  set erasethickness(double t) {
    _erasethickness = t;
    _pathHistory.eraseArea = t;
    _updatePaint();
  }

  bool get eraser => _pathHistory.eraseMode; //setter / getter for eraser
  set eraser(bool e) {
    _pathHistory.eraseMode = e;
    _pathHistory.eraseArea = _erasethickness;
    _updatePaint();
  }

  double get opacity => _opacity;
  set opacity(double o) {
    _opacity = o;
    _updatePaint();
    // Todo: implement Opacity
  }

  bool _gridMode = false;
  bool get gridMode => _gridMode;
  set gridMode(bool value) {
    _gridMode = value;
    _updatePaint();
  }

  int get selectingCount {
    return pathHistory.getSelectingCount;
  }

  bool dragMode = false;

  Offset get dragStart => pathHistory.dragStart;
  set dragStart(Offset value) {
    pathHistory.dragStart = _mapToCurrentView(value);
  }

  Offset get dragEnd => pathHistory.dragEnd;
  set dragEnd(Offset value) {
    pathHistory.dragEnd = _mapToCurrentView(value);
  }

  /// Check can undo / redo flag
  bool get canUndo => _pathHistory.canUndo();
  bool get canRedo => _pathHistory.canRedo();

  void _updatePaint() {
    Paint paint = Paint();
    paint.isAntiAlias = true;
    paint.color = drawColor.withOpacity(opacity);
    paint.style = PaintingStyle.stroke;

    paint.strokeWidth = thickness;
    _pathHistory.opacity = _opacity;
    _pathHistory.paint = paint;
    _pathHistory.gridVisible = _gridMode;
    _pathHistory.matrix = _matrix;
    if (_bgimage != null) {
      _pathHistory.backgroundColor = Color(0x00000000);
    } else {
      _pathHistory.backgroundColor = _backgroundColor;
    }
    notifyListeners();
  }

  void undo() {
    _pathHistory.undo();
    notifyListeners();
  }

  void redo() {
    _pathHistory.redo();
    notifyListeners();
  }

  void toggleGrid(bool gridVisible) {
    _pathHistory.gridVisible = gridVisible;
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

  void clear() {
    _pathHistory.clear();
    notifyListeners();
  }

  void addText(String text) {
    _pathHistory.addText(text);
  }

  Future<Uint8List> exportAsPNGBytes() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData.buffer.asUint8List();
  }

  void add(Offset pos) {
    pathHistory.add(
      _mapToCurrentView(pos),
    );
    this.notify();
  }

  void update(Offset pos) {
    pathHistory.updateCurrent(_mapToCurrentView(pos));
    this.notify();
  }

  void end() {
    pathHistory.endCurrent();
    this.notify();
  }

  void addSelectPoint(Offset pos) {
    pathHistory.selectEnd = null;
    pathHistory.selectStart = _mapToCurrentView(pos);
    this.notify();
  }

  void updateSelectPoint(Offset pos) {
    pathHistory.selectEnd = _mapToCurrentView(pos);
    this.notify();
  }

  void calculateSelect() {
    pathHistory.calculateSelect();
    _updatePaint();
    this.notify();
  }

  void clearSelectPoint() {
    pathHistory.selectEnd = null;
    pathHistory.selectStart = null;
    pathHistory.dragStart = null;
    pathHistory.dragEnd = null;
  }

  Offset _mapToCurrentView(Offset pos) {
    Vector3 newPos = new Vector3(pos.dx, pos.dy, 0);

    if (_matrix != null && _matrix != Matrix4.zero()) {
      var m = new Matrix4.zero();
      m.copyInverse(_matrix);
      newPos.applyMatrix4(m);
    }
    return new Offset(newPos.x, newPos.y);
  }

  void resetMode() {
    eraser = false;
    selectMode = false;
    mode = ActionTypeModel.Path;
  }

  bool hitTestSelectedPath(Offset pos) {
    var point = _mapToCurrentView(pos);
    return pathHistory.hitTestSelectedPath(point);
  }

  void dragSelecting(Offset pos) {
    var point = _mapToCurrentView(pos);
    pathHistory.dragSelecting(point);
    _updatePaint();
  }

  void onPanUpdate(ui.Offset pos) {
    if (this.selectMode) {
      // User is moving the selecting path
      if (this.dragMode && this.dragStart != null) {
        if (this.dragStart == null) {
          this.dragStart = pos;
        }
        this.dragEnd = pos;
        // This will counted as dragging selecting path
        this.dragSelecting(pos);
      } else {
        this.updateSelectPoint(pos);
        this.calculateSelect();
      }
    } else {
      this.update(pos);
    }
  }

  void onPanEnd(DragEndDetails end) {
    if (this.selectMode) {
      this.calculateSelect();
      this.clearSelectPoint();
    } else {
      this.end();
    }
  }
}
