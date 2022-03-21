// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vector_math/vector_math_64.dart';

part 'generic.g.dart';

enum ShapeModel {
  @JsonValue('rectangle')
  Rectangle,
  @JsonValue('square')
  Square,
  @JsonValue('round')
  Round,
  @JsonValue('oval')
  Oval,
  @JsonValue('triangle')
  Triangle,
}

@JsonSerializable()
class TextStyleModel {
  String? color;
  double? fontSize;
  int? fontWeight;
  String? fontFamily;

  TextStyleModel({
    this.color,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
  });

  factory TextStyleModel.fromJson(Map<String, dynamic> json) =>
      _$TextStyleModelFromJson(json);
  Map<String, dynamic> toJson() => _$TextStyleModelToJson(this);
}

@JsonSerializable()
class BackgroundModel {
  String? color;
  String? image;
  BackgroundModel({
    this.color,
    this.image,
  });
  factory BackgroundModel.fromJson(Map<String, dynamic> json) =>
      _$BackgroundModelFromJson(json);
  Map<String, dynamic> toJson() => _$BackgroundModelToJson(this);
}

@JsonSerializable(ignoreUnannotated: true)
class PointModel {
  @JsonKey()
  double x;
  @JsonKey()
  double y;

  PointModel({this.x = 0, this.y = 0});

  Offset get offset => Offset(x, y);

  void move(Vector2 moveVector) {
    x = x + moveVector.x;
    y = y + moveVector.y;
  }

  factory PointModel.fromOffset(Offset offset) {
    return PointModel(x: offset.dx, y: offset.dy);
  }

  factory PointModel.fromJson(Map<String, dynamic> json) =>
      _$PointModelFromJson(json);
  Map<String, dynamic> toJson() => _$PointModelToJson(this);
}
