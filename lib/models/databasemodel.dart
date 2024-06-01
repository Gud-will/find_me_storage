import 'package:isar/isar.dart';

part 'databasemodel.g.dart';

@Collection()
class ItemContainer {
  Id id = Isar.autoIncrement;

  late String name;
  String? description;

  final parentLink = IsarLink<ItemContainer>();

  @Backlink(to: 'parentLink')
  final subContainers = IsarLinks<ItemContainer>();

  @Backlink(to: 'containerLink')
  final items = IsarLinks<Item>();

  late String path;
}

@Collection()
class Item {
  Id id = Isar.autoIncrement;

  late String name;
  String? description;

  final containerLink = IsarLink<ItemContainer>();

  late String path;
}
