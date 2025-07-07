import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:point_system/datamodel/item.dart';
import 'package:http/http.dart' as http;

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  bool isAdding = false;
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  Quantity _selectedQuantity = Quantity.kg;

  void _addItem() async {
    final String name = _nameController.text.trim();
    final String priceText = _priceController.text.trim();

    if (name.isEmpty || priceText.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Fill the fields',
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }
    final double? price = double.tryParse(priceText);
    if (price == null) {
      Fluttertoast.showToast(
        msg: 'Please enter a valid retail price',
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }
    setState(() {
      isAdding = true;
    });

    final url = Uri.https(
      'pointsystem-accbd-default-rtdb.asia-southeast1.firebasedatabase.app',
      'items.json',
    );
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': name,
        'retailPrice': price,
        'quantity': _selectedQuantity.name,
      }),
    );
    print(response.body);
    Fluttertoast.showToast(
      msg: '${name} added successfully!',
      toastLength: Toast.LENGTH_SHORT,
    );
    if (!context.mounted) {
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Adding Item',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: 350,
          height: 380,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'New Item',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Retail Price',
                        prefixText: 'Rs. ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<Quantity>(
                      value: _selectedQuantity,
                      items: Quantity.values.map((quantity) {
                        return DropdownMenuItem(
                          value: quantity,
                          child: Text(quantity.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedQuantity = value!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _addItem,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        elevation: 3,
                      ),
                      child: isAdding
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Add Item'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
