import 'package:isar/isar.dart';

import '../models/databasemodel.dart';

class ItemContainerRepository {
  final Isar isar;

  ItemContainerRepository(this.isar);

  Future<void> addItemContainer(ItemContainer itemContainer,
      {bool hasparent = false, int parentid = 0}) async {
        late final container;
    await isar.writeTxn(
      () async {
        if (hasparent) {
          container = await isar.itemContainers.get(itemContainer.parentLink.value!.id);
          if (container != null) {
            container.subContainers.add(itemContainer);
          }
        }
        await isar.itemContainers.put(itemContainer);
        if(hasparent){
          await container.subContainers.save();
        }
      },
    );
  }

  Future<ItemContainer?> getItemContainer(int id) async {
    return await isar.itemContainers.get(id);
  }

  Future<void> updateItemContainer(ItemContainer itemContainer) async {
    await isar.writeTxn(() async {
      await isar.itemContainers.put(itemContainer);
    });
  }

  Future<void> deleteItemContainer(int id) async {
    await isar.writeTxn(() async {
      await isar.itemContainers.delete(id);
    });
  }

// int containerId,
  Future<void> addItemToContainer(int containerId, Item item) async {
    await isar.writeTxn(() async {
      final container = await isar.itemContainers.get(containerId);
      if (container != null) {
        container.items.add(item);
        item.parentLink.value = container;
        await isar.items.put(item);
        await container.items.save();
      }
    });
  }

  Future<List<ItemContainer>> getSubContainers(int parentId) async {
    final parentContainer = await isar.itemContainers.get(parentId);
    if (parentContainer != null) {
      return parentContainer.subContainers.toList();
    }
    return [];
  }

  Future<List<Item>> getItems(int containerId) async {
    final container = await isar.itemContainers.get(containerId);
    if (container != null) {
      return container.items.toList();
    }
    return [];
  }

  Future<List<ItemContainer>> getRootContainers() async {
    // Query containers where parentLink is empty (i.e., root containers)
    return await isar.itemContainers.filter().parentLinkIsNull().findAll();
  }
}
