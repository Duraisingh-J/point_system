import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:point_system/datamodel/item.dart';

class BillItemsProvider extends StateNotifier<List<Item>> {
  BillItemsProvider() : super([]);

  void addItem(Item item) {
    state = [...state, item];
  }

  void removeItem(Item item) {
    state = state.where((i) => i.id != item.id).toList();
  }

  void clearItems() {
    state = [];
  }
}


final billItemsProvider = StateNotifierProvider<BillItemsProvider, List<Item>>((ref) => BillItemsProvider());