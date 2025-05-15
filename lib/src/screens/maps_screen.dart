import 'dart:convert';

import 'package:backstreets_widgets/extensions.dart';
import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_map_builder/simple_map_builder.dart';
import 'package:simple_map_builder/src/screens/edit_map_screen.dart';

/// The screen that shows game maps.
class MapsScreen extends ConsumerWidget {
  /// Create an instance.
  const MapsScreen({super.key});

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final value = ref.watch(gameMapsProvider);
    return CommonShortcuts(
      newCallback: () => _newMap(ref),
      child: SimpleScaffold(
        title: 'Maps',
        body: value.when(
          data: (final maps) {
            if (maps.isEmpty) {
              return const CenterText(
                text: 'No maps have been created yet.',
                autofocus: true,
              );
            }
            return ListView.builder(
              itemBuilder: (final context, final index) {
                final map = maps[index];
                return PerformableActionsListTile(
                  actions: [
                    PerformableAction(
                      name: 'Rename',
                      invoke:
                          () => context.pushWidgetBuilder(
                            (final context) => GetText(
                              onDone: (final value) async {
                                context.pop();
                                map.name = value;
                                await map.save(ref);
                                ref.invalidate(gameMapsProvider);
                              },
                              labelText: 'Map name',
                              text: map.name,
                              title: 'Rename Map',
                            ),
                          ),
                      activator: CrossPlatformSingleActivator(
                        LogicalKeyboardKey.keyR,
                      ),
                    ),
                    PerformableAction(
                      name: 'Copy as JSON',
                      invoke: () {
                        const JsonEncoder.withIndent(
                          '  ',
                        ).convert(map).copyToClipboard();
                        context.announce('JSON copied.');
                      },
                      activator: CrossPlatformSingleActivator(
                        LogicalKeyboardKey.keyJ,
                        shift: true,
                      ),
                    ),
                    PerformableAction(
                      name: 'Copy as CSV',
                      invoke: () {
                        final buffer =
                            StringBuffer()..writeln(
                              ['id', 'x', 'y', 'material'].join('\t'),
                            );
                        map.tiles.sort((final a, final b) {
                          final xResult = a.x.compareTo(b.x);
                          if (xResult == 0) {
                            final yResult = a.y.compareTo(b.y);
                            if (yResult == 0) {
                              return a.material.toLowerCase().compareTo(
                                b.material.toLowerCase(),
                              );
                            }
                            return yResult;
                          }
                          return xResult;
                        });
                        for (final tile in map.tiles) {
                          buffer.writeln(
                            [tile.id, tile.x, tile.y, tile.material].join('\t'),
                          );
                        }
                        buffer.toString().copyToClipboard();
                        context.announce('Copied CSV.');
                      },
                      activator: CrossPlatformSingleActivator(
                        LogicalKeyboardKey.keyC,
                        shift: true,
                      ),
                    ),
                    PerformableAction(
                      name: 'Delete',
                      invoke:
                          () => context.showConfirmMessage(
                            title: 'Delete Map',
                            message:
                                'Are you sure you want to delete this map?',
                            yesCallback: () async {
                              maps.removeWhere((final e) => e.id == map.id);
                              final prefs = SharedPreferencesAsync();
                              if (maps.isEmpty) {
                                await prefs.remove(mapsKey);
                              } else {
                                final strings =
                                    maps
                                        .map(
                                          (final map) =>
                                              jsonEncode(map.toJson()),
                                        )
                                        .toList();
                                await prefs.setStringList(mapsKey, strings);
                              }
                              ref.invalidate(gameMapsProvider);
                            },
                            noLabel: 'Cancel',
                            yesLabel: 'Delete',
                          ),
                      activator: deleteShortcut,
                    ),
                  ],
                  autofocus: index == 0,
                  title: Text(map.name),
                  onTap:
                      () => context.pushWidgetBuilder(
                        (final context) => EditMapScreen(map.id),
                      ),
                );
              },
              itemCount: maps.length,
            );
          },
          error: ErrorListView.withPositional,
          loading: LoadingWidget.new,
        ),
        floatingActionButton: NewButton(
          onPressed: () => _newMap(ref),
          tooltip: 'New map',
        ),
      ),
    );
  }

  /// Create a new map.
  Future<void> _newMap(final WidgetRef ref) async {
    final map = GameMap(
      id: newUuid(),
      name: 'New Map',
      materialTypes: ['grass', 'stone', 'gravel', 'water', 'snow'],
      tiles: [],
    );
    await map.save(ref);
    ref.invalidate(gameMapsProvider);
  }
}
