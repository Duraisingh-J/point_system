import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:point_system/provider/shops_provider.dart';

class SearchShop extends ConsumerStatefulWidget {
  const SearchShop({super.key});

  @override
  ConsumerState<SearchShop> createState() => _SearchShopState();
}

class _SearchShopState extends ConsumerState<SearchShop> {
  final _shopController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _shopController.addListener(() {
      ref.read(shopsProvider.notifier).searchShop(_shopController.text);
    });
  }

  @override
  void dispose() {
    _shopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shops = ref.watch(shopsProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 8.0, 10),
      child: Column(
        children: [
          TextFormField(
            controller: _shopController,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.primary,
              ),
          
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              hintText: 'Type to search....',
          
              suffixIcon: _shopController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _shopController.clear();
                      },
                    )
                  : null,
            ),
          
          ),
         if (_shopController.text.isNotEmpty) ...[
    if (shops.isEmpty)
      Center(
        child: Text(
          'No shops found',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 16,
          ),
        ),
      )
    else
      Flexible(
        child: ListView.builder(
          itemCount: shops.length,
          itemBuilder: (context, index) {
            final shop = shops[index];
            return Card(
              child: ListTile(
                title: Text(shop.name),
                onTap: () {
                  ref.read(shopProvider.notifier).setShop(shop);
                  _shopController.clear();
                  FocusScope.of(context).unfocus();
                },
              ),
            );
          },
        ),
      ),
    ],
        
        ],
      ),
    );
  }
}
