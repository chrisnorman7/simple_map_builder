import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_map_builder/simple_map_builder.dart';

part 'providers.g.dart';

/// Provide all the created maps.
@riverpod
Future<List<GameMap>> gameMaps(final Ref ref) async {
  final prefs = SharedPreferencesAsync();
  final strings = await prefs.getStringList(mapsKey);
  if (strings == null) {
    return <GameMap>[];
  }
  return strings.map((final string) {
    final json = jsonDecode(string);
    return GameMap.fromJson(json as Map<String, dynamic>);
  }).toList();
}

/// Provide a single map.
@riverpod
Future<GameMap> gameMap(final Ref ref, final String id) async {
  final maps = await ref.watch(gameMapsProvider.future);
  return maps.firstWhere((final map) => map.id == id);
}
