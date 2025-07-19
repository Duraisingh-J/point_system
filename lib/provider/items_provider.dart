import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:point_system/datamodel/item.dart';

class ItemsProvider extends AutoDisposeNotifier<List<Item>?> {
  late final DatabaseReference _ref;
  late final StreamSubscription<DatabaseEvent> _subscription;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  // @override
  // List<Item>? build() {
  //   _ref = FirebaseDatabase.instance.ref('items');
  //   _fetchItems();
  //   _listenToUpdates();

  //   ref.onDispose(() {
  //     _subscription.cancel();
  //   });

  //   return null;
  // }

  // void _fetchItems() async {
  //   final snapshot = await _ref.get();
  //   final data = snapshot.value as Map<String, dynamic>?;
  //   if (data != null) {
  //     final items = data.entries.map((e) {
  //       final itemData = Map<String, dynamic>.from(e.value);
  //       return Item(
  //         id: e.key,
  //         title: itemData['title'] ?? '',
  //         retailPrice: (itemData['retailPrice'] ?? 0).toDouble(),
  //         quantity: Quantity.values.firstWhere(
  //           (q) => q.name == itemData['quantity'],
  //           orElse: () => Quantity.kg,
  //         ),
  //       );
  //     }).toList();
  //     state = items;
  //     _isLoading = false;
  //   } else {
  //     state = [];
  //   }
  // }

  @override
  List<Item>? build() {
    _ref = FirebaseDatabase.instance.ref('items');
    _fetchItems();
    _listenToUpdates();

    ref.onDispose(() {
      _subscription.cancel();
    });

    return null;
  }

  void _fetchItems() async {
    final snapshot = await _ref.get();
    final data = (snapshot.value as Map).cast<String, dynamic>();
    final items = data.entries.map((e) {
      final itemData = Map<String, dynamic>.from(e.value);
      return Item(
        id: e.key,
        title: itemData['title'] ?? '',
        retailPrice: (itemData['retailPrice'] ?? 0).toDouble(),
        quantity: Quantity.values.firstWhere(
          (q) => q.name == itemData['quantity'],
          orElse: () => Quantity.kg,
        ),
      );
    }).toList();
    state = items;
    _isLoading = false;
    }

  void _listenToUpdates() {
    _subscription = _ref.onValue.listen((event) {
      final data = (event.snapshot.value as Map).cast<String, dynamic>();
      final items = data.entries.map((e) {
        final itemData = Map<String, dynamic>.from(e.value);
        return Item(
          id: e.key,
          title: itemData['title'] ?? '',
          retailPrice: (itemData['retailPrice'] ?? 0).toDouble(),
          quantity: Quantity.values.firstWhere(
            (q) => q.name == itemData['quantity'],
            orElse: () => Quantity.kg,
          ),
        );
      }).toList();
      state = items;
        });
  }

  void addItem(Item newItem) {
    DatabaseReference ref = FirebaseDatabase.instance.ref(('items'));

    ref.child(newItem.id).set({
      'title': newItem.title,
      'retailPrice': newItem.retailPrice,
      'quantity': newItem.quantity.name,
    });
  }
}

final itemsProvider = AutoDisposeNotifierProvider<ItemsProvider, List<Item>?>(
  ItemsProvider.new,
);
