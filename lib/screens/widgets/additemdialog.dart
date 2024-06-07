import 'dart:ffi';

import 'package:find_me_storage/providers/listitemsprovider.dart';
import 'package:find_me_storage/screens/widgets/animatedtextswitcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/databasemodel.dart';
import '../../providers/database_provider.dart';
import '../../utils/const.dart';

class SlidingDialogBox extends StatefulWidget {
  final ItemContainerRepository itemContainerRepository;
  final String path;
  ItemContainer? parentitemcontainer;
  SlidingDialogBox({
    super.key,
    required this.itemContainerRepository,
    required this.path,
    required this.parentitemcontainer,
  });

  @override
  State<SlidingDialogBox> createState() => _SlidingDialogBoxState();
}

class _SlidingDialogBoxState extends State<SlidingDialogBox> {
  final TextEditingController _itemname = TextEditingController();
  final TextEditingController _itemdescp = TextEditingController();
  bool _isitem = true;

  void toggleisitem() {
    setState(() {
      _isitem = !_isitem;
    });
  }

  @override
  Widget build(BuildContext context) {
    ListItemsProvider listItemsProvider =
        Provider.of<ListItemsProvider>(context);
    ListContainerProvider listContainerProvider =
        Provider.of<ListContainerProvider>(context);
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white60,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        child: Padding(
          padding: appPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              const Text("Add Items"),
              TextField(
                controller: _itemname,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  helperText: "Item/Container Name",
                  focusedBorder: InputBorder.none,
                  enabledBorder: UnderlineInputBorder(),
                ),
              ),
              TextField(
                controller: _itemdescp,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  helperText: "Item/Container description",
                  focusedBorder: InputBorder.none,
                  enabledBorder: UnderlineInputBorder(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Select Type:"),
                  Animatedtextswitcher(
                      text1: "Item",
                      text2: "Container",
                      toggleisitem: toggleisitem,
                      isitem: _isitem),
                ],
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_isitem) {
                      final item = Item()
                        ..name = _itemname.text
                        ..description = _itemdescp.text
                        ..path = widget.path
                        ..parentLink.value=widget.parentitemcontainer;
                      await widget.itemContainerRepository.addItemToContainer(
                          widget.parentitemcontainer?.id ?? -1, item);
                      listItemsProvider.addItems(item);
                    } else {
                      final item = ItemContainer()
                        ..name = _itemname.text
                        ..description = _itemdescp.text
                        ..path = widget.path
                        ..parentLink.value=widget.parentitemcontainer;
                      await widget.itemContainerRepository
                          .addItemContainer(item);
                      listContainerProvider.addItemContainer(item);
                    }
                    Navigator.pop(context, true);
                  },
                  child: const Text("Done"))
            ],
          ),
        ),
      ),
    );
  }
}
