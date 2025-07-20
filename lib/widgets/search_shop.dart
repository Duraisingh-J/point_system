import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    
    _shopController.addListener(_shopsToDisplay);
  }

  @override
  void dispose() {
    _shopController.dispose();
    super.dispose();
  }

  void _shopsToDisplay() {
    final query = _shopController.text.trim().toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 8.0, 10),
          child: TextFormField(
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
        );
  }
}
