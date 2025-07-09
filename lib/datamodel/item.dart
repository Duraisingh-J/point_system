import 'package:uuid/uuid.dart';

final uuid = Uuid();

enum Quantity { kg, g, pcs, pkt, bag }

class Item {
  final String id;
  final String title;
  final double retailPrice;
  final Quantity quantity;

  Item({
    required this.title,
    required this.retailPrice,
    required this.quantity,
  }) : id = uuid.v4();
}
