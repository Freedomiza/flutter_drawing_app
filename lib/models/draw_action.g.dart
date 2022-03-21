// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draw_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrawActionModel _$DrawActionModelFromJson(Map<String, dynamic> json) =>
    DrawActionModel(
      actionType:
          $enumDecodeNullable(_$ActionTypeModelEnumMap, json['actionType']) ??
              ActionTypeModel.Hand,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1,
      points: (json['points'] as List<dynamic>?)
              ?.map((e) => PointModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isSelected: json['isSelected'] as bool? ?? false,
      zIndex: json['zIndex'] as int? ?? 0,
    )..boundDistance = (json['boundDistance'] as num).toDouble();

Map<String, dynamic> _$DrawActionModelToJson(DrawActionModel instance) =>
    <String, dynamic>{
      'boundDistance': instance.boundDistance,
      'actionType': _$ActionTypeModelEnumMap[instance.actionType],
      'opacity': instance.opacity,
      'isSelected': instance.isSelected,
      'points': instance.points,
      'zIndex': instance.zIndex,
    };

const _$ActionTypeModelEnumMap = {
  ActionTypeModel.Hand: 'hand',
  ActionTypeModel.Path: 'path',
  ActionTypeModel.Shape: 'shape',
  ActionTypeModel.ShapeRound: 'shape_round',
  ActionTypeModel.ShapeOval: 'shape_oval',
  ActionTypeModel.ShapeTriangle: 'shape_triangle',
  ActionTypeModel.ShapeSquare: 'shape_square',
  ActionTypeModel.Text: 'text',
  ActionTypeModel.Line: 'line',
  ActionTypeModel.MultiLine: 'multiline',
  ActionTypeModel.Erase: 'erase',
};

TextActionModel _$TextActionModelFromJson(Map<String, dynamic> json) =>
    TextActionModel(
      text: json['text'] as String,
      style: TextStyleModel.fromJson(json['style'] as Map<String, dynamic>),
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1,
      actionType:
          $enumDecodeNullable(_$ActionTypeModelEnumMap, json['actionType']) ??
              ActionTypeModel.Text,
      isSelected: json['isSelected'] as bool? ?? false,
      points: (json['points'] as List<dynamic>?)
              ?.map((e) => PointModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      zIndex: json['zIndex'] as int? ?? 0,
    )..boundDistance = (json['boundDistance'] as num).toDouble();

Map<String, dynamic> _$TextActionModelToJson(TextActionModel instance) =>
    <String, dynamic>{
      'boundDistance': instance.boundDistance,
      'actionType': _$ActionTypeModelEnumMap[instance.actionType],
      'opacity': instance.opacity,
      'isSelected': instance.isSelected,
      'points': instance.points,
      'zIndex': instance.zIndex,
      'text': instance.text,
      'style': instance.style,
    };

LineActionModel _$LineActionModelFromJson(Map<String, dynamic> json) =>
    LineActionModel(
      actionType: $enumDecode(_$ActionTypeModelEnumMap, json['actionType']),
      opacity: (json['opacity'] as num).toDouble(),
      points: (json['points'] as List<dynamic>?)
              ?.map((e) => PointModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isSelected: json['isSelected'] as bool? ?? false,
      zIndex: json['zIndex'] as int? ?? 0,
    )..boundDistance = (json['boundDistance'] as num).toDouble();

Map<String, dynamic> _$LineActionModelToJson(LineActionModel instance) =>
    <String, dynamic>{
      'boundDistance': instance.boundDistance,
      'actionType': _$ActionTypeModelEnumMap[instance.actionType],
      'opacity': instance.opacity,
      'isSelected': instance.isSelected,
      'points': instance.points,
      'zIndex': instance.zIndex,
    };

PathActionModel _$PathActionModelFromJson(Map<String, dynamic> json) =>
    PathActionModel(
      actionType:
          $enumDecodeNullable(_$ActionTypeModelEnumMap, json['actionType']) ??
              ActionTypeModel.Path,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1,
      isSelected: json['isSelected'] as bool? ?? false,
      points: (json['points'] as List<dynamic>?)
              ?.map((e) => PointModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      zIndex: json['zIndex'] as int? ?? 0,
    )..boundDistance = (json['boundDistance'] as num).toDouble();

Map<String, dynamic> _$PathActionModelToJson(PathActionModel instance) =>
    <String, dynamic>{
      'boundDistance': instance.boundDistance,
      'actionType': _$ActionTypeModelEnumMap[instance.actionType],
      'opacity': instance.opacity,
      'isSelected': instance.isSelected,
      'points': instance.points,
      'zIndex': instance.zIndex,
    };

ShapeActionModel _$ShapeActionModelFromJson(Map<String, dynamic> json) =>
    ShapeActionModel(
      points: (json['points'] as List<dynamic>?)
              ?.map((e) => PointModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      shape: $enumDecode(_$ShapeModelEnumMap, json['shape']),
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1,
      background: json['background'] == null
          ? null
          : BackgroundModel.fromJson(
              json['background'] as Map<String, dynamic>),
      actionType:
          $enumDecodeNullable(_$ActionTypeModelEnumMap, json['actionType']) ??
              ActionTypeModel.Shape,
      isSelected: json['isSelected'] as bool? ?? false,
      zIndex: json['zIndex'] as int? ?? 0,
    )..boundDistance = (json['boundDistance'] as num).toDouble();

Map<String, dynamic> _$ShapeActionModelToJson(ShapeActionModel instance) =>
    <String, dynamic>{
      'boundDistance': instance.boundDistance,
      'actionType': _$ActionTypeModelEnumMap[instance.actionType],
      'opacity': instance.opacity,
      'isSelected': instance.isSelected,
      'points': instance.points,
      'zIndex': instance.zIndex,
      'shape': _$ShapeModelEnumMap[instance.shape],
      'background': instance.background,
    };

const _$ShapeModelEnumMap = {
  ShapeModel.Rectangle: 'rectangle',
  ShapeModel.Square: 'square',
  ShapeModel.Round: 'round',
  ShapeModel.Oval: 'oval',
  ShapeModel.Triangle: 'triangle',
};
