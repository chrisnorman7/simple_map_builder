// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_map_tile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameMapTile _$GameMapTileFromJson(Map<String, dynamic> json) => GameMapTile(
  x: (json['x'] as num).toInt(),
  y: (json['y'] as num).toInt(),
  material: json['material'] as String,
  id: json['id'] as String?,
);

Map<String, dynamic> _$GameMapTileToJson(GameMapTile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'x': instance.x,
      'y': instance.y,
      'material': instance.material,
    };
