// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryModel _$HistoryModelFromJson(Map<String, dynamic> json) => HistoryModel(
      actionList: (json['actionList'] as List<dynamic>)
          .map((e) => DrawActionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      redoList: (json['redoList'] as List<dynamic>)
          .map((e) => DrawActionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      color: json['color'] as String? ?? 'fff',
      thickness: (json['thickness'] as num?)?.toDouble() ?? 1,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1,
      zIndex: json['zIndex'] as int? ?? 0,
    )..mode = $enumDecode(_$ActionTypeModelEnumMap, json['mode']);

Map<String, dynamic> _$HistoryModelToJson(HistoryModel instance) =>
    <String, dynamic>{
      'actionList': instance.actionList,
      'redoList': instance.redoList,
      'color': instance.color,
      'thickness': instance.thickness,
      'opacity': instance.opacity,
      'zIndex': instance.zIndex,
      'mode': _$ActionTypeModelEnumMap[instance.mode],
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
