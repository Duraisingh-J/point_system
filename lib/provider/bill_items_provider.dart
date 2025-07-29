import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:point_system/datamodel/item.dart';

class BillItemsProvider extends StateNotifier<List<Item>> {
  BillItemsProvider() : super([]);

  void addItem(Item item) {
    final isExisting = state.any((i) => i.id == item.id);
    if (!isExisting) {
      state = [...state, item];
    } else {
      state = state.map((i) {
        if (i.id == item.id) {
          return Item.withTotalPrice(
            id: i.id,
            quantityInGrams: (item.selectedQuantity.name == 'g' ? item.quantityInGrams / 1000 : item.selectedQuantity.name == 'kg' && i.selectedQuantity.name == 'g' ? i.quantityInGrams / 1000 : item.quantityInGrams) + ((item.selectedQuantity.name == 'kg' && i.selectedQuantity.name == 'g') ? item.quantityInGrams : i.quantityInGrams),
            title: i.title,
            retailPrice: i.retailPrice,
            selectedQuantity: i.quantity,
            quantity: i.quantity,
            totalPrice: (item.selectedQuantity.name == 'g' ? item.totalPrice / 1000 : item.totalPrice) + i.totalPrice,
          );
        }
        return i;
      }).toList();
    }
  }

  void removeItem(Item item) {
    state = state.where((i) => i.id != item.id).toList();
  }

  void clearItems() {
    state = [];
  }
}

final billItemsProvider = StateNotifierProvider<BillItemsProvider, List<Item>>(
  (ref) => BillItemsProvider(),
);
