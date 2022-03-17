import 'package:drawer_app/models/history.dart';
import 'package:flutter/material.dart';

//Class to define a point touched at canvas
class CanvasPainter extends CustomPainter {
  final HistoryModel _path;

  CanvasPainter(this._path, {required Listenable repaint})
      : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    // print(size);
    _path.draw(canvas, size);
  }

  @override
  bool shouldRepaint(CanvasPainter oldDelegate) => true;
}
