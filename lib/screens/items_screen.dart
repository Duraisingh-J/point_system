import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:point_system/provider/items_provider.dart';
import 'package:point_system/screens/add_item_screen.dart';
import 'package:point_system/screens/search_screen.dart';
import 'package:point_system/widgets/item_list.dart';
import 'package:point_system/widgets/overall_amount.dart';

class ItemsScreen extends ConsumerStatefulWidget {
  const ItemsScreen({super.key});

  @override
  ConsumerState<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends ConsumerState<ItemsScreen> {
  
  @override
  void initState() {
    super.initState();

      ref.read(itemsProvider.notifier);
    
  }

  void _addItem() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (ctx) => AddItemScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(itemsProvider);
    Widget content;
    if (items == null) {
      content = const Center(child: CircularProgressIndicator());
    } else if (items.isEmpty) {
      content = const Center(
        child: Text('No items found', style: TextStyle(fontSize: 20)),
      );
    } else {
      content = ItemList(items: items);
    }
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
              Expanded(child: content),
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
