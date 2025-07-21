import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:point_system/datamodel/shop.dart';

class ShopsProvider extends AutoDisposeNotifier<List<Shop>> {
  List<Shop> _allShops = [];
  final DatabaseReference _ref = FirebaseDatabase.instance.ref('shops');

  @override
  List<Shop> build() {
    fetchShop();
    listeningShopAdding();

    return [];
  }

  void addShop(Shop shop) async {
    ref.read(shopLoadingProvider.notifier).state = true;
    try {
      final exists = _allShops.any((eShop) => eShop.id == shop.id);
      if (exists) {
        Fluttertoast.showToast(
          msg: 'Shop with this ID already exists',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }
      await _ref.child(shop.id).set({'name': shop.name, 'phno': shop.phno});
      Fluttertoast.showToast(
        msg: '${shop.name} Shop Added Successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[200],
        textColor: Colors.black,
        fontSize: 16.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to add shop: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      ref.read(shopLoadingProvider.notifier).state = false;
    }
  }

  void fetchShop() async {
    final snapshot = await _ref.get();
    final data = (snapshot.value as Map).cast<String, dynamic>();
    final shops = data.entries.map((e) {
      final shopData = Map<String, dynamic>.from(e.value);
      return Shop(id: e.key, name: shopData['name'], phno: shopData['phno']);
    }).toList();

    _allShops = shops;
    state = shops;
  }

  void listeningShopAdding() async {
    _ref.onValue.listen((event) {
      final data = (event.snapshot.value as Map).cast<String, dynamic>();
      final shops = data.entries.map((e) {
        final shopData = Map<String, dynamic>.from(e.value);
        return Shop(id: e.key, name: shopData['name'], phno: shopData['phno']);
      }).toList();

      _allShops = shops;
      state = shops;
    });
  }

  void searchShop(String query) {
    final filteredShops = _allShops
        .where(
          (shop) =>
              shop.name.toLowerCase().contains(query.trim().toLowerCase()),
        )
        .toList();

    state = filteredShops;
  }
}

final shopsProvider = AutoDisposeNotifierProvider<ShopsProvider, List<Shop>>(
  ShopsProvider.new,
);

final shopLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);
