import 'package:flutter/material.dart';
import 'package:point_system/datamodel/item.dart';
import 'package:point_system/widgets/item_details.dart';

class ItemList extends StatelessWidget {
  final List<Item> items;

  const ItemList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) =>  ItemDetails(item: items[index]),
      itemCount: items.length,
    );
  }
}
