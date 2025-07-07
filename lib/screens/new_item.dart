import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  late String _itemName;
  late double _retailPrice;
  late double _wholesalePrice;
  String _quantity = 'kg';

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Fluttertoast.showToast(
        msg: 'Item saved successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'New Item Screen',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: 'Item Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => 
                        value == null || value.isEmpty
                            ? 'Please enter an item name'
                            : null,
                  ),
                  SizedBox(height: 10),
                  
                  DropdownButtonFormField<String>(
                    value: _quantity,
                    items: const [
                      DropdownMenuItem(value: 'kg', child: Text('kg')),
                      DropdownMenuItem(value: 'g', child: Text('g')),
                      DropdownMenuItem(value: 'pcs', child: Text('pcs')),
                      DropdownMenuItem(value: 'pkt', child: Text('pkt')),
                      DropdownMenuItem(value: 'bag', child: Text('bag')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _quantity = value!;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Quantity', border: OutlineInputBorder()),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Retail Price',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            _retailPrice = double.tryParse(value!) ?? 0.0;
                          },
                          validator: (value) => 
                              value == null || value.isEmpty
                                  ? 'Please enter a retail price'
                                  : null,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Wholesale Price',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            _wholesalePrice = double.tryParse(value!) ?? 0.0;
                          },
                          validator: (value) => 
                              value == null || value.isEmpty
                                  ? 'Please enter a wholesale price'
                                  : null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: _saveItem,
                        child: Text('Save Item'),
                      ),
                      
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
