import 'dart:math';

import 'package:backstreets_widgets/extensions.dart';
import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_map_builder/simple_map_builder.dart';

/// A screen for editing a map with the given [id].
class EditMapScreen extends ConsumerWidget {
  /// Create an instance.
  const EditMapScreen(this.id, {super.key});

  /// The ID of the map to edit.
  final String id;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final provider = gameMapProvider(id);
    final value = ref.watch(provider);
    return Cancel(
      child: value.when(
        data: (final map) {
          final materialTypes = map.materialTypes..sort();
          final mapWidth = map.width;
          final tiles = map.tiles;
          final actionsContext = PerformableActionsContext.fromActions([
            if (mapWidth > 1)
              PerformableAction(
                name: 'Reduce map width',
                invoke: () => _adjustMapWidth(ref, map, -1),
                activator: CrossPlatformSingleActivator(
                  LogicalKeyboardKey.comma,
                ),
              ),
            PerformableAction(
              name: 'Increase map width',
              invoke: () => _adjustMapWidth(ref, map, 1),
              activator: CrossPlatformSingleActivator(
                LogicalKeyboardKey.period,
              ),
            ),
          ]);
          return TabbedScaffold(
            tabs: [
              TabbedScaffoldTab(
                title: 'Tiles',
                icon: const Text('The tiles on this map'),
                actions: [
                  IconButton(
                    onPressed:
                        mapWidth <= 1
                            ? null
                            : () => _adjustMapWidth(ref, map, -1),
                    icon: const Icon(Icons.chevron_left),
                    tooltip: 'Reduce map width',
                  ),
                  Semantics(
                    customSemanticsActions:
                        actionsContext.customSemanticActions,
                    child: MenuAnchor(
                      menuChildren: actionsContext.menuChildren,
                      builder:
                          (final context, final controller, final child) =>
                              TextButton(
                                onPressed: controller.toggle,
                                child: Text('Width $mapWidth'),
                              ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _adjustMapWidth(ref, map, 1),
                    icon: const Icon(Icons.chevron_right),
                    tooltip: 'Increase map width',
                  ),
                ],
                child: CallbackShortcuts(
                  bindings: actionsContext.bindings,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: mapWidth,
                    ),
                    itemBuilder: (final context, final index) {
                      /// Convert `index` into `x` and `y` coordinates.
                      final x = index % mapWidth;
                      final y = index ~/ mapWidth;
                      var created = false;
                      final tile = tiles.firstWhere(
                        (final t) => t.x == x && t.y == y,
                        orElse: () {
                          created = true;
                          return GameMapTile(
                            material: materialTypes.first,
                            x: x,
                            y: y,
                          );
                        },
                      );
                      return Card(
                        elevation: 5.0,
                        margin: const EdgeInsets.all(8.0),
                        color: Colors.white,
                        child: PerformableActionsBuilder(
                          actions:
                              materialTypes
                                  .map(
                                    (final material) => PerformableAction(
                                      name: material,
                                      invoke: () async {
                                        tile.material = material;
                                        if (created) {
                                          tiles.add(tile);
                                        }
                                        await map.save(ref);
                                        ref.invalidate(provider);
                                      },
                                      checked: tile.material == material,
                                    ),
                                  )
                                  .toList(),
                          builder:
                              (final builderContext, final controller) =>
                                  GestureDetector(
                                    onTap: controller.toggle,
                                    child: FocusableActionDetector(
                                      autofocus: x == 0 && y == 0,
                                      actions: {
                                        ActivateIntent: CallbackAction(
                                          onInvoke: (_) => controller.toggle(),
                                        ),
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('$x, $y'),
                                          Text(tile.material),
                                        ],
                                      ),
                                    ),
                                  ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              TabbedScaffoldTab(
                title: 'Materials',
                icon: const Text(
                  'The materials which tiles can be made out of',
                ),
                child: CommonShortcuts(
                  newCallback: () => _newMaterial(ref, map),
                  child: ListView.builder(
                    itemBuilder: (final context, final index) {
                      final material = materialTypes[index];
                      return PerformableActionsListTile(
                        actions: [
                          PerformableAction(
                            name: 'Delete',
                            invoke: () {
                              if (materialTypes.length <= 1) {
                                context.showMessage(
                                  message:
                                      'You cannot delete the only material.',
                                );
                                return;
                              }
                              context.showConfirmMessage(
                                message: 'Really delete $material?',
                                noLabel: 'Cancel',
                                title: 'Confirm Delete',
                                yesCallback: () async {
                                  tiles.removeWhere(
                                    (final tile) => tile.material == material,
                                  );
                                  materialTypes.removeAt(index);
                                  await map.save(ref);
                                  ref.invalidate(provider);
                                },
                                yesLabel: 'Delete',
                              );
                            },
                            activator: deleteShortcut,
                          ),
                        ],
                        autofocus: index == 0,
                        title: Text(material),
                        onTap:
                            () => context.pushWidgetBuilder(
                              (final context) => GetText(
                                onDone: (final newName) async {
                                  context.pop();
                                  materialTypes[index] = newName;
                                  for (final tile in map.tiles) {
                                    if (tile.material == material) {
                                      tile.material = newName;
                                    }
                                  }
                                  await map.save(ref);
                                  ref.invalidate(provider);
                                },
                                labelText: 'Material name',
                                text: material,
                                title: 'Rename Material',
                              ),
                            ),
                      );
                    },
                    itemCount: materialTypes.length,
                  ),
                ),
                floatingActionButton: NewButton(
                  onPressed: () => _newMaterial(ref, map),
                  tooltip: 'New Material',
                ),
              ),
            ],
          );
        },
        error: ErrorListView.withPositional,
        loading: LoadingWidget.new,
      ),
    );
  }

  /// /// Create a new material.
  Future<void> _newMaterial(final WidgetRef ref, final GameMap map) async {
    map.materialTypes.add('untitled');
    await map.save(ref);
    ref.invalidate(gameMapProvider(id));
  }

  /// Adjust [map] width by [amount].
  Future<void> _adjustMapWidth(
    final WidgetRef ref,
    final GameMap map,
    final int amount,
  ) async {
    map.width = max(1, map.width + amount);
    ref.context.announce('Map width is now ${map.width}.');
    await map.save(ref);
    ref.invalidate(gameMapProvider(id));
  }
}
