import 'package:uuid/uuid.dart';

export 'src/json/game_map.dart';
export 'src/json/game_map_tile.dart';
export 'src/providers.dart';

/// The UUID generator to use.
const uuid = Uuid();

/// Get a new UUID.
String newUuid() => uuid.v4();

/// The key where maps are stored.
const mapsKey = 'simple_map_builder_maps';
