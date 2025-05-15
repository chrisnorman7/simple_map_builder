import 'package:json_annotation/json_annotation.dart';
import 'package:simple_map_builder/simple_map_builder.dart';

part 'game_map_tile.g.dart';

/// A tile in a game map.
@JsonSerializable()
class GameMapTile {
  /// Create an instance.
  GameMapTile({
    required this.x,
    required this.y,
    required this.material,
    final String? id,
  }) : id = id ?? newUuid();

  /// Create an instance from a JSON object.
  factory GameMapTile.fromJson(final Map<String, dynamic> json) =>
      _$GameMapTileFromJson(json);

  /// The ID of this tile.
  final String id;

  /// The x coordinate of this tile.
  final int x;

  /// The y coordinate of this tile.
  final int y;

  /// The name of the material of this tile.
  String material;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$GameMapTileToJson(this);
}
