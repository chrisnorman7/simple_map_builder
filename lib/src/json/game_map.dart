import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_map_builder/simple_map_builder.dart';

part 'game_map.g.dart';

/// A game map.
@JsonSerializable()
class GameMap {
  /// Create an instance.
  GameMap({
    required this.id,
    required this.name,
    required this.materialTypes,
    required this.tiles,
    this.width = 10,
  });

  /// Create an instance from a JSON object.
  factory GameMap.fromJson(final Map<String, dynamic> json) =>
      _$GameMapFromJson(json);

  /// The ID of this map.
  final String id;

  /// The name of this map.
  String name;

  /// The names of the possible tile materials.
  final List<String> materialTypes;

  /// The tiles on this map.
  final List<GameMapTile> tiles;

  /// The width of the grid which will show this map.
  ///
  /// This is sued to calculate the number of columns.
  int width;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$GameMapToJson(this);

  /// Save this map.
  Future<void> save(final WidgetRef ref) async {
    final maps = await ref.read(gameMapsProvider.future);
    final index = maps.indexWhere((final map) => map.id == id);
    if (index == -1) {
      maps.add(this);
    }
    final prefs = SharedPreferencesAsync();
    final strings = maps.map((final map) => jsonEncode(map.toJson())).toList();
    await prefs.setStringList(mapsKey, strings);
  }
}
