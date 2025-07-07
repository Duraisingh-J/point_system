enum Quantity {
  kg, g, pcs, pkt, bag
}

class Item {
  final String title;
  final double retailPrice;
  final Quantity quantity;
  

  const Item({
    required this.title,
    required this.retailPrice,
    required this.quantity,
  });
}
