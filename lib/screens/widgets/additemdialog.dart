import 'package:flutter/material.dart';

import '../../models/databasemodel.dart';
import '../../providers/database_provider.dart';
import '../../utils/const.dart';

class SlidingDialogBox extends StatefulWidget {
  final ItemContainerRepository itemContainerRepository;
  final String path;
  final ItemContainer parentitemcontainer;
  const SlidingDialogBox({super.key,required this.itemContainerRepository,required this.path,required this.parentitemcontainer,});

  @override
  State<SlidingDialogBox> createState() => _SlidingDialogBoxState();
}

class _SlidingDialogBoxState extends State<SlidingDialogBox> {
  final TextEditingController _itemname = TextEditingController();

  final TextEditingController _itemdescp = TextEditingController();

  bool _isitem = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.grey,
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
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: TextButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: (){
                      setState(() {
                        _isitem=!_isitem;
                      });
                    },
                    child: Text(key:ValueKey<bool>(_isitem),_isitem?"Item":"Conatiner"),
                  ),
                )
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  if(_isitem){
                    final item=Item()
                    ..parentLink.value=widget.parentitemcontainer
                    ..name=_itemname.text
                    ..description=_itemdescp.text
                    ..path="${widget.path}/${_itemname.text}";
                    await widget.itemContainerRepository.addItemToContainer(widget.parentitemcontainer.id,item);
                  }
                  else{
                    final item= ItemContainer()
                    ..name=_itemname.text
                    ..description=_itemdescp.text
                    ..path="${widget.path}/${_itemname.text}";
                    if(widget.parentitemcontainer.id>0){
                      item.parentLink.value=widget.parentitemcontainer;
                    }
                    await widget.itemContainerRepository.addItemContainer(item);
                  }
                  Navigator.pop(context,true);
                },
                child: Text("Done"))
          ],
        ),
      ),
    );
  }
}
