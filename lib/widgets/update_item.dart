import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:point_system/datamodel/item.dart';


class UpdateItem extends StatefulWidget {
  final Item item;
  const UpdateItem(this.item, {super.key});

  @override
  State<UpdateItem> createState() => _UpdateItemState();
}

class _UpdateItemState extends State<UpdateItem> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late Quantity _selectedQuantity;
  bool isUpdating = false;
  

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.title);
    _priceController = TextEditingController(
      text: widget.item.retailPrice.toString(),
    );
    _selectedQuantity = widget.item.quantity;
  }

  void _updateItem() async {
    final String name = _nameController.text.trim();
    final String priceText = _priceController.text.trim();

    if (name.isEmpty || priceText.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final double? price = double.tryParse(priceText);
    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid price')),
      );
      return;
    }

    setState(() {
      isUpdating = true;
    });

    try {
      if (widget.item.id.isEmpty) {
        throw Exception('Item ID is missing');
      }
     final DatabaseReference ref = FirebaseDatabase.instance.ref('items/${widget.item.id}');
     
      await ref.update({
        'title': name,
        'retailPrice': price,
        'quantity': _selectedQuantity.name,
      });

      if (mounted) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$name updated successfully!')));
        Navigator.of(context).pop(true); // Return true to indicate success
      } else {
        throw Exception('Failed to update item');
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating item: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isUpdating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Update Item',
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      actions: [
        Column(
          children: [
            TextField(
              maxLines: null,
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
                      prefixText: '₹',
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
                    onPressed: isUpdating ? null : _updateItem,
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
                    child: isUpdating
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Update Item'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
