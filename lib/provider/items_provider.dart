import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:point_system/datamodel/item.dart';

class ItemsProvider extends StateNotifier<List<Item>> {
  ItemsProvider() : super([]);

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  void fetchItems() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('items');
    final items = await ref.get();
    if (!items.exists) {
      state = [];
    }
    final Map<String, dynamic> itemData = (items.value as Map)
        .cast<String, dynamic>();
    for (final item in itemData.entries) {
      state = [
        ...state,
        Item(
          id: item.key,
          title: item.value['title'],
          retailPrice: item.value['retailPrice'].toDouble(),
          quantity: Quantity.values.firstWhere(
            (quantity) => quantity.name == item.value['quantity'],
          ),
        ),
      ];
    }
    _isLoading = false;
  }

  void addItem(Item newItem) {
    DatabaseReference ref = FirebaseDatabase.instance.ref(('items'));

    ref.child(newItem.id).set({
      'title': newItem.title,
      'retailPrice': newItem.retailPrice,
      'quantity': newItem.quantity.name,
    });

    state = [...state, newItem];
  }
}

final itemsProvider = StateNotifierProvider<ItemsProvider, List<Item>>(
  (ref) => ItemsProvider(),
);
