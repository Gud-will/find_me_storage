import 'package:find_me_storage/models/databasemodel.dart';
import 'package:find_me_storage/providers/database_provider.dart';
import 'package:flutter/material.dart';


class ListItemsProvider extends ChangeNotifier {
  final ItemContainerRepository _itemContainerRepository;
  List<Item> rootItems=[];
  ListItemsProvider(this._itemContainerRepository);

  ItemContainerRepository get itemContainerRepository => _itemContainerRepository;

  void addItems(Item item){
    rootItems.add(item);
    notifyListeners();
  }
  void deleteItems(Item item){
    rootItems.remove(item);
    notifyListeners();
  }
  void getListItems(String currentpath)async{
    // print(currentpath);
    rootItems=await itemContainerRepository.getItemsThroughPath(currentpath);
    print(rootItems.length);
    notifyListeners();
  }
}

class ListContainerProvider extends ChangeNotifier {
  final ItemContainerRepository _itemContainerRepository;
  List<ItemContainer> rootContainers=[];
  ListContainerProvider(this._itemContainerRepository);
  ItemContainerRepository get itemContainerRepository => _itemContainerRepository;

  void addItemContainer(ItemContainer itemContainer){
    rootContainers.add(itemContainer);
    notifyListeners();
  }
  void deleteItemContainer(ItemContainer itemContainer){
    rootContainers.remove(itemContainer);
    notifyListeners();
  }
  void getListContainers(String currentpath)async{
    rootContainers=await itemContainerRepository.getContainersThroughPath(currentpath);
    // print(rootContainers);
    notifyListeners();
  }
}