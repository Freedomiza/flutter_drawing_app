// ignore_for_file: constant_identifier_names

// import 'package:flutter/material.dart';

import 'dart:ui';

const double MAX_FRAMES = 4;

enum DrawOrientation {
  horizontal,
  vertical,
}

extension ParseToString on DrawOrientation {
  String toShortString() {
    return toString().split('.').last;
  }
}

class DrawConst {}

abstract class BaseFrame {
  late double width;
  late double height;
  BaseFrame({
    this.width = 0,
    this.height = 0,
  });

  bool get isZero => width == 0 || height == 0;
  @override
  String toString() => 'BaseFrame(width: $width, height: $height)';

  void initFrame(Size size) {
    width = size.width;
    height = size.height;
  }
}

class HorizontalFrame extends BaseFrame {
  HorizontalFrame(double width, double height)
      : super(width: width, height: height);

  factory HorizontalFrame.fromScreenWidth(Size size) {
    var width = size.width;
    return HorizontalFrame(width, width / 2);
  }
}

class VerticalFrame extends BaseFrame {
  VerticalFrame(double width, double height)
      : super(width: width, height: height);

  factory VerticalFrame.fromScreenHeight(Size size) {
    final baseHeight = size.height * .7;
    return VerticalFrame(baseHeight / 2, baseHeight);
  }
}
