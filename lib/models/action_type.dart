// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

enum ActionTypeModel {
  @JsonValue('hand')
  Hand,
  @JsonValue('path')
  Path,
  @JsonValue('shape')
  Shape,
  @JsonValue('shape_round')
  ShapeRound,
  @JsonValue('shape_oval')
  ShapeOval,
  @JsonValue('shape_triangle')
  ShapeTriangle,
  @JsonValue('shape_square')
  ShapeSquare,
  @JsonValue('text')
  Text,
  @JsonValue('line')
  Line,
  @JsonValue('multiline')
  MultiLine,
  @JsonValue('erase')
  Erase
}
