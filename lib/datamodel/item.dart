import 'package:uuid/uuid.dart';

final uuid = Uuid();

enum Quantity { kg, g, pcs, pkt, bag }

class Item {
  final String id;
  final String title;
  late final double retailPrice;
  late final double totalPrice;
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
    required this.retailPrice,
    required this.quantity,
    required this.totalPrice, 
  });
}
