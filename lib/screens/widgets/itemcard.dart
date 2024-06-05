import 'package:flutter/material.dart';

import 'package:find_me_storage/models/databasemodel.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  const ItemCard({super.key,required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      title: Text(item.name),
      subtitle: Text(
        item.description!,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
