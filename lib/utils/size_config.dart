import 'package:flutter/material.dart';

class Adapt {
  static Adapt? _instance;

  /// UI设计中手机尺寸 , px
  /// Size of the phone in UI Design , px
  static num uiWidthPx = 1080;
  static num uiHeightPx = 1920;

  //全局开关(默认打开)
  static bool isOpen = true;

  static late MediaQueryData _mediaQueryData;
  static late double _screenWidth;
  static late double _screenHeight;
  static late double _pixelRatio;
  static late double _statusBarHeight;
  static late double _bottomBarHeight;

  static void setStatus(bool status) {
    isOpen = status;
  }

  static void setWidth(num size) {
    uiWidthPx = size;
  }

  static void setHeight(num size) {
    uiHeightPx = size;
  }

  Adapt._();

  factory Adapt() {
    return _instance ??= Adapt._();
  }

  static void init(BuildContext context) {
    _instance ??= Adapt._();

    MediaQueryData mediaQuery = MediaQuery.of(context);
    _mediaQueryData = mediaQuery;
    _pixelRatio = mediaQuery.devicePixelRatio;
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;
    _statusBarHeight = mediaQuery.padding.top;
    _bottomBarHeight = _mediaQueryData.padding.bottom;
  }

  /// 设备的像素密度
  /// The size of the media in logical pixels (e.g, the size of the screen).
  static double get pixelRatio => _pixelRatio;

  /// 当前设备宽度 dp
  /// The horizontal extent of this size.
  static double get screenWidthDp => _screenWidth;

  ///当前设备高度 dp
  ///The vertical extent of this size. dp
  static double get screenHeightDp => _screenHeight;

  /// 当前设备宽度 px
  /// The vertical extent of this size. px
  static double get screenWidth => _screenWidth * _pixelRatio;

  /// 当前设备高度 px
  /// The vertical extent of this size. px
  static double get screenHeight => _screenHeight * _pixelRatio;

  /// 状态栏高度 dp 刘海屏会更高
  /// The offset from the top
  static double get statusBarHeight => _statusBarHeight;

  /// 底部安全区距离 dp
  /// The offset from the bottom.
  static double get bottomBarHeight => _bottomBarHeight;

  /// 实际的dp与UI设计px的比例
  /// The ratio of the actual dp to the design draft px
  static double get scaleWidth => _screenWidth / uiWidthPx;

  static double get scaleHeight => _screenHeight / uiHeightPx;

  double get scaleText => scaleWidth;

  //宽度适配
  static num set(num size) {
    if (isOpen) {
      return size * scaleWidth;
    }
    return size.toDouble();
  }

  static num setByHeight(num size) {
    if (isOpen) {
      return size * scaleHeight;
    }
    return size.toDouble();
  }

//  //高度适配
//  num set(num size) => size * scaleWidth;

}
