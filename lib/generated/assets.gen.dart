/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// ignore_for_file: directives_ordering,unnecessary_import

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class $AssetsFontsGen {
  const $AssetsFontsGen();

  /// File path: assets/fonts/OFL.txt
  String get ofl => 'assets/fonts/OFL.txt';

  /// File path: assets/fonts/Poppins-Black.ttf
  String get poppinsBlack => 'assets/fonts/Poppins-Black.ttf';

  /// File path: assets/fonts/Poppins-BlackItalic.ttf
  String get poppinsBlackItalic => 'assets/fonts/Poppins-BlackItalic.ttf';

  /// File path: assets/fonts/Poppins-Bold.ttf
  String get poppinsBold => 'assets/fonts/Poppins-Bold.ttf';

  /// File path: assets/fonts/Poppins-BoldItalic.ttf
  String get poppinsBoldItalic => 'assets/fonts/Poppins-BoldItalic.ttf';

  /// File path: assets/fonts/Poppins-ExtraBold.ttf
  String get poppinsExtraBold => 'assets/fonts/Poppins-ExtraBold.ttf';

  /// File path: assets/fonts/Poppins-ExtraBoldItalic.ttf
  String get poppinsExtraBoldItalic =>
      'assets/fonts/Poppins-ExtraBoldItalic.ttf';

  /// File path: assets/fonts/Poppins-ExtraLight.ttf
  String get poppinsExtraLight => 'assets/fonts/Poppins-ExtraLight.ttf';

  /// File path: assets/fonts/Poppins-ExtraLightItalic.ttf
  String get poppinsExtraLightItalic =>
      'assets/fonts/Poppins-ExtraLightItalic.ttf';

  /// File path: assets/fonts/Poppins-Italic.ttf
  String get poppinsItalic => 'assets/fonts/Poppins-Italic.ttf';

  /// File path: assets/fonts/Poppins-Light.ttf
  String get poppinsLight => 'assets/fonts/Poppins-Light.ttf';

  /// File path: assets/fonts/Poppins-LightItalic.ttf
  String get poppinsLightItalic => 'assets/fonts/Poppins-LightItalic.ttf';

  /// File path: assets/fonts/Poppins-Medium.ttf
  String get poppinsMedium => 'assets/fonts/Poppins-Medium.ttf';

  /// File path: assets/fonts/Poppins-MediumItalic.ttf
  String get poppinsMediumItalic => 'assets/fonts/Poppins-MediumItalic.ttf';

  /// File path: assets/fonts/Poppins-Regular.ttf
  String get poppinsRegular => 'assets/fonts/Poppins-Regular.ttf';

  /// File path: assets/fonts/Poppins-SemiBold.ttf
  String get poppinsSemiBold => 'assets/fonts/Poppins-SemiBold.ttf';

  /// File path: assets/fonts/Poppins-SemiBoldItalic.ttf
  String get poppinsSemiBoldItalic => 'assets/fonts/Poppins-SemiBoldItalic.ttf';

  /// File path: assets/fonts/Poppins-Thin.ttf
  String get poppinsThin => 'assets/fonts/Poppins-Thin.ttf';

  /// File path: assets/fonts/Poppins-ThinItalic.ttf
  String get poppinsThinItalic => 'assets/fonts/Poppins-ThinItalic.ttf';
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/app_logo.svg
  SvgGenImage get appLogo => const SvgGenImage('assets/images/app_logo.svg');

  /// File path: assets/images/cubicbeziercurve_shape.svg
  SvgGenImage get cubicbeziercurveShape =>
      const SvgGenImage('assets/images/cubicbeziercurve_shape.svg');

  /// File path: assets/images/line_shape.svg
  SvgGenImage get lineShape =>
      const SvgGenImage('assets/images/line_shape.svg');

  $AssetsImagesLottiesGen get lotties => const $AssetsImagesLottiesGen();

  /// File path: assets/images/oval_shape.svg
  SvgGenImage get ovalShape =>
      const SvgGenImage('assets/images/oval_shape.svg');

  /// File path: assets/images/phone_horizontal.svg
  SvgGenImage get phoneHorizontal =>
      const SvgGenImage('assets/images/phone_horizontal.svg');

  /// File path: assets/images/phone_vertival.svg
  SvgGenImage get phoneVertival =>
      const SvgGenImage('assets/images/phone_vertival.svg');

  /// File path: assets/images/rectangle_shape.svg
  SvgGenImage get rectangleShape =>
      const SvgGenImage('assets/images/rectangle_shape.svg');

  /// File path: assets/images/redo.svg
  SvgGenImage get redo => const SvgGenImage('assets/images/redo.svg');

  /// File path: assets/images/rounded_shape.svg
  SvgGenImage get roundedShape =>
      const SvgGenImage('assets/images/rounded_shape.svg');

  /// File path: assets/images/story.png
  AssetGenImage get story => const AssetGenImage('assets/images/story.png');

  /// File path: assets/images/story_avatar.jpg
  AssetGenImage get storyAvatar =>
      const AssetGenImage('assets/images/story_avatar.jpg');

  /// File path: assets/images/triangle_shape.svg
  SvgGenImage get triangleShape =>
      const SvgGenImage('assets/images/triangle_shape.svg');

  /// File path: assets/images/undo.svg
  SvgGenImage get undo => const SvgGenImage('assets/images/undo.svg');
}

class $AssetsImagesLottiesGen {
  const $AssetsImagesLottiesGen();

  /// File path: assets/images/lotties/landscape-to-portrait-view.json
  String get landscapeToPortraitView =>
      'assets/images/lotties/landscape-to-portrait-view.json';

  /// File path: assets/images/lotties/login-screen.json
  String get loginScreen => 'assets/images/lotties/login-screen.json';
}

class Assets {
  Assets._();

  static const String env = 'assets/.env';
  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage extends AssetImage {
  const AssetGenImage(String assetName) : super(assetName);

  Image image({
    Key? key,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return Image(
      key: key,
      image: this,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
    );
  }

  String get path => assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName);

  final String _assetName;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    Color? color,
    BlendMode colorBlendMode = BlendMode.srcIn,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return SvgPicture.asset(
      _assetName,
      key: key,
      matchTextDirection: matchTextDirection,
      bundle: bundle,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      color: color,
      colorBlendMode: colorBlendMode,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      clipBehavior: clipBehavior,
    );
  }

  String get path => _assetName;
}
