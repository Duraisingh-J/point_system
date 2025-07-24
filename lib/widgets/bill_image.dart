import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:point_system/datamodel/item.dart';
import 'package:point_system/datamodel/shop.dart';

class BillImage extends StatelessWidget {
  final List<Item> items;
  final Shop shop;
  final GlobalKey billPdfKey;
  const BillImage({
    super.key,
    required this.items,
    required this.shop,
    required this.billPdfKey,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: billPdfKey,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Shop Name: XYZ Shop',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3),
            Text(
              'Phone Number: 1234567890',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
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
                    Text(shop.name, style: TextStyle(fontSize: 10)),
                    SizedBox(height: 2),
                    Text('+91 ${shop.phno}', style: TextStyle(fontSize: 10)),
                  ],
                ),
                Text(
                  'Date: ${DateTime.now().toLocal().toString().split(' ')[0]}',
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(color: Colors.black, thickness: 1, height: 20),
    
            SizedBox(height: 10),
    
            // Header Row
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 6.0,
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
                  SizedBox(width: 7.0),
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
                      textAlign: TextAlign.end,
                    ),
                  ),
                  SizedBox(width: 8.0),
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
    
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 6.0,
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
