// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_map.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameMap _$GameMapFromJson(Map<String, dynamic> json) => GameMap(
  id: json['id'] as String,
  name: json['name'] as String,
  materialTypes:
      (json['materialTypes'] as List<dynamic>).map((e) => e as String).toList(),
  tiles:
      (json['tiles'] as List<dynamic>)
          .map((e) => GameMapTile.fromJson(e as Map<String, dynamic>))
          .toList(),
  width: (json['width'] as num?)?.toInt() ?? 10,
);

Map<String, dynamic> _$GameMapToJson(GameMap instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'materialTypes': instance.materialTypes,
  'tiles': instance.tiles,
  'width': instance.width,
};
