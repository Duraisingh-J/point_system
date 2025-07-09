import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:point_system/datamodel/item.dart';
import 'package:point_system/screens/add_item_screen.dart';
import 'package:point_system/screens/search_screen.dart';
import 'package:point_system/widgets/item_list.dart';
import 'package:point_system/widgets/overall_amount.dart';
import 'package:http/http.dart' as http;

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  List<Item> items = [];
  late Future<List<Item>> itemsFuture;

  @override
  void initState() {
    super.initState();
    itemsFuture = _fetchItems();
  }

  Future<List<Item>> _fetchItems() async {
    final url = Uri.https(
      'pointsystem-accbd-default-rtdb.asia-southeast1.firebasedatabase.app',
      'items.json',
    );
    final response = await http.get(url);

    if (response.body == 'null') {
      return [];
    }

    final Map<String, dynamic> itemData = json.decode(response.body);

    final List<Item> loadedItems = [];
    for (final item in itemData.entries) {
      loadedItems.add(
        Item(
          title: item.value['title'],
          retailPrice: item.value['retailPrice'],
          quantity: Quantity.values.firstWhere(
            (quantity) => quantity.name == item.value['quantity'],
          ),
        ),
      );
    }
    return loadedItems;
  }

  void _addItem() async {
    final newItem = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (ctx) => AddItemScreen()));

    if (newItem == null) {
      return;
    }

    setState(() {
      items.add(newItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Point System',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              OverallAmount(),
              const SizedBox(height: 10),
              SearchScreen(),
              SizedBox(height: 10),
              Expanded(
                child: FutureBuilder(
                  future: itemsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No items found.'));
                    }
                    return ItemList(items: snapshot.data!);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        backgroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
