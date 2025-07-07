import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:point_system/datamodel/item.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  List<Item> _items = [];

  final _categoryController = TextEditingController();

  File? _selectedImage;
  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

 

  void _addCategory() {
    showDialog(context: context, builder: (ctx) =>  AlertDialog(
      title: Text('Add Category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _categoryController,
            decoration: InputDecoration(labelText: 'Category Name'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
             
            },
            child: Text('Add Category'),
          ),
        ],
      ),
    )
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Items'),
        actions: [IconButton(onPressed: _addCategory, icon: Icon(Icons.add))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, index)  {
            final item = _items[index];
            return Card(
              child: ListTile(
                title: Text(item.title),
                subtitle: Text(
                  'Retail: ${item.retailPrice} | Wholesale: ${item.wholesalePrice} | Quantity: ${item.quantity}',
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _items.removeAt(index);
                    });
                    Fluttertoast.showToast(
                      msg: 'Item deleted successfully',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
