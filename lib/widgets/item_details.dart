import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:point_system/datamodel/item.dart';
import 'package:point_system/provider/bill_items_provider.dart';
import 'package:point_system/widgets/update_item.dart';

class ItemDetails extends ConsumerStatefulWidget {
  final Item item;
  const ItemDetails({required this.item, super.key});

  @override
  ConsumerState<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends ConsumerState<ItemDetails> {
  bool isTapped = false;
  late double _price;
  late TextEditingController _quantityController;
  late Quantity _selectedQuantity;

  @override
  void initState() {
    super.initState();
    _price = widget.item.retailPrice.toDouble();
    _selectedQuantity = widget.item.quantity;
    _quantityController = TextEditingController(text: "1");
    _quantityController.addListener(_priceUpdate);
  }

  void _priceUpdate() {
    double basePrice = widget.item.retailPrice.toDouble();
    double quantity = double.tryParse(_quantityController.text) ?? 0.0;

    setState(() {
      if (widget.item.quantity == Quantity.kg &&
          _selectedQuantity == Quantity.g) {
        _price = basePrice * quantity / 1000;
      } else {
        _price = basePrice * quantity;
      }
    });
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: Theme.of(context).colorScheme.surface,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: isTapped
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
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
                      isTapped = !isTapped;
                    });
                  },
                  title: Text(
                    widget.item.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Text(
                    'Price: ₹${widget.item.retailPrice}',
                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                  child: Column(
                    children: [
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
                            height: 45,
                            width: 60,
                            child: TextFormField(
                              controller: _quantityController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 100,
                            height: 45,
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
                                _priceUpdate();
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
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
                            '₹${_price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isTapped = false;
                              });
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
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isTapped = false;
                                ref.read(billItemsProvider.notifier).addItem(Item.withTotalPrice(id: widget.item.id, quantityInGrams: double.tryParse(_quantityController.text) ?? 0.0, title: widget.item.title, retailPrice: widget.item.retailPrice, selectedQuantity: _selectedQuantity, quantity: widget.item.quantity, totalPrice: _price));
                              });
                              Fluttertoast.showToast(
                                msg: "Item added to bill",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.white70,
                                textColor: Colors.black,
                                fontSize: 16.0,
                              );
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
                            child: const Text('Add to Bill'),),
                           
                          
                        ],
                      ),
                    ],
                  ),
                ),
              ],
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
                  isTapped = !isTapped;
                });
              },
              title: Text(
                widget.item.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: Text(
                'Price: ₹${widget.item.retailPrice}',
                style: const TextStyle(fontSize: 15, color: Colors.black54),
              ),
            ),
    );
  }
}
