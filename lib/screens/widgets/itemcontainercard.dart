import 'package:flutter/material.dart';

import 'package:find_me_storage/models/databasemodel.dart';

class ItemContainerCard extends StatelessWidget {
  final ItemContainer itemContainer;
  final Function(String, ItemContainer?) ontap;
  const ItemContainerCard(
      {super.key, required this.itemContainer, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => ontap(itemContainer.path, itemContainer),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(itemContainer.name),
          Text.rich(
            TextSpan(
              style: Theme.of(context).listTileTheme.subtitleTextStyle,
              children: [
                TextSpan(
                    text:
                        "C: ${itemContainer.subContainers.length.toString()}"),
                TextSpan(text: "I:  ${itemContainer.items.length.toString()}")
              ],
            ),
          ),
        ],
      ),
      subtitle: Text(
        itemContainer.description!,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
