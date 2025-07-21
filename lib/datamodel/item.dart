import 'package:uuid/uuid.dart';

final uuid = Uuid();

enum Quantity { kg, g, pcs, pkt, bag }

class Item {
  final String id;
  final String title;
  late final double retailPrice;
  late final double totalPrice;
  late final String quantityInGrams;
  late final Quantity selectedQuantity;
  final Quantity quantity;

  Item({
    required this.id,
    required this.title,
    required this.retailPrice,
    required this.quantity,
  });

  Item.create({
    required this.title,
    required this.retailPrice,
    required this.quantity,
  }) : id = uuid.v4();

  Item.withTotalPrice({
    required this.id,
    required this.title,
    required this.quantityInGrams,
    required this.retailPrice,
    required this.selectedQuantity,
    required this.quantity,
    required this.totalPrice, 
  });
}
