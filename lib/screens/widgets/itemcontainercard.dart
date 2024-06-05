import 'package:flutter/material.dart';

import 'package:find_me_storage/models/databasemodel.dart';

class ItemContainerCard extends StatelessWidget {
  final ItemContainer itemContainer;
  const ItemContainerCard({super.key,required this.itemContainer});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      title: Row(
        children: [
          Text(itemContainer.name),
          Text.rich(
            TextSpan(
              style: Theme.of(context).listTileTheme.subtitleTextStyle,
              children: [
                TextSpan(text: "C: ${itemContainer.subContainers.length.toString()}"),
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
