import 'package:drawer_app/resources/draw_const.dart';
import 'package:flutter/material.dart';
import 'canvas_painter.dart';
import 'matrix_gesture_detector.dart';

class DrawingTool extends StatefulWidget {
  final PainterController painterController;
  final BaseFrame frame;

  DrawingTool(PainterController painterController, this.frame)
      : this.painterController = painterController,
        super(key: ValueKey<PainterController>(painterController));
  @override
  _DrawingToolState createState() => _DrawingToolState();
}

class _DrawingToolState extends State<DrawingTool> {
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    widget.painterController.globalKey = _globalKey;
    // if (widget.history != null) {
    //   widget.painterController.pathHistory = widget.history;
    // }
  }

  void _onPanStart(DragStartDetails start) {
    Offset pos = (context.findRenderObject() as RenderBox)
        .globalToLocal(start.globalPosition);
    final controller = widget.painterController;
    if (controller.selectMode) {
      if (controller.selectingCount > 0 &&
          controller.hitTestSelectedPath(pos)) {
        controller.dragMode = true;
        controller.dragStart = pos;
      }
      controller.addSelectPoint(pos);
      controller.calculateSelect();
    } else {
      controller.add(pos);
    }
  }

  void _onPanUpdate(DragUpdateDetails update) {
    final controller = widget.painterController;

    // Translate current point to new offset
    Offset pos = (context.findRenderObject() as RenderBox)
        .globalToLocal(update.globalPosition);

    controller.onPanUpdate(pos);
  }

  _onPanEnd(DragEndDetails end) {
    final controller = widget.painterController;
    controller.onPanEnd(end);
  }

  _handleMatrixUpdate(m, tm, sm, rm) {
    final controller = widget.painterController;
    if (controller.zoomMode) {
      setState(() {
        controller.setMatrix(m);
      });
      return true;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Update widget based on props
    final zoomMode = PropertyChangeProvider.of<PainterController>(context,
        properties: ['zoomMode']).value.zoomMode;
    final matrix = PropertyChangeProvider.of<PainterController>(context,
        properties: ['matrix']).value.getMatrix();

    return SizedBox.expand(
      child: MatrixGestureDetector(
          onMatrixUpdate: _handleMatrixUpdate,
          trackMatrix: zoomMode,
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: Stack(children: [
            Container(
              width: widget.frame.width,
              height: widget.frame.height,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1)),
              transform:
                  matrix != null && matrix != Matrix4.zero() ? matrix : null,
              child: RepaintBoundary(
                key: _globalKey,
                child: CustomPaint(
                  size: Size(widget.frame.width, widget.frame.height),
                  willChange: true,
                  painter: CanvasPainter(widget.painterController.pathHistory,
                      repaint: widget.painterController),
                ),
              ),
            ),
          ])),
    );
  }
}
