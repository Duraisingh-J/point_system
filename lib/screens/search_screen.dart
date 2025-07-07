import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _itemController = TextEditingController();
 // List<String> _items = [];

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
    print('Searching for: ${_itemController.text}');
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
            ),
          ),
        );
  }
}
