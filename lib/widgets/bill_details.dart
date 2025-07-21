import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:point_system/provider/bill_items_provider.dart';

class BillDetails extends ConsumerStatefulWidget {
  const BillDetails({super.key});

  @override
  ConsumerState<BillDetails> createState() => _BillDetailsState();
}

class _BillDetailsState extends ConsumerState<BillDetails> {
  //final _shopNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(billItemsProvider);
    if (items == null || items.isEmpty) {
      return Center(
        child: Text(
          'No items in the bill',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Shop Name: XYZ Shop',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 3),
            Text(
              'Phone Number: 1234567890',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
        
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'To',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text('Customer Name', style: TextStyle(fontSize: 10)),
                    SizedBox(height: 2),
                    Text(
                      'Phone Number: 9876543210',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                Spacer(),
                Text(
                  'Date: ${DateTime.now().toLocal().toString().split(' ')[0]}',
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(color: Colors.black, thickness: 1, height: 20),
        
            SizedBox(height: 10),
        
            Column(
              children: [
                // Header Row
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 8.0,
                  ),
                  child: Row(
                    children: const [
                      Expanded(
                        flex: 5,
                        child: Text(
                          'Name',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Qty',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Price',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                DottedLine(
                  direction: Axis.horizontal,
                  lineLength: double.infinity,
                  lineThickness: 1,
                  dashLength: 4,
                ),
        
                const SizedBox(height: 10),
        
                // Items List
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 8.0,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: GestureDetector(
                          onLongPress: () => showDialog(
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                title: Text('Remove Item'),
                                content: Text(
                                  'Are you sure you want to remove ${item.title}?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.grey[700],
                                      backgroundColor: Colors.grey[200],
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          8,
                                        ),
                                      ),
                                    ),
                                    child: Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      ref
                                          .read(billItemsProvider.notifier)
                                          .removeItem(item);
                                      Navigator.of(ctx).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.red,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          8,
                                        ),
                                      ),
                                    ),
                                    child: Text('Remove'),
                                  ),
                                ],
                              );
                            },
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Text(
                                  item.title,
                                  softWrap: true,
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  '${item.quantityInGrams}${item.selectedQuantity.name}',
                                  style: TextStyle(fontSize: 10),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  '${item.retailPrice}/${item.quantity.name}',
                                  style: TextStyle(fontSize: 10),
        
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  item.totalPrice.toString(),
                                  style: TextStyle(fontSize: 10),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            DottedLine(
              direction: Axis.horizontal,
              lineLength: double.infinity,
              lineThickness: 1,
              dashLength: 4,
            ),
        
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Total Amount',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  '${items.fold(0.0, (sum, item) => (sum + item.totalPrice).toDouble())}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
        
                SizedBox(width: 10),
              ],
            ),
        
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blueGrey, width: 2),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Point',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '100',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
