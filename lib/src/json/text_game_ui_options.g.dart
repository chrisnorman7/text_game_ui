// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_game_ui_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextGameUiOptions _$TextGameUiOptionsFromJson(Map<String, dynamic> json) =>
    TextGameUiOptions(
      columns: (json['columns'] as num?)?.toInt() ?? 40,
      rows: (json['rows'] as num?)?.toInt() ?? 9,
    );

Map<String, dynamic> _$TextGameUiOptionsToJson(TextGameUiOptions instance) =>
    <String, dynamic>{
      'columns': instance.columns,
      'rows': instance.rows,
    };
