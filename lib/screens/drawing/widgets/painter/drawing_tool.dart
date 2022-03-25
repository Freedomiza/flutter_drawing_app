import 'package:drawer_app/resources/draw_const.dart';
import 'package:drawer_app/resources/styles.dart';
import 'package:drawer_app/screens/drawing/providers/painter_provider.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'canvas_painter.dart';
import 'matrix_gesture_detector.dart';

class DrawingTool extends ConsumerStatefulWidget {
  final BaseFrame frame;

  const DrawingTool({Key? key, required this.frame}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DrawingToolState();
}

class _DrawingToolState extends ConsumerState<DrawingTool> {
  final GlobalKey _globalKey = GlobalKey();
  PainterController get painterController => ref.watch(painterProvider);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ref.read(painterProvider).initPainter(
            globalKey: _globalKey,
            frameWidth: widget.frame.width,
            frameHeight: widget.frame.height,
          );
    });
  }

  void _onPanStart(DragStartDetails start) {
    Offset pos = (context.findRenderObject() as RenderBox)
        .globalToLocal(start.globalPosition);
    final controller = ref.read(painterProvider);

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
    // Translate current point to new offset
    Offset pos = (context.findRenderObject() as RenderBox)
        .globalToLocal(update.globalPosition);

    painterController.onPanUpdate(pos);
  }

  _onPanEnd(DragEndDetails end) {
    painterController.onPanEnd(end);
  }

  _handleMatrixUpdate(m, tm, sm, rm) {
    if (painterController.zoomMode) {
      setState(() {
        painterController.setMatrix(m);
      });
      return true;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Update widget based on props

    final zoomMode = painterController.zoomMode;
    final matrix = painterController.matrix;

    if (!painterController.isReady) return Container();
    return SizedBox.expand(
      child: MatrixGestureDetector(
          onMatrixUpdate: _handleMatrixUpdate,
          trackMatrix: zoomMode,
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: Stack(
            children: [
              Container(
                  color: Styles.greyColor,
                  transform: matrix != Matrix4.zero() ? matrix : null,
                  child: RepaintBoundary(
                    key: _globalKey,
                    child: CustomPaint(
                      size: Size(widget.frame.width, widget.frame.height),
                      willChange: true,
                      painter: CanvasPainter(painterController.pathHistory,
                          repaint: painterController),
                    ),
                  )),
            ],
          )),
    );
  }
}
