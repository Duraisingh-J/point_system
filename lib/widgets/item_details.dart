import 'package:flutter/material.dart';
import 'package:point_system/datamodel/item.dart';
import 'package:point_system/widgets/update_item.dart';

class ItemDetails extends StatefulWidget {
  final Item item;
  const ItemDetails({required this.item, super.key});

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  bool isTapped = false;
  final _quantityController = TextEditingController();
  Quantity _selectedQuantity = Quantity.kg;

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: isTapped
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Price: ₹${widget.item.retailPrice}/${widget.item.quantity.name}',
                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Text(
                        'Quantity : ',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: TextFormField(
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 100,
                        height: 60,
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
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        'Rs. ${widget.item.retailPrice.toDouble() * (double.tryParse(_quantityController.text) ?? 0.0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isTapped = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Add to Bill'),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : ListTile(
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    return UpdateItem(widget.item);
                  },

                );
              },
              onTap: () {
                setState(() {
                  isTapped = true;
                });
              },
              title: Text(
                widget.item.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                'Price: ₹${widget.item.retailPrice}',
                style: const TextStyle(fontSize: 15, color: Colors.black54),
              ),
            ),
    );
  }
}
