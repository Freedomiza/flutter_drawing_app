// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

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
  @override
  String toString() => 'BaseFrame(width: $width, height: $height)';
}

class HorizontalFrame extends BaseFrame {
  HorizontalFrame(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    this.width = width;
    height = width / 2;
  }
  HorizontalFrame.fromScreenWidth(double width) {
    this.width = width;
    height = width / 2;
    // print(this.toString());
  }
}

class VerticalFrame extends BaseFrame {
  VerticalFrame(BuildContext context) {
    var height = MediaQuery.of(context).size.height * 0.7;
    // var width = MediaQuery.of(context).size.width;

    width = height / 2;
    this.height = height;
  }

  VerticalFrame.fromScreenHeight(double height) {
    this.height = (height) * 0.7;
    width = ((height) * 0.7) / 2;
    // print(this.toString());
  }
}
