import 'package:isar/isar.dart';

import '../models/databasemodel.dart';

class ItemContainerRepository {
  final Isar isar;

  ItemContainerRepository(this.isar);

  Future<void> addItemContainer(ItemContainer itemContainer) async {
    await isar.writeTxn(() async {
      await isar.itemContainers.put(itemContainer);
    });
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

  Future<void> addItemToContainer(int containerId, Item item) async {
    final container = await isar.itemContainers.get(containerId);
    if (container != null) {
      item.containerLink.value = container;
      await isar.writeTxn(() async {
        await isar.items.put(item);
      });
    }
  }

  Future<List<ItemContainer>> getSubContainers(int parentId) async {
    final parentContainer = await isar.itemContainers.get(parentId);
    if (parentContainer != null) {
      return await parentContainer.subContainers.toList();
    }
    return [];
  }

  Future<List<Item>> getItems(int containerId) async {
    final container = await isar.itemContainers.get(containerId);
    if (container != null) {
      return await container.items.toList();
    }
    return [];
  }

  Future<List<ItemContainer>> getRootContainers() async {
    // Query containers where parentLink is empty (i.e., root containers)
    return await isar.itemContainers.filter().parentLinkIsNull().findAll();
  }
}
