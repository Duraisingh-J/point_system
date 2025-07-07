
import 'dart:ffi';

enum Quantity {
  kg, g, pcs, pkt, bag
}

class Item {
  final String title;
  final Double retailPrice;
  final Double wholesalePrice;
  final Quantity quantity;
  

  const Item({
    required this.title,
    required this.retailPrice,
    required this.wholesalePrice,
    required this.quantity,
  });
}
