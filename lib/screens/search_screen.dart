import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:point_system/provider/items_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _itemController = TextEditingController();
  List<String> _items = [];

  @override
  void initState() {
    super.initState();
    
    _itemController.addListener(_itemsToDisplay);
  }

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }

  void _itemsToDisplay() {
    final query = _itemController.text.trim().toLowerCase();
    ref.read(itemsProvider.notifier).searchItems(query);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 8.0, 10),
          child: TextFormField(
            controller: _itemController,
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
              suffixIcon: _itemController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _itemController.clear();
                        ref.read(itemsProvider.notifier).searchItems('');
                      },
                    )
                  : null,
            ),
          ),
        );
  }
}
