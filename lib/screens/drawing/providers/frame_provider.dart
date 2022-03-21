import 'dart:ui';

import 'package:drawer_app/resources/draw_const.dart';
import 'package:drawer_app/utils/size_config.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

final frameProvider = StateNotifierProvider<FrameNotifier, BaseFrame>((ref) {
  return FrameNotifier();
});

class FrameNotifier extends StateNotifier<BaseFrame> {
  FrameNotifier() : super(VerticalFrame(0, 0));

  void setOrientation(DrawOrientation orientation) {
    final size = Size(SizeConfig.screenWidth, SizeConfig.screenHeight);
    state = orientation == DrawOrientation.vertical
        ? VerticalFrame.fromScreenHeight(size)
        : HorizontalFrame.fromScreenWidth(size);
  }
}
