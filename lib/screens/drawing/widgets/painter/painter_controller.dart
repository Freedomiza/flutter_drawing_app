import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:drawer_app/models/action_type.dart';
import 'package:drawer_app/models/history.dart';
import 'package:drawer_app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as mat show Image;
import 'package:flutter/rendering.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class PainterController extends ChangeNotifier {
  Color _drawColor = const Color.fromARGB(255, 0, 0, 0);
  Color _backgroundColor = const Color.fromARGB(255, 255, 255, 255);
  mat.Image? _bgimage;
  double _thickness = 3.0;
  double _erasethickness = 3.0;
  double _opacity = 1;

  HistoryModel pathHistory = HistoryModel(
    actionList: [],
    redoList: [],
    color: 'FFF',
    opacity: 1,
    paint: INITIAL_PAINT,
    selectedPaint: SELECTED_PAINT,
  );

  ActionTypeModel get mode => pathHistory.mode;
  void changeMode(ActionTypeModel value) {
    pathHistory.mode = value;
    _updatePaint();
  }

  Matrix4 _matrix = Matrix4.zero();

  Matrix4 get matrix => _matrix;
  void setMatrix(Matrix4 val) {
    _matrix = val;
    _updatePaint();
  }

  bool _zoomMode = false;
  bool get zoomMode => _zoomMode;
  void setZoomMode(bool value) {
    _zoomMode = value;
    notifyListeners();
    _updatePaint();
  }

  bool _selectMode = false;
  bool get selectMode => _selectMode;
  set selectMode(bool value) {
    _selectMode = value;

    pathHistory.selectMode = value;
    notifyListeners();
    _updatePaint();
  }

  GlobalKey? globalKey;

  void initPainter(
      {required GlobalKey globalKey,
      required double frameWidth,
      required double frameHeight,
      Image? bgImage}) {
    this.globalKey = globalKey;
    setMatrix(_getCenterTranformMatrix(frameWidth, frameHeight));
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

  mat.Image? get backgroundImage => _bgimage;
  set backgroundImage(mat.Image? image) {
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
    pathHistory.eraseArea = t;
    _updatePaint();
  }

  bool get eraser => pathHistory.eraseMode; //setter / getter for eraser
  set eraser(bool e) {
    pathHistory.eraseMode = e;
    pathHistory.eraseArea = _erasethickness;
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

  Offset? get dragStart => pathHistory.dragStart;
  set dragStart(Offset? value) {
    pathHistory.dragStart = _mapToCurrentView(value);
  }

  Offset? get dragEnd => pathHistory.dragEnd;
  set dragEnd(Offset? value) {
    pathHistory.dragEnd = _mapToCurrentView(value);
  }

  /// Check can undo / redo flag
  bool get canUndo => pathHistory.canUndo;
  bool get canRedo => pathHistory.canRedo;

  void _updatePaint() {
    Paint paint = Paint();
    paint.isAntiAlias = true;
    paint.color = drawColor.withOpacity(opacity);
    paint.style = PaintingStyle.stroke;

    paint.strokeWidth = thickness;
    pathHistory.opacity = _opacity;
    pathHistory.paint = paint;
    pathHistory.gridVisible = _gridMode;
    pathHistory.matrix = _matrix;
    if (_bgimage != null) {
      pathHistory.backgroundColor = const Color(0x00000000);
    } else {
      pathHistory.backgroundColor = _backgroundColor;
    }
    notifyListeners();
  }

  void undo() {
    pathHistory.undo();
    notifyListeners();
  }

  void redo() {
    pathHistory.redo();
    notifyListeners();
  }

  void toggleGrid(bool gridVisible) {
    pathHistory.gridVisible = gridVisible;
    notifyListeners();
  }

  void clear() {
    pathHistory.clear();
    notifyListeners();
  }

  void addText(String text) {
    pathHistory.addText(text);
  }

  Future<Uint8List> exportAsPNGBytes() async {
    var result = Uint8List(0);
    final boundary =
        globalKey?.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return result;

    ui.Image image = await boundary.toImage();
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    result = byteData?.buffer.asUint8List() ?? Uint8List(0);

    return result;
  }

  void add(Offset pos) {
    pathHistory.add(
      _mapToCurrentView(pos),
    );
    notifyListeners();
  }

  void update(Offset pos) {
    pathHistory.updateCurrent(_mapToCurrentView(pos));
    notifyListeners();
  }

  void end() {
    pathHistory.endCurrent();
    notifyListeners();
  }

  void addSelectPoint(Offset pos) {
    pathHistory.selectEnd = null;
    pathHistory.selectStart = _mapToCurrentView(pos);
    notifyListeners();
  }

  void updateSelectPoint(Offset pos) {
    pathHistory.selectEnd = _mapToCurrentView(pos);
    notifyListeners();
  }

  void calculateSelect() {
    pathHistory.calculateSelect();
    _updatePaint();
    notifyListeners();
  }

  void clearSelectPoint() {
    pathHistory.selectEnd = null;
    pathHistory.selectStart = null;
    pathHistory.dragStart = null;
    pathHistory.dragEnd = null;
  }

  Offset _mapToCurrentView(Offset? pos) {
    if (pos == null) return Offset.zero;
    Vector3 newPos = Vector3(pos.dx, pos.dy, 0);

    if (_matrix != Matrix4.zero()) {
      var m = Matrix4.zero();
      m.copyInverse(_matrix);
      newPos.applyMatrix4(m);
    }
    return Offset(newPos.x, newPos.y);
  }

  void resetMode() {
    eraser = false;
    selectMode = false;
    changeMode(ActionTypeModel.Path);
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
    if (selectMode) {
      // User is moving the selecting path
      if (dragMode) {
        dragStart ??= pos;
        dragEnd = pos;
        // This will counted as dragging selecting path
        dragSelecting(pos);
      } else {
        updateSelectPoint(pos);
        calculateSelect();
      }
    } else {
      update(pos);
    }
  }

  void onPanEnd(DragEndDetails end) {
    if (selectMode) {
      calculateSelect();
      clearSelectPoint();
    } else {
      this.end();
    }
  }

  static _getCenterTranformMatrix(double width, double height) {
    return Transform.translate(
            offset: Offset((SizeConfig.screenWidth - width) / 2,
                (SizeConfig.screenHeight - height) / 2))
        .transform;
  }
}
