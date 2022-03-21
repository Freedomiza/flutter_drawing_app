// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextStyleModel _$TextStyleModelFromJson(Map<String, dynamic> json) =>
    TextStyleModel(
      color: json['color'] as String?,
      fontSize: (json['fontSize'] as num?)?.toDouble(),
      fontWeight: json['fontWeight'] as int?,
      fontFamily: json['fontFamily'] as String?,
    );

Map<String, dynamic> _$TextStyleModelToJson(TextStyleModel instance) =>
    <String, dynamic>{
      'color': instance.color,
      'fontSize': instance.fontSize,
      'fontWeight': instance.fontWeight,
      'fontFamily': instance.fontFamily,
    };

BackgroundModel _$BackgroundModelFromJson(Map<String, dynamic> json) =>
    BackgroundModel(
      color: json['color'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$BackgroundModelToJson(BackgroundModel instance) =>
    <String, dynamic>{
      'color': instance.color,
      'image': instance.image,
    };

PointModel _$PointModelFromJson(Map<String, dynamic> json) => PointModel(
      x: (json['x'] as num?)?.toDouble() ?? 0,
      y: (json['y'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$PointModelToJson(PointModel instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
    };
