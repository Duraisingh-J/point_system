import 'package:flutter/material.dart';
import 'package:point_system/datamodel/item.dart';

class ItemList extends StatelessWidget {
  final List<Item> items;

  const ItemList({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) => Card(
        child: ListTile(
          title: Text(items[index].title),
          subtitle: Text(
            'Price: Rs. ${items[index].retailPrice}',
          
          ),
        ),
      ),
      itemCount: items.length,
    );
  }
}